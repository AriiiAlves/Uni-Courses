#include<string>
#include<vector>
#include<random>
#include<iostream>
#include<math.h>
#include<iomanip>
#include <fstream> // For file operations
#include<SDL2/SDL.h>
using namespace std;

// C++ Random Generator para uma boa distribuição probabilística
random_device dev;
mt19937 rng(dev());
uniform_int_distribution<int> dist1_int(0,1); // Inteiro no intervalo [0,1]
uniform_real_distribution<double> dist1_real(0.0, 1.0); // Double no intervalo [0, 100]
// Para gerar random: dist1(rng) // dist43(rng) // dist1(rng)

typedef struct player{
	string cromossomial;
	int x;
	int y;
	vector<int> sensors;
	int nextMove;
	bool alive;
	int colorOpt;
	int penalty;
} Player;

vector<vector<vector<int>>> PIECES = {
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

void printMap(vector<vector <int>> &map){
	cout << "Drawing map" << endl;
	for(int y = 63; y >= 0; y--){
		for(int x = 0; x < 64; x++){
			cout << map[y][x] << " ";
		}
		cout << endl;
	}
}

typedef struct queueNode{
	int piece;
	int line;
	queueNode* next;
} QueueNode;

void initQueues(QueueNode** &queues, int nQueues){
	queues = (QueueNode**)malloc(sizeof(QueueNode*) * nQueues);
	for(int i = 0; i < nQueues; i++){
		queues[i] = NULL; // NULL = No piece
	}	
}

void initNeuralNetwork(string &cromossomial, int nInputs, int nBitsW1, int nBitsW2, int nNeuronsL1, int nNeuronsL2){
	// First Layer
	// Linhas = Neurônios
	for(int i = 0; i < nNeuronsL1; i++){
		for(int j = 0; j < nBitsW1 * nInputs; j++){
			if(dist1_int(rng)){
				cromossomial.push_back('1');
			} else {
				cromossomial.push_back('0');
			}
		}
	}
	
	// Final Layer
	for(int i = 0; i < nNeuronsL2; i++){
		for(int j = 0;j < nBitsW2 * nNeuronsL1; j++){
			if(dist1_int(rng)){
				cromossomial.push_back('1');
			} else {
				cromossomial.push_back('0');
			}
		}
	}
}

void initPlayer(Player &player, int x, int y, int nInputs, int nBitsW1, int nBitsW2, int nNeuronsL1, int nNeuronsL2, int colorOpt){
	initNeuralNetwork(player.cromossomial, nInputs, nBitsW1, nBitsW2, nNeuronsL1, nNeuronsL2);
	player.x = x;
	player.y = y;
	player.nextMove = 0;
	player.alive = true;
	player.colorOpt = colorOpt;
	player.penalty = 0;
}

int binToInt(string &cromossomial, int begin, int end){
	int aux = 0;

	for(int i = 0; i <= (end-begin); i++){
		if(cromossomial[i+begin] == '1') aux += pow(2,i);
	}

	return aux;
}

void neuralThinking(Player &player, vector<int> &inputs, int nInputs, int nBitsW1, int nBitsW2, int nNeuronsL1, int nNeuronsL2){
	vector<int> L1Outputs;
	vector<int> FLOutputs;
	int sum;
	int maxIdx = 0;
	
	// First Layer
	for(int i = 0; i < nNeuronsL1; i++){
		sum = 0;
		for(int j = 0; j < nInputs; j++) sum += ((binToInt(player.cromossomial, 0+nBitsW1*j+nBitsW1*nInputs*i , (nBitsW1-1)+nBitsW1*j+nBitsW1*nInputs*i)) - pow(2, nBitsW1-1)) * inputs[j]; 
		if(sum<0) sum=0; // ReLU
		L1Outputs.push_back(sum);
	}
	
	// Final Layer
	for(int i = 0; i < nNeuronsL2; i++){
		sum = 0;
		for(int j = 0; j < nNeuronsL1; j++) sum += ((binToInt(player.cromossomial, 0+nBitsW2*j+nBitsW2*nNeuronsL1*i , (nBitsW2-1)+nBitsW2*j+nBitsW2*nNeuronsL1*i)) - pow(2, nBitsW2-1)) * L1Outputs[j];
		if(sum<0) sum=0; // ReLU
		FLOutputs.push_back(sum);
	}
	
	// Choose the greater index
	for(int i = 0; i < FLOutputs.size(); i++) if(FLOutputs[i] > FLOutputs[maxIdx]) maxIdx = i;

	player.nextMove = maxIdx;
}

void movePlayer(Player &player, vector<vector<int>> map, int hMap, int wMap, int option){
	int saveX = player.x;
	int saveY = player.y;

	if(option == 0) { player.y -= 1; } // Up
	if(option == 1) { player.y -= 1; player.x += 1; } // Up-Right
	if(option == 2) { player.x += 1; } // Right
	if(option == 3) { player.y += 1; player.x += 1; } // Down-Right
	if(option == 4) { player.y += 1; } // Down
	if(option == 5) { player.y += 1; player.x -= 1; } // Down-Left
	if(option == 6) { player.x -= 1; } // Left
	if(option == 7) { player.y -= 1; player.x -= 1; } // Up-Left

	if(player.x > hMap-1 || player.y > wMap-1 || player.x < 0 || player.y < 0) { player.y = saveY; player.x = saveX; player.penalty++; } // Out-of-bounds (remain stopped)
	if(map[player.y][player.x] == 1) player.alive = false; // Obstacle (player dies)
}

void readSensors(Player &player, vector<vector<int>> &map, int wMap, int hMap){
	int d = 0;
	player.sensors.clear();

	while(map[player.y][player.x + d] == 0) { d++; if(player.x+d >= wMap-1) break; } // Right
	player.sensors.push_back(d);
	d = 0;
	while(map[player.y][player.x - d] == 0) { d--; if(player.x-d <= 0) break; } // Left
	player.sensors.push_back(d);
	d = 0;
	while(map[player.y - d][player.x] == 0) { d++; if(player.y-d <= 0) break; } // Up
	player.sensors.push_back(d);
	d = 0;

	if(player.x < wMap) while(map[player.y - d][player.x + 1] == 0) { d++; if(player.y-d <= 0) break; } // Up-Right
	player.sensors.push_back(d);
	d = 0;
	if(player.x > 0) while(map[player.y - d][player.x - 1] == 0) { d++; if(player.y-d <= 0) break; } // Up-Left
	player.sensors.push_back(d);
	
	d = 0;
	while(map[player.y + d][player.x] == 0) { d++; if(player.y+d >= hMap-1) break; } // Back
	player.sensors.push_back(d);
}

void uniformCrossover(string &parent1, string &parent2, string &child, int n){
	for(int i = 0; i < n; i++){
		if(dist1_int(rng)) child[i] = parent1[i];
		else child[i] = parent2[i];
	} 
}

void mutation(string &child, int n, double mutation_tax){
	for(int i = 0; i < n; i++){
		double rnd = dist1_real(rng);

		if(rnd < mutation_tax){
			// Inverte
			if(child[i] == '1') child[i] = '0';
			else child[i] = '1';
		}
	}
}

void queueNodeInsert(QueueNode* &queue, int piece, int pieceSize){
	QueueNode* node = queue;
	
	// Selects last node
	if(queue == NULL) { 
		node = (QueueNode*) malloc(sizeof(QueueNode*)); 
		queue = node; 
	} else { 
		while(node->next != NULL) node = node->next;
		node->next = (QueueNode*) malloc(sizeof(QueueNode*));
		node = node->next;
	}

	node->piece = piece;
	node->line = pieceSize-1;
	node->next = NULL;
}

void randomQueueInsert(QueueNode** &queues, int nQueues, double insertTax, int nPieces, int pieceSize){
	// Decides if will insert or not
	double rnd = dist1_real(rng);
	if(rnd < insertTax){
		// Decides which queue
		int rnd2 = round(dist1_real(rng) * (nQueues-1));
		// Decides which piece
		int rnd3 = round(dist1_real(rng) * (nPieces-1));

		// Enter a piece into a queue
		queueNodeInsert(queues[rnd2], rnd3, pieceSize);
	}
}

void updateMap(vector<vector <int>> &map, int wMap, int hMap, QueueNode** &queues, int nQueues, int pieceSize){
	// Shifts map
	for(int i = hMap-1; i > 0; i--){
		for(int j = 0; j < wMap; j++){
			map[i][j] = map[i-1][j]; // Copy line above
		}
	}

	// Each queue is one partition of the map
	for(int i = 0; i < nQueues; i++){
		if(queues[i] == NULL) {
			// Fill with zeros
			for(int k = 0; k < pieceSize; k++) map[0][k + pieceSize * i] = 0;
			continue;
		};
		
		for(int k = 0; k < pieceSize; k++){
			map[0][k + pieceSize * i] = PIECES[queues[i]->piece][queues[i]->line][k]; // Writes piece into map
		}
		queues[i]->line--;

		// If end to draw the piece, delete item from queue
		if (queues[i]->line < 0){
			if(queues[i]->next == NULL) queues[i] = NULL;
			else {
				QueueNode* oldHead = queues[i];
				queues[i] = queues[i]->next;
				free(oldHead);
			}
		}
	}
}

void selectColor(SDL_Renderer* renderer, int opt){
	struct Color { Uint8 r,g,b,a; };

	const Color PALETTE[9] = {
	    {100, 100, 100, 255}, // Vermelho
	    {  0, 255,   0, 255}, // Verde
	    {  0,   0, 255, 255}, // Azul
	    {255, 255,   0, 255}, // Amarelo
	    {  0, 255, 255, 255}, // Ciano
	    {255,   0, 255, 255}, // Magenta
	    {255, 128,   0, 255}, // Laranja
	    {128,   0, 255, 255}, // Roxo
	    {128, 128, 128, 255}  // Cinza
	};

	Color c = PALETTE[opt % 9];
	SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a);
}

