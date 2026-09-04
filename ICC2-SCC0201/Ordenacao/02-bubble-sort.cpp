#include<vector>
#include<iostream>
using namespace std;

void swap(int &a, int &b){
	int t = a;
	a = b;
	b = t;
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

void printVec(vector<int> &v, int size){
	cout << endl;
	for(int i=0; i<size; i++){
		cout << v[i] << " ";
	}
	cout << endl;
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
		quickSort(v[i], 0, v[i].size()-1);
		printVec(v[i], v[i].size());
	}
}
