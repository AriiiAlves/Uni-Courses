import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 1. Lê o arquivo CSV gerado pelo C++
df = pd.read_csv('heap_sort.csv')

# 2. Configura a área do gráfico
plt.figure(figsize=(9, 6))

# 3. Agrupa os dados pelo campo 'type' (ex: Insertion Sort vs Heap Sort)
for alg_type, grupo in df.groupby('type'):
    plt.plot(
        grupo['size'],
        grupo['avg'],
        marker='o',      # Adiciona pontos marcados
        linestyle='-',   # Liga os pontos com linhas
        linewidth=2,
        label=alg_type   # Usa o 'type' como legenda
    )

x_func = np.linspace(100, 10000, 200)
y_upper = 2e-5 * x_func * np.log2(x_func)
y_lower = 1e-5 * x_func * np.log2(x_func)

plt.plot(
    x_func,
    y_upper,
    color='red',
    linestyle='--',
    linewidth=1.5,
    label='O(n log n) (upper)'
)
plt.plot(
    x_func,
    y_lower,
    color='green',
    linestyle='--',
    linewidth=1.5,
    label='O(n log n) (lower)'
)

# 4. Personalizações do gráfico
plt.xlabel('Tamanho da Entrada (n)', fontsize=12)
plt.ylabel('Tempo Médio (ms)', fontsize=12)
plt.title('Heap Sort', fontsize=14)
plt.legend()       # Exibe as labels de cada linha
plt.grid(True, linestyle='--', alpha=0.6)

# 5. Exibe o gráfico na tela (ou use plt.savefig('grafico.png') para salvar)
plt.show()
plt.savefig('heap_sort.png')

plt.figure(figsize=(9, 6))
df2 = pd.read_csv('insertion_sort.csv')

for alg_type, grupo in df2.groupby('type'):
    plt.plot(
        grupo['size'],
        grupo['avg'],
        marker='o',      # Adiciona pontos marcados
        linestyle='-',   # Liga os pontos com linhas
        linewidth=2,
        label=alg_type   # Usa o 'type' como legenda
    )

x_func = np.linspace(100, 10000, 200)
y_upper = 2.2e-6 * (x_func) * (x_func)
y_lower= 1e-6 * x_func

plt.plot(
    x_func,
    y_upper,
    color='red',
    linestyle='--',
    linewidth=1.5,
    label='O(n²) (upper)'
)
plt.plot(
    x_func,
    y_lower,
    color='green',
    linestyle='--',
    linewidth=1.5,
    label='O(n) (lower)'
)
# 4. Personalizações do gráfico
plt.xlabel('Tamanho da Entrada (n)', fontsize=12)
plt.ylabel('Tempo Médio (ms)', fontsize=12)
plt.title('Insertion Sort', fontsize=14)
plt.legend()       # Exibe as labels de cada linha
plt.grid(True, linestyle='--', alpha=0.6)

plt.show()
plt.savefig('insertion_sort.png')
