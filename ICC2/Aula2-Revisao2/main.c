#include<stdio.h>
#include<stdlib.h>

// Conta até \0
int countStr(char *str){
    int i=0;
    while(str[i]!=0) i++;
    return i;
}

// Obs: Se você passar str para uma função, o C transforma o array em um ponteiro (char*) e a informação dos 10 espaços é perdida
void copyStr(char *src, char *dest, int src_size, int dest_size){
    int i=0;
    while(src[i]!=0 && i<src_size && i<dest_size) { dest[i]=src[i]; i++; }
    dest[i]=0;
}

void concatStr(char *str1, char *str2, int src_size, int dest_size){
    int i=0,j=0;
    while(str1[i]!=0) i++;
    while(str2[j]!=0 && i<src_size && i<dest_size) { str1[i]=str2[j]; i++; j++;  }
    str1[i]=0;
}

// Primeira parte: Contar, Copiar e Concatenar Strings
void p1(){
    // char *str; // Ponteiro não inicializado
    char str1[5]; // Tem que inicializar ponteiro (dar tamanho)
    char str2[10];
    scanf("%s %s", str1, str2);
    printf("%s %s\n", str1, str2);

    int n = countStr(str1);
    printf("%d\n", n);

    copyStr(str1, str2, sizeof(str1), sizeof(str2));
    printf("%s %s\n", str1, str2);
    concatStr(str1, str2, sizeof(str1), sizeof(str2));
    printf("%s %s\n", str1, str2);
}

// Segunda parte: Armazenar string com realloc
void p2(){
    char c;
    int i=1;
    char *str = malloc(1 * sizeof(char));

    while((c = getchar()) != '\n' && c != EOF) {
        str[i-1] = c;
        str = realloc(str, (++i) * sizeof(char));
    }

    str = realloc(str, (++i) * sizeof(char));
    str[i-1] = 0;

    printf("%s %d\n", str);

    free(str);
}

// Terceira parte: Armazenar texto com ponteiro pra ponteiros
void p3(){
    FILE *f;
    char c=0;
    char **content = malloc(sizeof(char*));
    int nc=0;

    f = fopen("in", "r");

    while(c != EOF){
        char *line = malloc(sizeof(char));
        int nl=0;

        while((c = fgetc(f)) != '\n' && c != EOF){
            line[nl] = c;
            line = realloc(line, ++nl + 1);
        }

        line[nl] = 0;
        content[nc] = line;
        content = realloc(content, (++nc + 1) * sizeof(char*));
    }

    fclose(f);

    for(int i=0; i<nc; i++){
        printf("%s ", content[i]);
    }
}

int main(){
    //p1();
    //p2();
    p3();

    return 0;
}