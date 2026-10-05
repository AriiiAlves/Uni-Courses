#import "./lib.typ": *

#show: project.with(
	title: "Notes on ...",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

#set heading(numbering: (..nums) => {
  let vals = nums.pos()
  if vals.len() <= 2 {
    vals.map(str).join(".") + "."
  } else {
    none
  }
})

= Úteis

- SSL Vision: https://www.informatik.uni-bremen.de/agebv2/downloads/published/zickler_rs_09.pdf
- AutoRef: https://download.tigers-mannheim.de/papers/2016-autonomous-referee-magel.pdf
- Kalman Filter: https://ieeexplore.ieee.org/document/7528889/
- Unscented Kalman Filter: https://groups.seas.harvard.edu/courses/cs281/papers/unscented.pdf
- Particle Filter: https://arxiv.org/pdf/1309.7807

= Checkpoint 2 - Especificação Técnica: Benchmark de Rastreamento de Alvo (Edge vs. Cloud)

Este documento especifica a arquitetura, metodologia e implementação para avaliar o *trade-off* de desempenho entre processamento embarcado (*Edge*) e processamento em servidor (*Cloud*), utilizando o módulo **ESP32-CAM (AI-Thinker)** com sensor OV2640 na tarefa de detecção e rastreamento de centróide por cor.

---

== 1. Visão Geral do Sistema

O objetivo é medir o impacto de latência ponta a ponta, vazão de quadros (*throughput*), consumo de banda e jitter em dois cenários concorrentes executando a mesma tarefa: **determinar o centróide 2D $(C_x, C_y)$ de um alvo esférico colorido**.

```
[Alvo Visual] 
      │
      ▼
┌──────────────┐      Pipeline Onboard (Edge)      ┌──────────────────┐
│  ESP32-CAM   │ ───────────────────────────────── │ Telemetria Leve  │
│   (OV2640)   │    Payload: ~16 bytes (UDP/MQTT)  │  (Dashboard/PC)  │
└──────────────┘                                   └──────────────────┘
      │
      │ Pipeline On Cloud
      │ Payload: ~15-30 KB JPEG (HTTP POST / WebSocket)
      ▼
┌──────────────┐                                   ┌──────────────────┐
│ Backend Srv  │ ───────────────────────────────── │ OpenCV Centroid  │
│  (FastAPI)   │          Inferência Externa       │  (Dashboard/PC)  │
└──────────────┘                                   └──────────────────┘

```

---

== 2. Topologia de Hardware e Configurações

* **Microcontrolador:** ESP32-CAM (Xtensa Dual-Core 32-bit LX6 @ 240 MHz, 520 KB SRAM interna + 4 MB PSRAM externa).
* **Sensor de Imagem:** Omnivision OV2640.
* **Comunicação:** Wi-Fi 802.11 b/g/n (2.4 GHz) conectado a um Access Point local dedicado (para mitigar ruído externo de RF).
* **Servidor Local / Nuvem:** Máquina x86_64 na mesma sub-rede (ou instância cloud via túnel/VPN) executando Python 3.10+.

---

== 3. Arquitetura dos Pipelines

=== Pipeline A: Onboard (Edge Processing)

1. **Aquisição:** O sensor OV2640 captura o quadro diretamente no formato nativo `PIXFORMAT_RGB565` na resolução **QQVGA ($160 \times 120$)**.
2. **Armazenamento:** O framebuffer de 38,4 KB ($160 \times 120 \times 2$ bytes) é alocado preferencialmente na SRAM interna para evitar a latência de barramento SPI da PSRAM.
3. **Varredura e Extração (Single-pass):**
* O algoritmo itera diretamente pelos pixels em formato RGB565.
* Aplica-se uma máscara booleana direta (exemplo para detecção de vermelho):

$$R > 180 \quad \land \quad G < 80 \quad \land \quad B < 80$$


* Para cada pixel válido, acumulam-se os momentos espaciais:

$$M_{00} \leftarrow M_{00} + 1, \quad M_{10} \leftarrow M_{10} + x, \quad M_{01} \leftarrow M_{01} + y$$


* Se $M_{00} \ge \text{Área\_Mínima}$, calcula-se:

$$C_x = \frac{M_{10}}{M_{00}}, \quad C_y = \frac{M_{01}}{M_{00}}$$




4. **Transmissão:** Envio de pacote binário leve via **UDP** ou **MQTT** contendo timestamp, coordenadas e área:
* Formato do payload: `{"ts": uint32, "x": uint16, "y": uint16, "area": uint16, "t_proc_us": uint32}` (~16–24 bytes).



=== Pipeline B: On Cloud (Server-side Processing)

1. **Aquisição:** O sensor OV2640 captura em modo nativo `PIXFORMAT_JPEG` na resolução **QVGA ($320 \times 240$)** ou **QQVGA ($160 \times 120$)**, com fator de compressão JPEG fixado (`jpeg_quality = 12`).
2. **Transmissão de Mídia:**
* O ESP32 despacha o buffer JPEG bruto via requisição `HTTP POST (multipart/form-data)` ou streaming contínuo via `WebSocket`.


3. **Processamento no Backend (Python / OpenCV):**
* Decodificação do buffer de imagem para matriz NumPy (BGR).
* Conversão de espaço de cores: `cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)`.
* Segmentação binária via `cv2.inRange(hsv, lower_bound, upper_bound)`.
* Cálculo de momentos espaciais com `cv2.moments(mask)`.
* Derivação do centróide $(C_x, C_y)$.


