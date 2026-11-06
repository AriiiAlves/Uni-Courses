#include "stdlib.h"
#include "stdio.h"

int B = 10;
int hash(int k){ return k % B;}
int* HASHTABLE = (int*)malloc(sizeof(int) * B);

void init(){
    for(int i = 0; i < B; i++){
        HASHTABLE[hash(i)] = -1;
    }
}

void insert(int k, int v){
    int empty = -1, i = 0;
    while(HASHTABLE[hash(k+i)] != empty) { if(i != 0 && hash(k+i) == hash(k)) break; i++; }
    if(HASHTABLE[hash(k+i)] == empty) HASHTABLE[hash(k+i)] = v;
}

int main(){
    init();

    insert(1, 2);
    insert(15, 5);
    insert(15, 7);

    for(int i = 0; i<15; i++) insert(i, i);
    for(int i = 0; i<B; i++) printf("%d\n", HASHTABLE[hash(i)]);

    //printf("%d\n", HASHTABLE[hash(1)]);
    //printf("%d\n", HASHTABLE[hash(15)]);
    //printf("%d\n", HASHTABLE[hash(16)]);
}
