#include <stdio.h>

int maior(int *v, int n){
    if(n==1) return v[0];

    int aux = maior(v, n-1);
    if(aux > v[n-1]) return aux;
    else return v[n-1];
}

int soma(int *v, int n){
    if(n==1) return v[0];
    return soma(v, n-1) + v[n-1];
}

int arranjo(int *v, int n){
    if(n==1) return v[0] % 2;
    return arranjo(v, n-1) + v[n-1] % 2;
}

int binary_search(int *v, int i, int f, int s){
    if(f>i) return -1;
    if(v[(i + f)/2] == s) return (i + f)/2;
    if(v[(i + f)/2] > s) return binary_search(v, i, (i + f)/2, s);
    if(v[(i + f)/2] < s) return binary_search(v, (i + f)/2, f, s);
}

void hanoi(int n, char orig, char temp, char dest){
    if(n==1) printf("Mova o disco %d da haste %c para a haste %c\n", n, orig, dest);
    else {
        hanoi(n-1, orig, dest, temp);
        if(n==1) printf("Mova o disco %d da haste %c para a haste %c\n", n, orig, dest);
        hanoi(n-1, temp, orig, dest);
    }
}

int main(){
    int v[5] = {1,9,4,14,8};

    int n1 = maior(v, 5);
    int n2 = soma(v, 5);
    int n3 = arranjo(v, 5);
    int n4 = binary_search(v, 0, 4, 14);
    hanoi(3, 'o', 't', 'd');

    printf("%d %d %d %d", n1, n2, n3, n4);
}