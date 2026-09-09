#include<iostream>
#include<iomanip>
#include<fstream> // For file operations
#include<vector>
#include "Player.h"
#include "Game.h"
#include "Graphic.h"
#include "Utils.h"
#include "EvolutionTools.h"

using namespace std;

int main(){
	// Vectors
	vector<Player> population;
	
	// Evolutionary Algorithm Config
	int n = 100; // Número de indivíduos (deve ser par)
	int generation = 0; // Número da geração
	//double mutationTax = 0.001; // 1/L (size of cromossomial)
	int delayRange = 250; // Generations until delay
	int delay = 250; // ms
	int batch = 10; // Generations before crossover
		
	// Neural Network Config
	int nBitsW1 = 10;
	int nBitsW2 = 10;
	int nNeuronsL1 = 12; // Hidden layer
	int nNeuronsL2 = 8; // 8 possible outputs (moving 0-7)

	// Map
	int hMap = 64; // Pixels
	int wMap = 64; // Pixels
	double insertQueueTax = 0.2; // Chance of piece inserting (high = higher difficult)
	Map mapInstance(wMap, hMap, insertQueueTax);

	// Game Config
	int x0 = wMap/2;
	int y0 = hMap-1;
	int CELL_SIZE = 10; // Pixels
	int nMoves = 3; // Possible moves before obstacles position update (low nMoves = Higher difficult)
	int nColors = 9;
	int dMax = 10; // Max distance of sensors

	// Graphics
	Draw draw(mapInstance.map, wMap, hMap, population, n, CELL_SIZE);
	
	// Data
	double mediumScore = 0;
	ofstream dFile("EA-Data.csv");
	ofstream wFile("EA-Best-Weights.csv");

	// Open File
	if(!dFile.is_open() || !wFile.is_open()) {
		cout << "Error opening the file" << endl;
		return 1;
	}

	dFile << "Generation,Best Score,Medium Score\n";
	wFile << "Generation,Best Weight\n";

	// Init population and fill fitness with zeros
	for(int i = 0; i < n; i++){
		Player player(x0, y0, nColors, dMax, nBitsW1, nBitsW2, nNeuronsL1, nNeuronsL2);
		population.push_back(player);
	}

	while(draw.running){
		int survivors = n;
		long long int score = 0;
		int bestIdx = 0;
		//int counter = 40;
		
		// Run batch
		for(int c = 0; c < batch; c++){ 
			// One generation (until everybody dies) -> RUN!
			while(draw.running && survivors){
				// Move n-steps (advantage)
				for(int k = 0; k < nMoves; k++){
					// Makes everybody moves one step
					for(int i = 0; i < n; i++){
						if(population[i].alive){
							population[i].movePlayer(mapInstance.map, wMap, hMap);	
							if(!population[i].alive) { survivors--; }  
						}
					}
					// Draw after 1 step
					if(generation % delayRange == 0) draw.delay(delay); // Greater delay every 10 generations cycle
					draw.drawMap();

					// Increase score
					score++;
				}
				// Insert piece
				mapInstance.randomQueueInsert();
				// Update map
				mapInstance.updateMap();
			}
			
			// Batch Gradient
			for(int i = 0; i < n; i++){
				population[i].totalScore += population[i].score / (double) batch;
				population[i].score = 0;
				// Resets
				population[i].px = x0;
				population[i].py = y0;
				population[i].alive = true;
				population[i].score = 0;
				// Clean map
				mapInstance.cleanMap();
			}

			// Increments Generation
			generation++;
			// Resets survivors
			survivors = n;
		}

		// Selects the best
		for(int i = 0; i < n; i++) if(population[i].totalScore > population[bestIdx].totalScore) bestIdx = i;

		// Calculates Medium Score
		mediumScore = 0;
		for(int i = 0; i < n; i++) mediumScore += (double)population[i].totalScore;
		mediumScore /= (double)(n);

		// Saving
		dFile << generation << "," << population[bestIdx].totalScore << "," << mediumScore << "\n";
		cout << "Gen(" << generation << ") - Best: " << population[bestIdx].totalScore << " | Avg: " << mediumScore << endl;

		wFile << generation << "," << population[bestIdx].cromossomial << "\n";

		// FLUSH!
		dFile.flush();
		wFile.flush();

		// Crossover (substitute parent by its child) and Mutation
		rouletteCrossoverAndMutation(population);
		
		// Resets total score
		for(int i = 0; i < n; i++) population[i].totalScore = 0; 
	}

	dFile.close();
	wFile.close();
	return 0;
}
