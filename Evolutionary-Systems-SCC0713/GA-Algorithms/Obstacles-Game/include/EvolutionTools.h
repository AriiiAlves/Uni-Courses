#pragma once
#include <vector>
#include <math.h>
#include <iostream>
#include "Player.h"
#include "Utils.h"

void uniformCrossover(Player &parent1, Player &parent2, Player &child);
void mutation(Player &child, double avgScore, double bestScore);
void rouletteCrossoverAndMutation(vector<Player> &population);
void multiParentCrossover(vector<Player> &population, vector<Player> &chosen, int bestIdx, double avgScore, double bestScore);
