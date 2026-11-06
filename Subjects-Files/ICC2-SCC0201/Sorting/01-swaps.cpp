#include<iostream>
#include<cstring>
using namespace std;

typedef struct no {
	int chave;
	char valor[10];
} No;

// Troca por endereços
void swap_addr(No **n1, No **n2){
	No *t = *n1;
	*n1 = *n2;
	*n2 = t;
}

// Troca por registros
void swap_value(No **n1, No **n2){
	No *t = (No*) malloc(sizeof(No));
	memcpy(t, *n1, sizeof(No));
	memcpy(*n1, *n2, sizeof(No));
	memcpy(*n2, t, sizeof(No));
}

int main(){
	No *n1 = (No*) malloc(sizeof(No));
	No *n2 = (No*) malloc(sizeof(No));
	n1->chave = 10;
	n2->chave = 20;
	
	swap_addr(&n1, &n2);
	cout << n1->chave << endl;
	cout << n2->chave << endl;

	swap_value(&n1, &n2);
	cout << n1->chave << endl;
	cout << n2->chave << endl;
	
	return 0;
}

