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
	int generation = 1; // Número da geração
	//double mutationTax = 0.001; // 1/L (size of cromossomial)
	int delayRange = 250; // Generations until delay
	int delay = 0; // ms
	int batch = 3; // Generations before crossover
		
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
	
	// Test mode
	int testMode = true; // Bool
	int testDelay = 25;
	if(testMode) n = 1;
	string testCromossomial = "101001000000001111111011110011100100000101101011100000101110001100101011001010010011100100001110101011001101100011111000111100001011111110101010100010110010000011000000110010001000000000111100110001001110101011111111100010111101011000100110100010100000011001100110101010110011100111111000101100011100000000010000111100010110001111101011010100100111000101100100111010010101001110100100001100101111000001110110110000011101010101011111001000110111011100100011010110101010110100010101011010101000011100011011001001010001110000011110111010010100101010001000001011001000011000010111010010010010000010011101000110101000101000010001100110010010111011101011110001111101001011001111011011110100011110010101000100000101001111011001101110101101110110001000110100101110010101010100001001001101101010100011001001110111010011001110111111110000101101111100011100110010001000110100110010010001110101000010001000010111111111000111000010011001100001011110111110100011001101111100101100111010101100010100100111001001011100101111110000111111111010000010010001011100000001011011000101101100001001011101001011100000010100111100100101011001000100011001100010011100010111100100000110010011011110000010101100101010001101000101100010101100101010010111010011001001000000111100110101100111011000101011100000000110011111110010011111101010000111011101101110001000110100110110100000100101100001011111000010010010000010101111100111101011100110100111100010010010111101100010010100001011001111100001011001011001000110110100001011000001101110000110111111001101001001000010101100001001011010110010111110000000111011101010110000001101001110100110010111111010101011111010010001001000000100100111101111100111001011000111101001111101110001100011000110101011110100010000100001000011000101111001111111101011001111011110010111001000011101101111100110111110000000000011101111010000010010111110000110011000101101111000010111100101110011011001101001010001000011001101";

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

	if(testMode){
		Player player(x0, y0, nColors, dMax, nBitsW1, nBitsW2, nNeuronsL1, nNeuronsL2);
		player.cromossomial = testCromossomial;
		population.push_back(player);

		while(draw.running){
			long long int score = 0;
			// Move n steps
			for(int k = 0; k < nMoves; k++){
				if(population[0].alive){
					population[0].movePlayer(mapInstance.map, wMap, hMap);
				} else {
					cout << "Player died. Score: " << score << endl;
					break;
				}

				draw.delay(testDelay);
				draw.drawMap();

				// Increase score
				score++;
			}
			
			// Insert piece
			mapInstance.randomQueueInsert();
			// Update map
			mapInstance.updateMap();

			if(!population[0].alive){
				population[0].px = x0;
				population[0].py = y0;
				population[0].alive = true;
				population[0].score = 0;
				score = 0;
				// Clean map
				mapInstance.cleanMap();
			}
		}
	} else {
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
			
			// Increments Generation
			generation++;
		}
	}

	dFile.close();
	wFile.close();
	return 0;
}
