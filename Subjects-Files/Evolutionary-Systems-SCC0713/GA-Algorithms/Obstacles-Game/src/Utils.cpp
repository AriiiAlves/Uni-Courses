#include "Utils.h"

// C++ Random Generator para uma boa distribuição probabilística
random_device dev;
mt19937 rng(dev());
uniform_int_distribution<int> dist1_int(0,1); // Inteiro no intervalo [0,1]
uniform_real_distribution<double> dist1_real(0.0, 1.0); // Double no intervalo [0, 100]
// Para gerar random: dist1(rng) // dist43(rng) // dist1(rng)

int dist1Int() { return dist1_int(rng); }
double dist1Real() { return dist1_real(rng); }

int binToInt(string &cromossomial, int begin, int end){
	int aux = 0;

	for(int i = 0; i <= (end-begin); i++){
		if(cromossomial[i+begin] == '1') aux += pow(2,i);
	}

	return aux;
}
