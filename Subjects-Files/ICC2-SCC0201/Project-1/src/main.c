#include "stdlib.h"
#include "stdio.h"
#include "time.h"
#include "string.h"
#define true 1
#define false 0

void swap(int *a, int *b){
	int t = *a;
	*a = *b;
	*b = t;
}

void printVec(int v[], int size, int RUNCODES){
	if(!RUNCODES) printf("\n");
	for(int i=0; i<size; i++){
	    printf("%d ", v[i]);
	}
	if(!RUNCODES) printf("\n");
}

// O(n^2) : insertion sort
// O(n log n): heap sort

void insertionSort(int v[], int size){
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
void rearrangeHeap(int v[], int i, int heap_size){
	int L,R,C;

	L = 2*i+1;
	R = 2*i+2;
	C = i;

	if(L < heap_size && v[L] > v[C]) C = L;
	if(R < heap_size && v[R] > v[C]) C = R;
	if(C != i){
		swap(&v[C], &v[i]);
		rearrangeHeap(v, C, heap_size);
	}
}

// Build heap based in unsorted vector
void buildHeap(int v[], int size){
	int i, aux;

	for(int i = size/2-1; i >= 0; i--){
		rearrangeHeap(v, i, size);
	}
}

void heapSort(int v[], int size){
	int aux;
	int heap_size = size;

	buildHeap(v, size);

	for(int i = size - 1; i > 0; i--){
		// The root gets out of heap
		swap(&v[0], &v[i]);
		// Rearrange heap
		rearrangeHeap(v, 0, i);
	}
}

int main(){
    // Variables
    char file_name[50], arrayType[30];
	int opt, n, t, c;
	int *v, *v_save, *v_out;
	int SAMPLES, FILES;
	clock_t start, end;
	double time;
	// CHANGE THE FLAG HERE!!!
	int RUNCODES = false;

	if(RUNCODES) SAMPLES = 1;
	else SAMPLES = 10;

	if(RUNCODES) FILES = 1;
	else FILES = 20;

	FILE *insertionCSV;
	FILE *heapCSV;

	if(!RUNCODES){
	    insertionCSV = fopen("insertion_sort.csv", "w");
		heapCSV = fopen("heap_sort.csv", "w");

    	if(insertionCSV == NULL || heapCSV == NULL) {
    	    printf("Unable to open .csv files!");
    		return 1;
    	}

    	fprintf(insertionCSV, "type,size,avg,rel\n");
    	fprintf(heapCSV, "type,size,avg,rel\n");
	}

	for(int i=1; i<=FILES; i++) {
	    if(!RUNCODES){
    		// Open .in file
    		sprintf(file_name, "./cases/%d.in", i);
    		FILE *read_file;
    		read_file = fopen(file_name, "r");
    		if(read_file == NULL){
    		    printf("Unable to open .in file");
    			return 1;
    		}
    		// Extract file data
    		fscanf(read_file, "%d", &opt);
    		fscanf(read_file, "%d", &n);

    		printf("%d %d\n", opt, n);

    		v = (int*) malloc(sizeof(int) * n);
    		v_save = (int*) malloc(sizeof(int) * n);
    		v_out = (int*) malloc(sizeof(int) * n);

    		c = 0;
    		while(fscanf(read_file, "%d", &v[c]) == 1) { v_save[c] = v[c]; c++; }
    		// Close file
    		fclose(read_file);

    		// Open .out file
    		sprintf(file_name, "./cases/%d.out", i);
    		FILE *out_file;
    		out_file = fopen(file_name, "r");
    		if(out_file == NULL){
    		    printf("Unable to open .out file");
    			return 1;
    		}

    		c = 0;
    		while(fscanf(out_file, "%d", &v_out[c]) == 1) { c++; }
    		// Close file
    		fclose(out_file);
		} else {
		    scanf("%d", &opt);
			scanf("%d", &n);

			v = (int*) malloc(sizeof(int) * n);
    		v_save = (int*) malloc(sizeof(int) * n);
    		v_out = (int*) malloc(sizeof(int) * n);

			for(int k = 0; k < n; k++) scanf("%d", &v[k]);
		}

		float avg0 = 0, avg1 = 0;
		for(int j = 0; j < SAMPLES; j++){
		    if(!opt || !RUNCODES){
    		    // --------------- INSERTION SORT ----------------
        		// Start counting
        		start = clock();
                insertionSort(v, n);
                // Ends counting
                end = clock();

                time = (double)(end-start) / CLOCKS_PER_SEC * 1000;
                avg0 += time / ((float)SAMPLES);

                // Verifies
                if(!RUNCODES){
                    for(int i = 0; i < n; i++) {
                        if(v[i] != v_out[i]){
                            printf("[insertionSort] Bad sorting.\n");
                            break;
                        }
                    }

                    if(!j && n <= 100) {
                        printf("\nv:");
                        printVec(v, n, RUNCODES);
                        printf("\nv_out:");
                        printVec(v_out, n, RUNCODES);
                    }
                } else printVec(v, n, RUNCODES);
                // Unsorted again
                for(int k = 0; k < n; k++) { v[k] = v_save[k]; }
			}
			if(opt || !RUNCODES){
                // --------------- HEAP SORT ----------------
                // Start counting
          		start = clock();
                heapSort(v, n);
                // Ends counting
                end = clock();

                time = (double)(end-start) / CLOCKS_PER_SEC * 1000;
                avg1 += time / ((double)SAMPLES);

                if(!RUNCODES){
                    for(int i = 0; i < n; i++) {
                        if(v[i] != v_out[i]){
                            printf("[insertionSort] Bad sorting.\n");
                            break;
                        }
                    }

                    if(!j && n <= 100) {
                        printf("\nv:");
                        printVec(v, n, RUNCODES);
                        printf("\nv_out:");
                        printVec(v_out, n, RUNCODES);
                    }
                } else printVec(v, n, RUNCODES);
                // Unsorted again
                for(int k = 0; k < n; k++) { v[k] = v_save[k]; }
			}
        }

	    if(i % 4 == 1) strcpy(arrayType, "sorted");
	    else if (i % 4 == 2) strcpy(arrayType, "descendent sorted");
	    else if (i % 4 == 3) strcpy(arrayType, "random");
	    else if (i % 4 == 0) strcpy(arrayType, "random with repetition");

		if(!RUNCODES){
            double rel0, rel1;
			if(avg0 <= avg1) { rel0 = 1; rel1 = avg1 / avg0; }
			else { rel1 = 1; rel0 = avg0 / avg1; }

			fprintf(insertionCSV, "%s,%d,%f,%f\n", arrayType, n, avg0, rel0);
    		fprintf(heapCSV, "%s,%d,%f,%f\n", arrayType, n, avg1, rel1);
		}

		free(v);
		free(v_save);
		free(v_out);
	}

	if(!RUNCODES){
	    fclose(insertionCSV);
		fclose(heapCSV);
	}
}
