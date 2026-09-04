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