4. **Retorno:** Resposta JSON com timestamp original, coordenadas e latência de processamento no servidor.

---

== 4. Métricas e Metodologia de Coleta

Para garantir validade estatística, cada teste deve ser executado continuamente por um lote mínimo de **1.000 amostras (frames)** sob condições de iluminação estáveis.

| Métrica | Definição Operacional | Unidade |
| --- | --- | --- |
| **Latência Fim-a-Fim ($T_{\text{e2e}}$)** | Tempo transcorrido desde o início da captura no sensor até a coordenada estar consolidada no consumidor final. | Milissegundos (ms) |
| **Taxa de Quadros (*Throughput*)** | Quantidade de iterações/inferências processadas com sucesso por unidade de tempo. | FPS (Frames/s) |
| **Consumo de Banda de Rede** | Volume total de dados trafegados na interface Wi-Fi por segundo. | KB/s ou MB/h |
| **Variação de Atraso (*Jitter*)** | Desvio padrão da latência fim-a-fim ($\sigma_{T_{\text{e2e}}}$). | Milissegundos (ms) |
| **Tempo de Processamento Útil ($T_{\text{proc}}$)** | Tempo estrito de CPU dedicado à extração do centróide (excluindo I/O de rede e exposição de câmera). | Milissegundos (ms) |

---

== 5. Implementação de Referência

=== Firmware Onboard (Trecho Central de Algoritmo em C++)

```cpp
#include "esp_camera.h"

struct CentroidResult {
    uint16_t x;
    uint16_t y;
    uint32_t area;
    uint32_t proc_time_us;
    bool detected;
};

CentroidResult process_frame_onboard(camera_fb_t *fb) {
    CentroidResult res = {0, 0, 0, 0, false};
    if (!fb || fb->format != PIXFORMAT_RGB565) return res;

    uint32_t start_us = micros();
    uint32_t m00 = 0;
    uint32_t m10 = 0;
    uint32_t m01 = 0;

    const uint16_t *pixels = (const uint16_t *)fb->buf;
    const size_t total_pixels = fb->width * fb->height;

    for (size_t i = 0; i < total_pixels; ++i) {
        uint16_t p = pixels[i];

        // Extrai canais RGB de 16 bits (formato 5-6-5)
        uint8_t r = ((p >> 11) & 0x1F) << 3;
        uint8_t g = ((p >> 5) & 0x3F) << 2;
        uint8_t b = (p & 0x1F) << 3;

        // Limiar de cor: Vermelho predominante
        if (r > 150 && g < 80 && b < 80) {
            uint16_t x = i % fb->width;
            uint16_t y = i / fb->width;
            m00++;
            m10 += x;
            m01 += y;
        }
    }

    if (m00 > 50) { // Filtro de ruído por área mínima
        res.x = m10 / m00;
        res.y = m01 / m00;
        res.area = m00;
        res.detected = true;
    }

    res.proc_time_us = micros() - start_us;
    return res;
}

```

---

=== Backend Python (FastAPI + OpenCV)

```python
import time
import cv2
import numpy as np
from fastapi import FastAPI, File, UploadFile

app = FastAPI()

== Limiares HSV para objeto vermelho
LOWER_HSV = np.array([0, 120, 70])
UPPER_HSV = np.array([10, 255, 255])

@app.post("/process_frame")
async def process_frame(file: UploadFile = File(...)):
    t_recv = time.perf_counter()
    contents = await file.read()
    
    # Decodificação JPEG
    np_arr = np.frombuffer(contents, np.uint8)
    frame = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    
    t_decode = time.perf_counter()
    
    # Processamento e Centróide
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    mask = cv2.inRange(hsv, LOWER_HSV, UPPER_HSV)
    moments = cv2.moments(mask)
    
    detected = False
    cx, cy, area = 0, 0, 0
    if moments["m00"] > 50:
        detected = True
        area = int(moments["m00"])
        cx = int(moments["m10"] / moments["m00"])
        cy = int(moments["m01"] / moments["m00"])
        
    t_end = time.perf_counter()
    
    return {
        "detected": detected,
        "x": cx,
        "y": cy,
        "area": area,
        "server_decode_ms": (t_decode - t_recv) * 1000.0,
        "server_process_ms": (t_end - t_decode) * 1000.0,
        "server_total_ms": (t_end - t_recv) * 1000.0
    }

```

---

== 6. Resultados Esperados e Hipóteses

1. **Throughput:** O pipeline *Onboard* deve atingir cerca de **20 a 28 FPS** (limitado pela taxa de varredura do sensor em QQVGA), enquanto o pipeline *On Cloud* ficará restrito a **5 a 10 FPS** devido ao overhead de codificação JPEG, negociação de pacotes TCP e retransmissões Wi-Fi.
2. **Latência de Ponta a Ponta:** A latência *Onboard* será determinística ($\approx 15 \text{ ms}$ a $35 \text{ ms}$ com desvio padrão baixo), enquanto a *Cloud* apresentará cauda longa de latência ($> 120 \text{ ms}$) com jitter elevado decorrente de variações no buffer de rede e no stack lwIP.
3. **Consumo de Banda:** Redução esperada de tráfego de rede superior a **99,8%** no modo *Onboard* em relação ao streaming de imagens para a *Cloud*.

