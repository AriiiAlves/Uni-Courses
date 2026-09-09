#include "EvolutionTools.h"
#include "Utils.h"

void uniformCrossover(Player &parent1, Player &parent2, Player &child){
	int n = parent1.cromossomialSize();

	for(int i = 0; i < n; i++){
		if(dist1Int()) child.cromossomial[i] = parent1.cromossomial[i];
		else child.cromossomial[i] = parent2.cromossomial[i];
	} 
}

void rouletteCrossoverAndMutation(vector<Player> &population){
	double normSum = 0;
	double rnd;
	double t = 0;
	int n = population.size();
	int bestIdx = 0;
	double bestScore;
	double avgScore = 0;
	vector<Player> chosen;
	
	// Calculates bestScore and averageScore
	for(int i = 0; i < n; i++){
		avgScore += population[i].totalScore;
		if(population[i].totalScore > population[bestIdx].totalScore) bestIdx = i;
	}
	
	bestScore = population[bestIdx].totalScore;
	avgScore /= (double) n;

	// Norm score with log
	for(int i = 0; i < n; i++) {
		population[i].totalScore = log(population[i].totalScore + 1); // Value Normalization (increases diversity)
		normSum += population[i].totalScore; 
	}

	// Select n individuals for crossover
	for(int i = 0; i < n; i++){
		rnd = dist1Real() * normSum;
		t = 0;
		for(int j = 0; j < n; j++){
			t += population[j].totalScore;
			if(t >= rnd) { chosen.push_back(population[j]); break; }
		}
	}

	multiParentCrossover(population, chosen, bestIdx, avgScore, bestScore);
}

void multiParentCrossover(vector<Player> &population, vector<Player> &chosen, int bestIdx, double avgScore, double bestScore){
	int rnd;
	int n = population.size();
	
	population[0] = population[bestIdx]; // Saves the best

	for(int i = 1; i < n; i++){
		Player parent1 = chosen[(int)(dist1Real() * chosen.size())];
		Player parent2 = chosen[(int)(dist1Real() * chosen.size())];
		uniformCrossover(parent1, parent2, population[i]); // Substitute old population
		mutation(population[i], avgScore, bestScore);
	}
}

void mutation(Player &child, double avgScore, double bestScore){
	int n = child.cromossomialSize();

	// Custom MutationTax (Low with higher diversity, Higher with low diversity)
	double mutationUnit = 1/(double)n;
	double mutationTax;
	if(bestScore == avgScore) mutationTax = mutationUnit;
	else mutationTax = (avgScore/(bestScore-avgScore)) * mutationUnit;

	if(mutationTax > 0.02) mutationTax = 0.02;
	//cout << "Next generation mutation tax: " << mutationTax << endl;

	for(int i = 0; i < n; i++){
		double rnd = dist1Real();

		if(rnd < mutationTax){
			// Inverte
			if(child.cromossomial[i] == '1') child.cromossomial[i] = '0';
			else child.cromossomial[i] = '1';
		}
	}
}

