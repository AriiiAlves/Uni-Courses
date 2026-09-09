#include "Graphic.h"

void Draw::selectColor(int opt){
	struct Color { int r,g,b,a; };

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
	SDL_SetRenderDrawColor(this->renderer, c.r, c.g, c.b, c.a);
}

void Draw::drawInit(){
	SDL_Init(SDL_INIT_VIDEO);
	this->window = SDL_CreateWindow("Pixel SDL2", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, this->CELL_SIZE * this->wMap, this->CELL_SIZE * this->hMap, 0);
	this->renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	this->running = true;
}

// Constructor
Draw::Draw(vector<vector<int>> &map, int wMap, int hMap, vector<Player> &population, int populationSize, int CELL_SIZE) : map(map), wMap(wMap), hMap(hMap), population(population), populationSize(populationSize), CELL_SIZE(CELL_SIZE) { drawInit(); }

// Destructor
Draw::~Draw(){ SDL_DestroyRenderer(this->renderer); SDL_DestroyWindow(this->window); SDL_Quit(); }

void Draw::drawMap() {
	while(SDL_PollEvent(&this->event)) if (event.type == SDL_QUIT) this->running = false;
	// Paints black background (resets)
	SDL_SetRenderDrawColor(this->renderer, 0, 0, 0, 255);
	SDL_RenderClear(this->renderer);
	// Draw everything
	for(int y = 0; y < this->hMap; y++){
		for(int x = 0; x < this->wMap; x++) { 
			if(map[y][x] == 1) SDL_SetRenderDrawColor(this->renderer,255,0,0,255);
			else SDL_SetRenderDrawColor(this->renderer,0,0,0,255);
			
			SDL_Rect rect = { x * this->CELL_SIZE, y * this->CELL_SIZE, this->CELL_SIZE, this->CELL_SIZE };
			SDL_RenderFillRect(this->renderer, &rect);
		}
	}
	
	for(int i = 0; i < this->populationSize; i++){
		if(this->population[i].alive) Draw::selectColor(this->population[i].colorOpt);
		else SDL_SetRenderDrawColor(this->renderer, 255, 255, 255, 255);
		SDL_Rect rect = { this->population[i].px * CELL_SIZE, this->population[i].py * this->CELL_SIZE, this->CELL_SIZE, this->CELL_SIZE };
		SDL_RenderFillRect(this->renderer, &rect);
	}

	// Render everything
	SDL_RenderPresent(this->renderer);
}

void Draw::delay(int time_ms) { SDL_Delay(time_ms); }
