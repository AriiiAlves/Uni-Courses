## Projeto Experimental

Dado o projeto definido como a extração da posição (x,y) de uma bola laranja com ESP32-CAM, a avaliação do projeto experimental consiste na definição de métrcas que explorem dois aspectos principais: a qualidade da extração da posição (x,y) e a qualidade do processamento de dados. Além disso, a avaliação através da métrica será possível através da variação de parâmetros inerentes aos dois sistemas implementados.

### Definição de métricas

Para medir a qualidade da extração da posição (x,y), será adotada uma trajetória estática que permita fixar pixels da imagem. Por exemplo, uma trajetória horizontal em eixos x ou y fixos, de modo que somente um dos eixos varie, anotando os pixels correspondentes ao eixo e definindo a distância euclidiana definida pelo algoritmo do eixo de referência. Assim, é possível converter uma das coordenadas em pixels de forma determinística. Determinar a qualidade da tarefa é importante, pois a mudança de arquitetura (edge/cloud) ou variação de parâmetros da rede pode afetar drasticamente a qualidade da tarefa em si, e é importante correlacionar estes dados.

Quanto à qualidade do processamento dos dados, a medição se subdivide entre os dois sistemas: edge e cloud. Mas, apesar das diferenças de arquitetura, eles carregam fatores em comuns importantes para determinar a qualidade do sistema:

1. Latência de Rede: Tempo gasto no tráfego de mensagens MQTT pela rede Wi-Fi/IP para o sistema implementado na cloud.
2. Tempo de processamento: Tempo gasto no processamento do filtro para determinação da posição x,y da bola no edge/cloud
3. Latência Total: Tempo total desde a captura da imagem na ESP32-CAM até o armazenamento/processamento final (incluindo tempo de processamento de cada algoritmo e de publicação e entrega via MQTT). Soma-se a Latência de rede com o tempo de processamento.
4. Consumo de Energia no Edge: Medido em miliwatts-hora, definido pelo consumo agregado de Microprocessador + ESP32-CAM.
5. Uso de CPU e Memória RAM: Carga de processamento exigida para rodar os filtros no Edge/Nuvem e picos de consumo de memória, caracterizando gargalo e correlação com aumento na latência total.
6. Taxa de Quadros: Número de imagens processadas por segundo no edge/cloud.

### Variação de parâmetros experimentais

Para os dois sistemas, foram definidos dois parâmetros principais, que serão variados de modo a avaliar extremos e possibilitar uma análise completa da qualidade dos sistemas.

1. Frequência de Transmissão: A frequência de transmissão da imagem da ESP32-CAM será alternada em X, Y, Z, de modo a incrementar latência na rede na cloud e maior gargalo de processamento no edge.
2. Filtros do algoritmo: Os filtros serão alternados entre Kalman Filter (KF), Unscented Kalman Filter (UKF) e Particle Filter (PF), de modo a avaliar como o custo do algoritmo interfere na qualidade do sistema. O Filtro KF é o mais leve, seguido pelo Unscented Kalman Filter, ambos de complexidade ordem cúbica. O algoritmo mais pesado é o Particle Filter, a depender da quantidade de partículas definidas, consumindo também uma quantidade maior de memória RAM.

### Métrica de avaliação final

Para o projeto, a transmissão de ida de dados consiste em pacotes pesados de imagens. Já a transmissão de volta consiste apenas na coordenada (x,y) identificada, podendo ser acompanhada de metadados. Uma vez que é esperado que a transmissão de dados de ida seja mais pesada do que a de volta, definimos a taxa de entrada/saída de uma dada aplicação, ou seletividade, como sendo:

$ \sigma = \frac{T_t(S_i)}{T_t(S_O)} $

Onde $T_t(S_O)$ é o tempo de transmissão da saída de dados, e $T_t(S_i)$ é o tempo de transmissão da entrada de dados. A seletividade mede a qualidade da transmissão de dados. $sigma > 1$ é bom: significa que o tempo do input é maior do que o do output, ou seja, envia-se um dado pesado e recebe-se um dado leve, o que reduz o tráfego de rede e otimiza a largura de banda. $sigma < 1$ é ruim: significa que o output gerado é mais pesado e demorado para transmitir do que o input original, o que gera um gargalo na rede.

Agora, definimos a taxa entre computação e comunicação baseada na cloud como sendo:

$ \gamma_C = \frac{T_C}{T_t} $

Onde $T_C$ é o tempo de computação do algoritmo na cloud e $T_t$ é o tempo total de transmissão de dados (ida e volta). A taxa de computação-comunicação concatena as métricas de computação e latência de rede em uma análise dedicada.

Define-se a proporção de processamento entre cloud-edge como:

$ \alpha = \frac{T_E}{T_C}  \geq 1 $

Admitindo-se que o tempo de processamento em cloud sempre será mais rápido que no edge.

Por fim, temos o rendimento do edge comparado ao cloud:

$ \eta_E = \frac{\gamma + 1}{\alpha \gamma + \frac{1}{sigma}} $

Se $\eta_E > 1$, o edge é a melhor opção. Essa condição é atingida para $\alpha$ pequeno, o que aponta um tempo similar de processamento entre edge e cloud, e para $\gamma$ pequeno, que define que o tempo de transferência domina sobre o tempo de processamento

Portanto, a execuçãoo no edge é mais rápida quando:

$ n_E > 1, \gamma(\alpha - 1) + \frac{1}{\sigma} < 1 $
