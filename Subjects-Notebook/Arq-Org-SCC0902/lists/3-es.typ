1) O módulo de E/S faz a intermediação entre o processador/memória e os periféricos. Suas principais funções são: controle e temporização, comunicação com o processador (comandos, dados, estado e reconhecimento de endereço), comunicação com o dispositivo, armazenamento temporário de dados (buffer) e detecção de erros.

2) 

- Programada: O CPU fica continuamente verificando se a requisição ao dispositivo E/S deu certo (polling). 
- Interrupção: Quando a operação no dispositivo de E/S termina, este envia uma interrupção à CPU, que prossegue o comando.

Não. A entrada/saída não se torna mais rápida, mas o processador fica livre para realizar outras operações enquanto a operação E/S não termina. Isso melhora a eficiência das operações do computador.

Obs: Nos dois métodos, a CPU ainda transfere cada dado pessoalmente (por exemplo, disco -> memória). Quem elimina isso é o DMA.

3) A interface de E/S compatibiliza o periférico com o processador e a memória, resolvendo as diferenças de velocidade, formato dos dados, sinais elétricos e temporização. Assim, o processador pode se comunicar com dispositivos muito diferentes de forma padronizada, sem precisar conhecer os detalhes de cada um.