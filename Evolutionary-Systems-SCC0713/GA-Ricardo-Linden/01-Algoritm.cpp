#include<string>
#include<vector>
#include<random>
#include<iostream>
#include<math.h>
#include<iomanip>
#include<algorithm> // Para sort()
using namespace std;

// C++ Random Generator para uma boa distribuição probabilística
random_device dev;
mt19937 rng(dev());
uniform_int_distribution<int> dist1_int(0,1); // Inteiro no intervalo [0,1]
uniform_int_distribution<int> dist43(1,43); // Inteiro no intervalo [1,43]
uniform_real_distribution<double> dist1_real(0.0, 1.0); // Double no intervalo [0, 100]
// Para gerar random: dist1(rng) // dist43(rng) // dist1(rng)

void inicializaElemento(string &cromossomo, int tamanho){
	for(int i = 0; i < tamanho; i++){
		if(dist1_int(rng)){
			cromossomo.push_back('1');
		} else {
			cromossomo.push_back('0');
		}
	}
}

double binParaDouble(string &cromossomo, int inicio, int fim){
	double aux = 0;

	for(int i = 0; i <= (fim-inicio); i++){
		if(cromossomo[i+inicio] == '1') aux += pow(2,i);
	}

	return aux;
}

double calculaAvaliacao(string &cromossomo) {
	//  (100.0 / (2^(22)-1)) = approx 0.0000119209304
	double x = binParaDouble(cromossomo, 0, 21) *  0.000023841863594449;
	double y = binParaDouble(cromossomo, 22, 43) *  0.000023841863594449;

	//cout << x << " " << y << endl;

	double numerador = pow(sin(sqrt(x*x + y*y)), 2) - 0.5;
	double denominador = pow((1.0 + 0.001*(x*x + y*y)), 2);
	double avaliacao = 1.0/(0.5 + numerador / denominador); // Inverte para trocar mínimo pelo máximo

	return avaliacao;
}

int giraRoleta(vector<double> &avaliacao, int n, double soma_roleta){
	double aux = 0;
	double rnd = dist1_real(rng) * soma_roleta; // Evita operador / (divisão de ponto flutuante), que é custoso

	for(int i = 0; i < n; i++){
		aux += avaliacao[i];
		if(aux >= rnd) return i;
	}
	
	// Se o último for o escolhido (rnd = 90, last = 95)
	return n-1;
}

void singlePointCrossover(string &pai1, string &pai2, string &filho1, string &filho2, int n){
	int rnd = dist43(rng);

	for(int i = 0; i < rnd; i++){
		filho1.push_back(pai1[i]);
		filho2.push_back(pai2[i]);
	}
	for(int i = rnd; i < n; i++){
		filho1.push_back(pai2[i]);
		filho2.push_back(pai1[i]);
	}
}

void mutacao(string &filho, int n, double taxa_mutacao){
	for(int i = 0; i < n; i++){
		double rnd = dist1_real(rng);

		if(rnd < taxa_mutacao){
			// Inverte
			if(filho[i] == '1') filho[i] = '0';
			else filho[i] = '1';
		}
	}
}

int main(){
	vector<string> populacao;
	vector<string> filhos;
	vector<double> avaliacao;
	int n = 1000; // Número de indivíduos (deve ser par)
	int n_bits = 44; // Número de bits
	double soma_roleta = 0;
	double aux = 0;
	int epoch = 10;
	
	// Inicializa população
	for(int i = 0; i < n; i++){
		string cromossomo;
		inicializaElemento(cromossomo, n_bits);
		populacao.push_back(cromossomo);
	}
	
	for(int i = 0; i < n; i++){ cout << populacao[i] << endl; }
	
	while(epoch--){
		// Avaliação
		cout << fixed << setprecision(3);
		for(int i = 0; i < n; i++) avaliacao.push_back(calculaAvaliacao(populacao[i]));

		cout << "Geração " << epoch << " - [";
		for(int i = 0; i < n; i++) cout << "(" << binParaDouble(populacao[i], 0, 21) *0.000023841863594449 << ", " << binParaDouble(populacao[i], 22, 43) *0.000023841863594449 << "), ";
		cout << "]" << endl;

		// Seleção, Crossover e Mutação
		for(int i = 0; i < n; i++) soma_roleta += avaliacao[i]; // Obter soma_roleta
		for(int i = 0; i < n/2; i++){
			// Seleção
			int pai1 = giraRoleta(avaliacao, n, soma_roleta); // Escolhe índice
			int pai2 = giraRoleta(avaliacao, n, soma_roleta);
			
			// Crossover
			string filho1, filho2;
			singlePointCrossover(populacao[pai1], populacao[pai2], filho1, filho2, n_bits);

			// Mutação
			mutacao(filho1, n_bits, 0.005);
			mutacao(filho2, n_bits, 0.005);

			filhos.push_back(filho1);
			filhos.push_back(filho2);
		}

		populacao = filhos;

		// Limpa
		filhos.clear();
		avaliacao.clear();
		soma_roleta = 0;
	}
}
