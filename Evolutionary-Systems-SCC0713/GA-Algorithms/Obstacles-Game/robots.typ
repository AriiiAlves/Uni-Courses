= Modelando o ambiente

- Ponto (1) define localização do robô (x,y)
- Espaço vazio (0)
- Obstáculos (2,3,4,5,6,7,8,9,10), onde cada número é um raio de círculo diferente (ou quadrado, etc)
- Ou parede!!

Estrutura do robô:

```
posicao_atual = (x,y)
sensores = (d_frente, d_esquerda, d_direita)
vetor_direcao = (x,y) (normalizado)
velocidade = v (float)
tempo_direcao = t (mantém por t rounds o vetor_direcao)

A cada round: proxima_posicao = posicao_atual + v * vetor_direcao

TABELA A SER TREINADA PELO AE

d_frente, d_esquerda, d_direita | vetor_direcao | velocidade | tempo_direcao
```

Quantizar d (de 0.1 em 0.1, por exemplo)
Objetivo: Chegar na maior distância sem bater.

Sensores - Reta (GA) que busca o elemento mais próximo, com referencial no carrinho

== Montando

X: -1 0 1
Y: -1 0 1 (0,1,2)

== Ideias da literatura pra carros

Modelo reativo de brooks

== USANDO CMAKE

Primeiro, gere uma estrutura de arquivos padrão

```
my_project/
├── CMakeLists.txt
├── include/
│   └── Player.h
└── src/
    ├── Player.cpp
    └── main.cpp
```

Depois, crie um arquivo `CMakeLists.txt` no folder root:

```
cmake_minimum_required(VERSION 3.16)

# Define project name and C++ standard
project(RobotsEvolution VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include directories (header files)
include_directories(include)

# Define the executable and its source files
add_executable(run
    src/main.cpp
    src/Player.cpp
)
```

Adicione o link de bibliotecas externas (como SDL2):

```
cmake_minimum_required(VERSION 3.16)
project(RobotsEvolution LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find system SDL2 package
find_package(SDL2 REQUIRED)

# Executable target
add_executable(run 
    src/main.cpp
    src/Player.cpp
)

# Link SDL2 to the target
target_include_directories(run PRIVATE ${SDL2_INCLUDE_DIRS} include)
target_link_libraries(run PRIVATE ${SDL2_LIBRARIES})
```

Definindo o modo debug (compila com as flags `-g -O0`):

```
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Debug)
endif()
```

Faça a build e rode comandos:

```
# 1. Configure (creates the 'build' directory and build files)
cmake -B build

# 2. Compile (builds the executable using all CPU cores)
cmake --build build -j

# 3. Run
./build/run
```

== Notas

- Aplicar uma penalidade por ficar parado ajudou a não deixar os indivíduos viciados em se esconderem em alguns cantos. Como uma penalidade de -1 é muito agressiva, apliquei uma de 0.5, para penalizar aqueles que realmente ficarem parados por muito tempo, já que o score por movimentação correta é igual a 1. O score mínimo é zero, para não afetar a roleta.
- Uma taxa de inserção de peças acima de 0.2 é muito difícil para os indivíduos aprenderem. Uma configuração bacana foi inserção de 0.2 com 3 movimentos.
- Passar a posição do robô para a rede neural faz ele viciar em certos cantos do mapa e deixa de generalizar. A solução foi deixar somente os sensores.
- A taxa de mutação deve ser de no máximo 2%, pois a cadeia de caracteres é muito longa (2% de 1000 são 20 bits)
- O jogo possui muito ruído (é muito aleatório). Escolher os melhores após n rodadas é a melhor opção, para evitar que indivíduos que tenham tido sorte sejam selecionados.
- Colocar sensores em todos os sentidos (horizontal e diagonal) melhorou o desempenho.
- O método da roleta funcionou muito melhor do que apenas escolher o melhor de todos. Como temos muitos bits para otimizar, a melhor escolha é diversificar.
- Para o método da roleta, usar logaritmo para normalizar os scores foi a melhor opção, pois muitos indivíduos morrem muito cedo, causando uma diferença enorma entre o melhor e a média.
- Implementar um algoritmo que aumenta a mutação quando a diversidade diminui ajudou no desempenho.