void drawMap(vector<vector <int>> &map, int wMap, int hMap, vector<Player> &population, int populationSize, SDL_Renderer* renderer, int CELL_SIZE) {
	for(int y = 0; y < hMap; y++){
		for(int x = 0; x < wMap; x++) { 
			if(map[y][x] == 1) SDL_SetRenderDrawColor(renderer,255,0,0,255);
			else SDL_SetRenderDrawColor(renderer,0,0,0,255);
			
			SDL_Rect rect = { x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE };
			SDL_RenderFillRect(renderer, &rect);
		}
	}
	
	for(int i = 0; i < populationSize; i++){
		if(population[i].alive) selectColor(renderer, population[i].colorOpt);
		else SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
		SDL_Rect rect = { population[i].x * CELL_SIZE, population[i].y * CELL_SIZE, CELL_SIZE, CELL_SIZE };
		SDL_RenderFillRect(renderer, &rect);
	}
}

void cleanMap(vector<vector <int>> &map, int wMap, int hMap){
	for(int y = 0; y < hMap; y++)
		for(int x = 0; x < wMap; x++)
			map[y][x] = 0;
}

void clearQueues(QueueNode** &queues, int nQueues){
	for(int i = 0; i < nQueues; i++){
		QueueNode* node = queues[i];
		QueueNode* next = NULL;
		while(node != NULL){
			next = node->next;
			free(node);
			node = next;
		}
	}
}

