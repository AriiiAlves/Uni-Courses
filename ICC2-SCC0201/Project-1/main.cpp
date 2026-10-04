#include <iostream>
#include <chrono>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>

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

// O(n^2) : insertion sort
// O(n log n): heap sort

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
	int heap_size = size;

	buildHeap(v, size);

	for(int i = size - 1; i > 0; i--){
		// The root gets out of heap
		swap(v[0], v[i]);
		// Rearrange heap
		rearrangeHeap(v, 0, i);
	}
}

int main(){
    // Variables
    string file_name, line, arrayType;
	int opt, n, t;
	vector<int> v, v_save, v_out;
	int SAMPLES = 10;

	ofstream insertionCSV("insertion_sort.csv", ios::out | ios::trunc);
	ofstream heapCSV("heap_sort.csv", ios::out | ios::trunc);

	insertionCSV << "type,size,avg,rel" << endl;
	heapCSV << "type,size,avg,rel" << endl;

	for(int i=1; i<=20; i++) {
	    v.clear();
		v_out.clear();
		// Open .in file
		stringstream ss;
		ss << "cases/" << i << ".in";
		file_name = ss.str();
	    ifstream file(file_name);
		if(!file.is_open()){ cerr << "Unable to open file: " << file_name << ", skipping." << endl; continue; }
		// Extract file data
		if(getline(file, line)) opt = stoi(line);
		cout << "opt: " << opt << endl;
		if(getline(file, line)) n = stoi(line);
		cout << "n: " << n << endl;
		if(getline(file, line)) {
		    stringstream ss(line);
		    while(ss >> t) v.push_back(t);
		}
		// Close file
		file.close();
		// Open .out file
		stringstream ss_out;
		ss_out << "cases/" << i << ".out";
		file_name = ss_out.str();
	    ifstream file_out(file_name);
		if(!file_out.is_open()){ cerr << "Unable to open file: " << file_name << ", skipping." << endl; continue; }
		// Extract file data
		if(getline(file_out, line)) {
		    stringstream ss(line);
		    while(ss >> t) v_out.push_back(t);
		}
		file_out.close();

		v_save = v;

		float avg0 = 0, avg1 = 0;
		for(int j = 0; j < SAMPLES; j++){
    		// Start counting
    		auto start = chrono::high_resolution_clock::now();
            insertionSort(v, v.size());
            // Ends counting
    		auto end = chrono::high_resolution_clock::now();
    		chrono::duration<double, milli> time = end - start;

            avg0 += time.count() / ((float)SAMPLES);

            // Unsorted again
            v = v_save;

      		// Start counting
      		start = chrono::high_resolution_clock::now();
            heapSort(v, v.size());

            // Ends counting
      		end = chrono::high_resolution_clock::now();
      		time = end - start;

            //if(v == v_out) cout << "Succesfully sorted" << endl;
            //else cout << "Bad sorting" << endl;

            avg1 += time.count() / ((float)SAMPLES);

            // Unsorted again
            v = v_save;
        }

	    if(i % 4 == 1) arrayType = "sorted";
	    else if (i % 4 == 2) arrayType = "descendent sorted";
	    else if (i % 4 == 3) arrayType = "random";
	    else if (i % 4 == 0) arrayType = "random with repetition";

		float rel0, rel1;
		if(avg0 <= avg1) { rel0 = 1; rel1 = avg1 / avg0; }
		else { rel1 = 1; rel0 = avg0 / avg1; }

		insertionCSV << arrayType << "," << n << "," << avg0 << "," << rel0 << "\n";
		heapCSV << arrayType << "," << n << "," << avg1 << "," << rel1 << "\n";
	}
}
