#pragma once

#include <SDL2/SDL.h>
#include <vector>
#include "Player.h"

class Draw{
public:
	bool running;
private:
	vector<vector<int>> &map;
	int wMap;
	int hMap;
	vector<Player> &population;
	int populationSize;
	SDL_Renderer* renderer;
	SDL_Window* window;
	SDL_Event event;
	int CELL_SIZE;

	void selectColor(int opt);
	void drawInit();
public:
	// Constructor
	Draw(vector<vector<int>> &map, int wMap, int hMap, vector<Player> &population, int populationSize, int CELL_SIZE);
	// Destructor
	~Draw();
	// Member Functions
	void drawMap();
	void delay(int time_ms);
};
