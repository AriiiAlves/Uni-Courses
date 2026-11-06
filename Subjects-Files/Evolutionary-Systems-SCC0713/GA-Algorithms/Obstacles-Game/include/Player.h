#pragma once // Compile the header file only once
#include <vector>
#include <string>
#include <math.h>
#include "Utils.h"

using namespace std;

class Player {
public:
	// Attributes
	string cromossomial;
	int colorOpt;
	int nColors;
	vector<int> sensors;
	// Game Attributes
	bool alive;
	double score;
	double totalScore;
	int px;
	int py;
// Private: modifiable only via member methods
private: 
	 // Attributes
	int nSensors;
	int nextMove;
	int dMax; // Max sensor distance
	// Neural Network Attributes
	int nBitsW1;
	int nBitsW2;
	int nNeuronsL1;
	int nNeuronsL2;
private:
	// Private functions	
	void initNeuralNetwork();
	void thinkNextStep();
	void readSensors(vector<vector <int>> &map, int wMap, int hMap);
	void initPlayer();
public:
	// Constructor
	Player(int x0, int y0, int nColors, int dMax, int nBitsW1, int nBitsW2, int nNeuronsL1, int nNeuronsL2);
	// Internal Functions		
	void movePlayer(vector<vector <int>> &map, int wMap, int hMap); 
	int cromossomialSize();
};
