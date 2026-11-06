= NOTAS DE AULA

== DEEP LEARNING + GA

Algoritmos evolutivos são para otimização de parâmetros. Basicamente: Que vença o melhor!

Deep Learning aprende com um tutor (dataset).

Ideia: O robô possui sensores. Você o controla. A cada segundo, ele faz o log de todos os sensores e direção do controlador. Usa-se isso para gerar uma rede neural e ajustar o input-output ideal que tenta copiar o que o manobrista faz.

Depois, usamos GA para otimizar esses parâmetros: muta, aleatoriza, crossover.

GA SERVE PARA ENCONTRAR OS MELHORES PARÂMETROS! (Otimiza).

== TABELA VERDADE

- *$S_2$* = Sensor frente-esquerda
- *$S_1$* = Sensor frente
- *$S_0$* = Sensor frente-direita
- *$M_1$* = Acionar motor esquerdo (pra frente)
- *$M_0$* = Acionar motor direito (pra frente)

#table(
	columns: (auto, auto, auto, auto, auto),
	inset: 10pt,
	align: horizon,
	table.header(
		[*S_2*], [*S_1*], [*S_0*], [*M_1*], [*M_0*]
	),
	[0],[0],[0],[1],[1],
	[0],[0],[1],[0],[1],
	[0],[1],[0],[1],[0],
	[0],[1],[1],[0],[1],
	
	[1],[0],[0],[0],[0],
	[1],[0],[1],[0],[0],
	[1],[1],[0],[0],[0],
	[1],[1],[1],[1],[0]
)

DUAS MANEIRAS

1. Você dirige, e usa logs para treinar rede neural. A partir dos inputs discretos na rede, gera outputs e constrói uma tabela verdade que o robô segue. Depois, utiliza GA para otimizar os pesos da rede neural (aleatoriza, vence o melhor, aleatoriza de novo). O deep learning dá a base mais ou menos, e o GA otimiza por evolução.

2. GA desde o começo. Mas demora muuito mais pra convergir.

== PARA TODO ALGORITMO

- Fitness do maior de todos
- Média do fitness de toda a população

Plota gráfico ao longo de cada geração

== Diferença entre seleções

- Elitismo - Converge rápido, mas perde diversidade
- Torneio de 2 - Seleciona 2 aleatoriamente, escolhe o melhor (ou Torneio de N)
- Roleta - Meio termo entre elitismo e torneio

== Como lidar com ruído

- Ao invés de selecionar o melhor da geração, congela os parâmetros, selciona o com melhor média após x vezesrodando o mesmo experimento, e aí sim faz crossover.
- Isso só pode ser feito quando, para os mesmos parâmetros, podem haver avaliações diferentes (ruído, ambiente não controlado)
- Problema: um que mutou e era o pior e virou o melhor vai ser descartado. Assim: Melhor da média faz crossover com todos, EXCETO com o melhor da geração atual.

== Seguidor de linha

Sensor de 4 leds

- 2 centrais - Viram pouco  e andam rápido (ajuste local, andar no reto e curvas suaves)
- 2 distantes - Viram muito e andam lento (curvas fechadas)

== Algoritmo Genético vs Algoritmo Evolutivo

Só é algoritmo genético se usar roleta!!
