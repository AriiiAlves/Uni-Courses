1)

A - 12 14 14 16 16  18 18 20
B - 14 16 18 20 20 22 24 26

Seguem distribuição normal. Variâncias desconhecidas, mas iguais.

a) O sistema A possui tempos menores do que o sistema B, considerando o conjunto, com uma mediana em A de 16 minutos, 4 minutos menor do que a do sistema B, de 20 minutos.

b) 

- Variável aleatória: Tempo para executar tarefa, em minutos
- Se seguem distribuição normal, $E(X_A) = mu_A$ e $E(X_B) = mu_B$. A variância é igual nos dois.
- Hipótese: Os tempos médios diferem?
  - $H_0 : mu_A = mu_B$
  - $H_1 : mu_A != mu_B$
- Calculamos média de cada amostra:
  - $overline(x_A) = 16$
  - $overline(x_B) = 20$
- Calculamos a variância de cada amostra:
  - $(s_A)^2 = 6.86$
  - $(s_B)^2 = 16$
- Juntamos as duas variâncias numa só:
  - $(s_p)^2 = ((n_A-1)s^2_A + (n_B-1)s^2_B)/(n_A+n_B-2) = 11.43$
  - $s_p = 3.38$
- Calculamos a estatística de teste
  - $t = (overline(x_A)-overline(x_B))/(s_p sqrt(1/n_A + 1/n_B)) = -2.37$
- Se $H_0$ for verdadeira, essa estatística segue uma t de Student com $n_A + n_B - 2 = 14$ graus de liberdade. Como o teste é bilateral com $alpha=5%$, colocamos $alpha=2.5%$ em cada cauda. Na tabela t, g.l = 14 e 2.5% em cada cauda. $t = 2.145$ (valor crítico).
- Rejeitamos $H_0$ se $|t| > t_"crítico"$. Isso aconteceu. Então rejeitamos $H_0$.

Então sim, os tempos médios diferem.