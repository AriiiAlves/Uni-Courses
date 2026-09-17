#include<vector>
#include<iostream>
using namespace std;

void swap(int &a, int &b){
	int t = a;
	a = b;
	b = t;
}

void printVec(vector<int> &v, int size){
	cout << endl;
	for(int i=0; i<size; i++){
		cout << v[i] << " ";
	}
	cout << endl;
}


void bubbleSort(vector<int> &v, int size){
	bool swapped;

	do {
		swapped = false;

		for(int i=0; i<size-1;i++){
			if(v[i]>v[i+1]) { swap(v[i], v[i+1]); swapped = true; }
		}
	} while(swapped);
}

// Ideia: A cada loop interno, o último fica ordenado.
void betterBubbleSort(vector<int> &v, int size){
	bool swapped;

	for(int i=0; i<size-1;i++){
		swapped = false;
		for(int j=0; j<(size-1-i);j++){
			if(v[j]>v[j+1]) { swap(v[i], v[i+1]); swapped = true; }
		}
		if(!swapped) break;
	}
}

// Percorre esquerda até v[i] >= x
// Percorre direita até v[j] <= x
// Troca v[i] com v[j]
void quickSort(vector<int> &v, int start, int end){
	int i = start;
	int j = end;
	int pivot = v[start + (end-start)/2];

	while(i<j){
		if(v[i] < pivot) {i++; continue;}
		if(v[j] > pivot){j--;continue;}
			
		swap(v[i], v[j]);
		i++;
	}

	if(start == end || start+1 >= end) return;
	
	quickSort(v, start, i);
	quickSort(v, j, end);
}

void insertionSort(vector<int> &v, int size){
	int i, j, aux;

	for(i = 1; i < size; i++){
		// Define quem vamos inserir
		aux = v[i];
		// Da direita pra esquerda do subarray, desloca elementos para a direita até encontrar um menor 
		for(j = i-1; j >= 0 && aux < v[j]; j--) { v[j+1] = v[j]; }
		// Insere elemento à direita do menor
		v[j+1] = aux;
	}
}

void shellSort(vector<int> &v, int size, int h0, int step){
	int i, j, k, h, aux;
	
	// Decrementa passo
	for(h = h0; h > 0; h -= step){
		// Faz insertion sort só nos passos
		for(i = h; i < size-h+1; i += h){
			aux = v[i];
			for(k = i-h; k >= 0 && aux < v[k]; k -= h) { v[k+h] = v[k]; }
			v[k+h] = aux;
		}
	}
}

void selectionSort(vector<int> &v, int size){
	int i, j, auxIdx;

	for(i = 0; i < size-1; i++){
		auxIdx = i;
		for(j = i+1; j < size; j++){
			if(v[j] < v[auxIdx]) auxIdx = j; 
		}
		swap(v[i], v[auxIdx]);
	}
}


// Heap Sort

// Rearrange Heap to sort it. O(log n)
void rearrangeHeap(vector<int> &v, int i, int heap_size){
	int L,R,C;

	L = 2*i+1;
	R = 2*i+2;
	C = i;

	if(L < heap_size && v[L] > v[C]) C = L;
	if(R < heap_size && v[R] > v[C]) C = R;
	if(C != i){
		swap(v[C], v[i]);
		rearrangeHeap(v, C, heap_size);
	}
}

// Build heap based in unsorted vector
void buildHeap(vector<int> &v, int size){
	int i, aux;

	for(int i = size/2-1; i >= 0; i--){
		rearrangeHeap(v, i, size);
	}
}

void heapSort(vector <int> &v, int size){
	int aux;
	heap_size = size;

	buildHeap(v, size);

	for(int i = 0; i < heap_size-i-1; i++){
		// The root gets out of heap
		aux = v[0];
		v[0] = v[heap_size-1];
		v[heap_size-1] = aux;
		heap_size--;
		// Rearrange heap
		rearrangeHeap(v, 0, heap_size);
	}
}

int main(){
	vector<int> v1 = {10,4,63, 100,1,6,2,92,32,68,0};
	vector<int> v2 = {10,4,100,1,6,2,92,32,68,0};
	vector<int> v3 = {121,89,56,23,14,7,3,2,0};
	vector<int> v4 = {1};
	vector<int> v5 = {3,1};
	vector<int> v6 = {1,3};
	vector<int> v7 = {6,1,3};
	vector<vector <int>> v = {v1,v2,v3,v4,v5,v6,v7};
	
	for(int i=0; i<v.size(); i++){
		//bubbleSort(v[i], v[i].size());
		//betterBubbleSort(v[i], v[i].size());
		//quickSort(v[i], 0, v[i].size()-1);
		//insertionSort(v[i], v[i].size());
		//shellSort(v[i], v[i].size(), 3, 1);
		//selectionSort(v[i], v[i].size());
		buildHeap(v[i], v[i].size());
		printVec(v[i], v[i].size());
	}
}
