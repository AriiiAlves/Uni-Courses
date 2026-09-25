= Representação dos documentos

Considere:

- N = 1 milhão de documentos, cada um com cerca de 1000 palavras. 
- Média de 6 bytes/palavra - 6 GB para armazenamento dos documentos.
- M = 500 000 termos distintos nestes documentos. Matriz 500K x 1M tem 500 bilhões de valores. 

Já que cada documento tem cerca de 1000 palavras, então não temos mais do que 1 bilhão de valores diferentes de zero. A matriz é *extremamente esparsa*.

Como representar isso de modo eficiente? Com *índices invertidos*. Para cada termo `t`, deve-se armazenar uma lista (posting list) de todos os documentos que contêm `t`.

= BSBI: Blocked sort-based indexing

Ideia básica:

- Segmentar a coleção em blocos de igual tamanho
	- (termID, docID) - 8 bytes
	- Blocos de 10MB - Aprox. 1,25 mi registros por bloco
- Ordenar os pares (termID, docID) de cada bloco em memória
- Salvar resultados intermediários em disco
- Combinar todos os resultados intermediários em um índice final
	- Abrir todos os arquivos de blocos simultaneamente
	- Em cada iteração, selecionar o menor termo que ainda não foi processado
	- Ler e combinar todas as listas desse termo, salvando o resultado final em disco
