#include "Player.h"

using namespace std;

// Private functions	
void Player::initNeuralNetwork(){
	// First Layer
	// Linhas = Neurônios
	for(int i = 0; i < this->nNeuronsL1; i++){
		for(int j = 0; j < nBitsW1 * (this->nSensors); j++){
			if(dist1Int()){
				cromossomial.push_back('1');
			} else {
				cromossomial.push_back('0');
			}
		}
	}
	
	// Final Layer
	for(int i = 0; i < this->nNeuronsL2; i++){
		for(int j = 0;j < nBitsW2 * nNeuronsL1; j++){
			if(dist1Int()){
				cromossomial.push_back('1');
			} else {
				cromossomial.push_back('0');
			}
		}
	}
}

void Player::thinkNextStep(){
	vector<int> inputs = this->sensors;
	int nInputs = inputs.size();
	vector<int> L1Outputs;
	vector<int> FLOutputs;
	int sum;
	int maxIdx = 0;
	
	// First Layer
	for(int i = 0; i < nNeuronsL1; i++){
		sum = 0;
		for(int j = 0; j < nInputs; j++) sum += ((binToInt(cromossomial, 0+nBitsW1*j+nBitsW1*nInputs*i , (nBitsW1-1)+nBitsW1*j+nBitsW1*nInputs*i)) - pow(2, nBitsW1-1)) * inputs[j]; 
		if(sum<0) sum=0; // ReLU
		L1Outputs.push_back(sum);
	}

	int offset = nNeuronsL1*nBitsW1*nInputs;
	
	// Final Layer
	for(int i = 0; i < nNeuronsL2; i++){
		sum = 0;
		for(int j = 0; j < nNeuronsL1; j++) sum += ((binToInt(cromossomial, offset+nBitsW2*j+nBitsW2*nNeuronsL1*i , offset+(nBitsW2-1)+nBitsW2*j+nBitsW2*nNeuronsL1*i)) - pow(2, nBitsW2-1)) * L1Outputs[j];
		// Final Layer does not have ReLU
		FLOutputs.push_back(sum);
	}
	
	// Choose the greater index
	for(int i = 0; i < FLOutputs.size(); i++) if(FLOutputs[i] > FLOutputs[maxIdx]) maxIdx = i;

	this->nextMove = maxIdx;
}

void Player::readSensors(vector<vector <int>> &map, int wMap, int hMap){
	int d = 1;
	this->sensors.clear();

	while(this->px+d < wMap && map[this->py][this->px + d] == 0) d++; // Right
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->px-d >= 0 && map[this->py][this->px - d] == 0) d++; // Left
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py-d >= 0 && map[this->py - d][this->px] == 0) d++; // Up
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py+d < hMap && map[this->py + d][this->px] == 0) d++;// Back
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py-d >= 0 && px+d < wMap && map[this->py - d][this->px + d] == 0) d++; // Up-Right
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py-d >= 0 && px-d >= 0 && map[this->py - d][this->px - d] == 0) d++; // Up-Left
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py+d < hMap && px+d < wMap && map[this->py + d][this->px + d] == 0) d++; // Down-Right
	this->sensors.push_back(min(d,dMax));
	d = 1;
	while(this->py+d < hMap && px-d >= 0 && map[this->py + d][this->px - d] == 0) d++; // Down-Left
	this->sensors.push_back(min(d,dMax));
}

void Player::initPlayer(){
	this->nextMove = 0;
	this->alive = true;
	this->colorOpt = (int) (dist1Real() * this->nColors);
	this->nSensors = 8;
	this->score = 0;
	this->totalScore = 0;

	initNeuralNetwork();
}

// Constructor
Player::Player(int x0, int y0, int nColors, int dMax, int nBitsW1, int nBitsW2, int nNeuronsL1, int nNeuronsL2) : px(x0), py(y0), nColors(nColors), dMax(dMax), nBitsW1(nBitsW1), nBitsW2(nBitsW2), nNeuronsL1(nNeuronsL1), nNeuronsL2(nNeuronsL2) { initPlayer(); }

// Internal Functions		
void Player::movePlayer(vector<vector <int>> &map, int wMap, int hMap) {
	int nx = this->px;
	int ny = this->py;	
	
	// If died, don't do anything
	if(!this->alive) return;

	// If obstacle reached player, player dies
	if(map[ny][nx] == 1) { this->alive = false; return; }
	
	readSensors(map, wMap, hMap);
	thinkNextStep();

	if(this->nextMove == 0) { ny -= 1; } // Up
	if(this->nextMove == 1) { ny -= 1; nx += 1; } // Up-Right
	if(this->nextMove == 2) { nx += 1; } // Right
	if(this->nextMove == 3) { ny += 1; nx += 1; } // Down-Right
	if(this->nextMove == 4) { ny += 1; } // Down
	if(this->nextMove == 5) { ny += 1; nx -= 1; } // Down-Left
	if(this->nextMove == 6) { nx -= 1; } // Left
	if(this->nextMove == 7) { ny -= 1; nx -= 1; } // Up-Left

	if(nx > wMap-1 || ny > hMap-1 || nx < 0 || ny < 0) { if(score > 0 )this->alive = false; return; } // Out-of-bounds (dies)

	// If valid, updates player position
	this->px = nx;
	this->py = ny;
	
	// If obstacle, player dies
	if(map[ny][nx] == 1) this->alive = false;
	else this->score++;
}

int Player::cromossomialSize(){ return (this->nNeuronsL1 * this->nBitsW1 * (this->nSensors) + this->nNeuronsL2 * this->nBitsW2 * this->nNeuronsL1); }
