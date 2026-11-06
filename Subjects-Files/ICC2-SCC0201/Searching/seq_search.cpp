#include<iostream>
#include<stdlib.h>

using namespace std;

#define N_TABLE 1000
#define N_IDX 10

typedef struct {
	int kindex, pos;
} IdxChunk;

void createIdx(IdxChunk idxChunks[], int v[], int n){
	// Idx of only multiples of n.
	for(int i = 0; i < N_IDX; i++) {
		int pos = i*n/N_IDX;
		if(pos >= N_TABLE) break;
		idxChunks[i].kindex = v[pos];
		idxChunks[i].pos = pos;
	}
}

int comp(const void *a, const void *b){
	return (*(int*)a - *(int*)b);
}

int seq_idx_search(IdxChunk idxChunks[], int v[], int x){
	int i;
	// Search first elm >= x
	for(i = 0; i < N_IDX && x >= idxChunks[i].kindex; i++);
	// i = last pos (v[last pos] < x)
	i = (i==0)? 0 : idxChunks[i-1].pos;
	// Starts sequential searching
	while(i < N_TABLE-1 && x > v[i]) i++;
	// Return element (or -1 if not)
	if(x == v[i]) return i;
	else return -1;
}

int main(){
	int v[N_TABLE];

	for(int i = 0; i < N_TABLE; i++)
		v[i] = rand() % 100;
	qsort(v, N_TABLE, sizeof(int), comp);


	IdxChunk idxChunks[N_IDX];
	createIdx(idxChunks, v, 100);
	
	for(int i = 0; i < 10; i++) cout << "Idx: " << idxChunks[i].kindex << " Pos: " << idxChunks[i].pos << endl;
	cout << seq_idx_search(idxChunks, v, 23) << endl;
}
