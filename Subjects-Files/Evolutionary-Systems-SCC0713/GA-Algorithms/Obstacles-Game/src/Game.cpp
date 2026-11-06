#include "Game.h"

const vector<vector<vector <int>>> Map::PIECES = {
	    {
		{0, 0, 0, 0},
		{0, 1, 1, 0},
		{0, 1, 1, 0},
		{0, 0, 0, 0}
	    },
	    {
		{0, 0, 0, 0},
		{1, 1, 1, 1},
		{1, 1, 1, 1},
		{0, 0, 0, 0}
	    },
	    {
		{0, 0, 0, 1},
		{0, 0, 0, 1},
		{0, 0, 0, 1},
		{1, 1, 1, 1}
	    },
	    {
		{1, 0, 0, 0},
		{1, 0, 0, 0},
		{1, 0, 0, 0},
		{1, 1, 1, 1}
	    },
	    {
		{1, 1, 0, 0},
		{0, 1, 1, 0},
		{0, 0, 1, 1},
		{0, 0, 0, 1}
	    },
	    {
		{0, 0, 1, 1},
		{0, 1, 1, 0},
		{1, 1, 0, 0},
		{1, 0, 0, 0}
	    },
	    {
		{0, 1, 1, 0},
		{0, 0, 1, 0},
		{0, 0, 1, 0},
		{0, 0, 1, 0}
	    },
	    {
		{0, 1, 1, 0},
		{0, 1, 0, 0},
		{0, 1, 0, 0},
		{0, 1, 0, 0}
	    },
	    {
		{1, 0, 0, 1},
		{1, 1, 1, 1},
		{1, 1, 1, 1},
		{1, 0, 0, 1}
	    }
	};
 
void Map::initMap(){
	for(int i = 0; i < this->hMap; i++){
		vector<int> line;
		for(int j = 0; j < this->wMap; j++){
			line.push_back(0);
		}
		this->map.push_back(line);
	}
	
	this->pieceSize = this->PIECES[0].size(); // Piece should be a square
	this->nPieces = this->PIECES.size();
	this->nQueues = this->wMap / this->pieceSize; // pieceSize should be wMap divisor
	this->queues = (QueueNode**) malloc(sizeof(QueueNode*) * nQueues);

	for(int i = 0; i < nQueues; i++) this->queues[i] = NULL;
}

void Map::queueNodeInsert(QueueNode* &queue, int piece){
	QueueNode* node = queue;
	
	// Selects last node
	if(queue == NULL) { 
		node = (QueueNode*) malloc(sizeof(QueueNode)); 
		queue = node; 
	} else { 
		while(node->next != NULL) node = node->next;
		node->next = (QueueNode*) malloc(sizeof(QueueNode));
		node = node->next;
	}

	node->piece = piece;
	node->line = this->pieceSize-1;
	node->next = NULL;
}

void Map::clearQueues(){
	for(int i = 0; i < this->nQueues; i++){
		QueueNode* node = this->queues[i];
		QueueNode* next = NULL;
		while(node != NULL){
			next = node->next;
			free(node);
			node = next;
		}
	}
}

// Constructor
Map::Map(int wMap, int hMap, double insertTax) : wMap(wMap), hMap(hMap), insertTax(clamp(insertTax, 0.0, 1.0)) { Map::initMap(); }

// Destructor
Map::~Map() { clearQueues(); free(this->queues); }

// Internal Functions
void Map::updateMap(){
	// Shifts map
	for(int i = this->hMap-1; i > 0; i--){
		for(int j = 0; j < this->wMap; j++){
			this->map[i][j] = this->map[i-1][j]; // Copy line above
		}
	}

	// Each queue is one partition of the map
	for(int i = 0; i < this->nQueues; i++){
		if(this->queues[i] == NULL) {
			// Fill with zeros
			for(int k = 0; k < this->pieceSize; k++) this->map[0][k + this->pieceSize * i] = 0;
			continue;
		};
		
		for(int k = 0; k < pieceSize; k++){
			this->map[0][k + this->pieceSize * i] = PIECES[this->queues[i]->piece][this->queues[i]->line][k]; // Writes piece into map
		}
		this->queues[i]->line--;

		// If end to draw the piece, delete item from queue
		if (this->queues[i]->line < 0){
			if(this->queues[i]->next == NULL) { free(queues[i]);  this->queues[i] = NULL; }
			else {
				QueueNode* oldHead = this->queues[i];
				this->queues[i] = this->queues[i]->next;
				free(oldHead);
			}
		}
	}
}

void Map::cleanMap(){
	for(int y = 0; y < this->hMap; y++)
		for(int x = 0; x < this->wMap; x++)
			this->map[y][x] = 0;
}

void Map::setInsertTax(double tax) { this->insertTax = clamp(tax, 0.0, 1.0); } // Leaves number inside range

void Map::randomQueueInsert(){
	// Decides if will insert or not
	double rnd = dist1Real();
	if(rnd < this->insertTax){
		// Decides which queue
		int rnd2 = dist1Real() * (this->nQueues); // Truncation (range: [0,1) -> 0.99 is the max)
		// Decides which piece
		int rnd3 = dist1Real() * (this->nPieces); // Truncation (range: [0,1) -> 0.99 is the max)

		// Enter a piece into a queue
		queueNodeInsert(this->queues[rnd2], rnd3);
	}
}
