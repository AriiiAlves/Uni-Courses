#include <iostream>
#include <vector>
#include <math.h>
#include <random>

using namespace std;

random_device rd; // Obtém random seed do hardware
mt19937 gen(rd()); // Inicializa Mersenne Twister engine com a seed

double f(double x){
    //double y = -2.0*pow(x,6) - pow(x,4) + 3.0*pow(x,3) + 10.0*pow(x,2);
    double y = sin(20*(x-0.1));
    double den = x-0.1;
    if (!den) return x;
    return (y/den);
}

double variance(vector<double> x){
    double mu = 0;
    double term = 0;

    for(int i=0; i<x.size(); i++){
        mu += x[i];
    }

    mu /= (double)x.size();

    for(int i=0; i<x.size(); i++){
        term += pow((x[i]-mu), 2);
    }

    term /= (double)x.size();

    return term;
}

double mutation(double x, double mutation_rate, int min, int max){
    // Define mutação no intervalo
    uniform_real_distribution<double> rnd(mutation_rate * min, mutation_rate * max);

    double noise = rnd(gen);
    double r = x + noise;

    if(r > min || r < max) return x;
    return r;
}

double module(double x, double y){
    if(x > y) return x-y;
    return y-x;
}

// População: Vetor(N) {Genes1, Genes2, ...} -> Cada índice é um indivíduo. Seus genes são atributos.

// Genes1 = {Angulo1(double), Angulo2, Velocidade(int), FlagSensor1(bool)}

int main(){
    vector<double> individuos;
    int n = 50;
    int bestIdx = 0; // [indice, valor]
    double var;

    int min = -10;
    int max = 10;

    uniform_real_distribution<double> rnd(min, max); // Define intervalo

    // 1. Inicia população
    for(int i=0; i<n; i++){
        individuos.push_back(rnd(gen));
        // printf("Individuo[%d]: %.2f\n", i, individuos[i]);
    }

    for(int k=0; k<100; k++){
        // Primeiro, exploramos todo o intervalo pequeno (aproximamos os pontos)
        while(variance(individuos) > 1e-3){
            // 2. Avaliação e Seleção (aplicar função e selecionar os 2 pais)
            for(int i=0; i<n; i++){
                double r = f(individuos[i]);
                double b = f(individuos[bestIdx]); 

                if(r > b){
                    bestIdx = i;
                    //printf("[%d] > [%d]", i, bestIdx);
                } else {
                    //printf("[%d] < [%d]", i, bestIdx);
                }

                printf("\nIndividuo[%d]: f(%.2f) = %.2f\n", i, individuos[i], r);
            }

            printf("Best: f(%.2f) = %.2f\n", individuos[bestIdx], f(individuos[bestIdx]));
            printf("Variance: %.2f\n\n", variance(individuos));
            
            // 3. Crossover entre indivíduos (média simples com o melhor)
            for(int i=0; i<n; i++){
                if(i==bestIdx) continue;
                individuos[i] = (individuos[bestIdx] + individuos[i])/2.0;
            }
        }

        // Depois, explodimos os pontos para tentar buscar indivíduos melhores

        // 3. Mutação (alterações aleatórias nos filhos)
        for(int i=0; i<n; i++){
            if (i==bestIdx) continue;
            individuos[i] = mutation(individuos[i], 0.1, min, max); // Mutação máxima
        }
    }

    printf("Best ever: %.5f", individuos[bestIdx]);
}