int main(){
	// Vectors
	vector<Player> population;
	vector<int> fitness;
	vector<vector<int>> map;
	vector<int> inputs;

	// Variables
	int nInputs = 8; // xp,yp,x0,x1,y0,y1,y2,b0
	int hMap = 64; // Pixels
	int wMap = 64; // Pixels
	int pieceSize = PIECES[0].size();
	int nPieces = PIECES.size();
	
	// Evolutionary Algorithm Config
	int n = 50; // Número de indivíduos (deve ser par)
	int generation = 0; // Número da geração
	double mutationTax = 0.05;
		
	// Neural Network Config
	int nBitsW1 = 10;
	int nBitsW2 = 10;
	int nNeuronsL1 = 12; // Hidden layer
	int nNeuronsL2 = 8; // 8 possible outputs (moving 0-7)
	int totalBits = nInputs * nBitsW1 * nNeuronsL1 + nNeuronsL1 * nBitsW2 * nNeuronsL2;

	// Game Config
	int x0 = wMap/2;
	int y0 = hMap-1;
	int CELL_SIZE = 10; // Pixels
	int nSensors = 6;
	int nMoves = 3; // Possible moves before obstacles position update (low nMoves = Higher difficult)
	double insertQueueTax = 0.5; // Chance of piece inserting (high = higher difficult)
	
	// Queues
	int nQueues = wMap / pieceSize; // 64, 4 -> 16
	QueueNode** pieceQueues = (QueueNode**) malloc(sizeof(QueueNode*) * nQueues);

	// Data
	double mediumScore = 0;
	ofstream myFile("EA-Data.csv");

	// Graphic Rendering
	SDL_Init(SDL_INIT_VIDEO);
	SDL_Window* window = SDL_CreateWindow("Pixel SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, CELL_SIZE * wMap, CELL_SIZE * hMap, 0);
	SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	bool running = true;
	SDL_Event event;
	int nColors = 9;

	
	// Open File
	if(!myFile.is_open()) {
		cout << "Error opening the file" << endl;
		return 1;
	}

	myFile << "Generation,Best Score,Medium Score\n";

	// Init queues
	initQueues(pieceQueues, nQueues);

	// Init map with zeros
	for(int i = 0; i < hMap; i++){
		vector<int> line;
		for(int j = 0; j < wMap; j++){
			line.push_back(0);
		}
		map.push_back(line);
	}	
	
	// Init population and fill fitness with zeros
	for(int i = 0; i < n; i++){
		Player player;
		int colorOpt = (int) round(dist1_real(rng) * (nColors-1));
		initPlayer(player, x0, y0, nInputs, nBitsW1, nBitsW2, nNeuronsL1, nNeuronsL2, colorOpt);
		population.push_back(player);
		fitness.push_back(0);
	}

	// Init Renderer
	// -- Black Background
	SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
	SDL_RenderClear(renderer);

	while(running){
		int survivors = n;
		long long int score = 0;
		int bestIdx = 0;

		// Closing Window
		while(SDL_PollEvent(&event)) if(event.type == SDL_QUIT) running = false;
		
		// One generation (until everybody dies) -> RUN!
		while(survivors){
			for(int k = 0; k < nMoves; k++){
				// Update map
				updateMap(map, wMap, hMap, pieceQueues, nQueues, pieceSize);
				// Makes everybody moves one step
				for(int i = 0; i < n; i++){
					inputs.clear();

					if(population[i].alive){
						inputs.push_back(population[i].x); // Inicial x
						inputs.push_back(population[i].y); // Initial y
						readSensors(population[i], map, wMap, hMap); // Read Sensors (distances)
						for(int j = 0; j < nSensors; j++) inputs.push_back(population[i].sensors[j]);
						neuralThinking(population[i], inputs, inputs.size(), nBitsW1, nBitsW2, nNeuronsL1, nNeuronsL2); // Calculate next move
						movePlayer(population[i], map, wMap, hMap, population[i].nextMove); // Try to move player (consider collisions)
						
						if(!population[i].alive) { survivors--; fitness[i] = score; }  
					}
				}
				randomQueueInsert(pieceQueues, nQueues, insertQueueTax, nPieces, pieceSize);
				// Draw after 1 step
				if(generation % 250 == 0) SDL_Delay(250); // Greater delay every 10 generations cycle
				//else SDL_Delay(1);
				// Paints Black background (resets)
				SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
				SDL_RenderClear(renderer);
				// Draw Map
				drawMap(map, wMap, hMap, population, n, renderer, CELL_SIZE);
				// Render everything
				SDL_RenderPresent(renderer);

				// Increase score
				score++;
			}
		}

		// Applies penalities for being stopped
		for(int i = 0; i < n; i++) fitness[i] = fitness[i]-population[i].penalty;

		// Selects the best
		for(int i = 0; i < n; i++) if(fitness[i] > fitness[bestIdx]) bestIdx = i;

		// Calculates Medium Score
		for(int i = 0; i < n; i++) mediumScore += (double)fitness[i];
		mediumScore /= (double)n;

		// Saving
		myFile << generation << "," << fitness[bestIdx] << "," << mediumScore << "\n";
		cout << "Gen(" << generation << ") - Best: " << fitness[bestIdx] << " | Avg: " << mediumScore << endl;

		// FLUSH!
		myFile.flush();

		// Crossover (substitute parent by its child) and Mutation
		for(int i = 0; i < n; i++){
			if(i == bestIdx) continue;
			uniformCrossover(population[bestIdx].cromossomial, population[i].cromossomial, population[i].cromossomial, totalBits);
			mutation(population[i].cromossomial, totalBits, mutationTax);
		}

		// Resets population
		for(int i = 0; i < n; i++){
			population[i].x = x0;
			population[i].y = y0;
			population[i].alive = true;
			population[i].penalty = 0;
		}

		// Clean map
		cleanMap(map, wMap, hMap);

		// Increments Generation
		generation++;
	}

	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
	clearQueues(pieceQueues, nQueues);

	myFile.close();
	return 0;
}
