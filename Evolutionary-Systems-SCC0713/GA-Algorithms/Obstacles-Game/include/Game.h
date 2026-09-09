#pragma once
#include <vector>
#include <math.h>
#include <algorithm> // For clamp
#include "Utils.h"
#include "Game.h"

using namespace std;

typedef struct queueNode{
	int piece;
	int line;
	queueNode* next;
} QueueNode;


class Map{
public:
	vector<vector <int>> map;
	int wMap;
	int hMap;
private:
	QueueNode** queues;
	int nQueues;
	int pieceSize;
	int nPieces;
	double insertTax;
	static const vector<vector<vector <int>>> PIECES;
	// Internal Functions	
	void initMap();
	void queueNodeInsert(QueueNode* &queue, int piece);
	void clearQueues();

public:
	// Constructor
	Map(int wMap, int hMap, double insertTax);
	// Destructor
	~Map();
	// Member Functions
	void updateMap();
	void cleanMap();
	void setInsertTax(double tax);
	void randomQueueInsert();
};
