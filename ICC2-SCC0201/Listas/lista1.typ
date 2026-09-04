= 1. Na linguagem C, qual a função dos operadores `*` e `&` ao trabalhar com ponteiros?

O operador `*` é o dereferenciador. Ele indica que aquele dado é um ponteiro, e ao utilizá-lo, obtemos o dado para o qual o ponteiro aponta.

O operador `&` retorna o endereço da variável.

= 2. Assinale a alternativa correta sobre o que está ocorrendo no código:

c) Uma região de memória é alocada dinamicamente para armazenar um inteiro (4 bytes). O ponteiro ptr armazena o endereço dessa região e, na linha 4, o valor contido nesse endereço é alterado para o valor de i.

= 3. Qual é o respectivo valor armazenado no ponteiro ptr e o conteúdo apontado por ele logo após a execução da linha 4?

a) 0x16d3b6a6c e 1

= 4. O comando printf da linha 6 será executado? Ou seja, o if da linha 5 retornará True ou False? Por quê?

Retornará False, pois o ponteiro recebeu apenas o dado de `i`, e não o endereço.

= 5. O que acontecerá se fizermos a chamada computa_indice(5) na função main?

5 + 3 + 1 + -1 + -3 + ...

c) O programa causará um erro de estouro de pilha (Stack Overflow), pois a condição de parada n == 0 nunca será satisfeita, resultando em chamadas infinitas.

= 6. Assinale a alternativa que indica a exata saída impressa no terminal ao executar o código acima

c) 0 1 2 3

= 7. Inversão de String In-Place (Ponteiros + Recursão)

Escreva uma função recursiva em C que inverta os caracteres de uma string diretamente na memória original (in-place).

A função deve receber exatamente dois ponteiros para char: um apontando para o caractere atual à esquerda e outro para o caractere atual à direita.

- Você não pode usar índices de vetor (ex: str[i]). Utilize apenas aritmética
de ponteiros e desreferenciação (\*).
- Nenhuma função da <string.h> pode ser chamada dentro da recursão.
- Nenhuma estrutura auxiliar (como novos arrays) deve ser alocada.

A assinatura da função deve ser:
`void inverte_texto_rec(char *esq, char *dir);`

```c
#include <stdio.h>
#include <stdlib.h>

void invert(char* l, char* r){
    if(l == r || r == l+1) return;
    char t;
    t = *l;
    *l = *r;
    *r = t;

    invert(l+1,r-1);
}

void main(){
    int n;
    scanf("%d", &n);
    if(!n) return;
    char* str = malloc(sizeof(char) * (n+1));
    scanf("%s", str);

    invert(str, str+(n-1));
    printf("%s", str);
}
```