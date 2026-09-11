# Obstacles Game

A simple game created with the purpose of run a evolutionary algorithm trying to find a great solution of autonomous player. The game consists in falling random red blocks. A succesfully move (without dying) gives 1 point to the player. The score count stops when the player dies touching the red pieces or trying to move out of map bounds.

The game is 2D, created with SDL, a simple graphic library.

## The map and obstacles

The map is a square matrix `N=64x64`. In the matrix, `0` means free space for moving. `1` means an obstacle.

The obstacles are small `n=4x4` hand-made matrices. They can be customized.

## The queues

For random falling, there were created `N/n` queues of pieces. To working queues, `n` should be `N` divisor. The queues stores random selected pieces. The first piece of each queue is the current piece being inserted into the map peak.

To do this behavior functional, it was used a linked list data structure.

1. The queues starts empty, with Head and Tail equals NULL pointers.
2. After `m` player moves, there is a `0 < q_tax < 1` chance of adding a piece into the queues. If yes, a random queue is selected. All the queues have the same chance of being selected. Only 1 insertion is done.
3. After the insertion, the map is updated: All the lines are copied to the next line, and the first line draws the next waiting piece line from the queue.
4. The loop repeats after `m` player moves.

## Player moving

The player can move in 8 directions: front, back, left, right, front-right, front-left, back-right, back-left.

## Player thinking (neural network)

Each player has 8 sensors in the 8 directions of moving: front, back, left, right, front-right, front-left, back-right, back-left. Each sensor have a `dMax` range limit. The sensor starts with `d=1`, and increases it until reaching `dMax`, an obstacle (a `1` in the map matrix) or the map bounds.

These 8 sensors inputs feeds a neural network initialized with random weights for each player. The neural network has:

- `nNeuronsL1` (custom) neurons in the hidden layer (L1) with `[-(nBitsW1/2), nBitsW2]` possible integer weight values.
- A `ReLU` function applied to the hidden layer outputs (`max(0,f(x))`).
- `nNeuronsL2 = 8` neurons in the output layer (L2) with `[-(nBitsW2/2), nBitsW2]` possible integer weight values, meaning `0-7` possible next moves (step prediction).

## Player cromossomial

The player cromossomial for the evolutionary algorithm consists into the neural network weights converted into a binary representation with `nBitsW-`, following the sequence: 

`[L1 1°Neuron 1°Input Weight],[L1 1°Neuron 2°Input Weight],...,[L1 2°Neuron 1°Input Weight],...,[L2 1°Neuron 1°Input Weight],...`

The total number of cromossomial bits are `nNeuronsL1*nBitsW1*nInputs + nNeuronsL2*nBitsW2*nNeuronsL1`.

## Evolutionary Algorithm

The evolutionary algorithm consists in 5 steps:

1. Initialize the population with `n` individuals
2. Fit the individuals (score of being alive) `batch` times. The final fitness is the average fitness.
3. Fitness normalization with `log`
4. Roulette method to select `n` individuals for crossover
5. Generate `n-1` children with random parents (of the selected individuals), applying uniform crossover. The best individual is mantained.
6. Applies mutation operator for new individuals (chance of inverting cromossomial bits).

### Mutation operator

It was created a dymanic mutation operator, that follow the formula:

$$mutationTax = min(\frac{\text{avgScore}}{\text{bestScore}-\text{avgScore}} \cdot \text{mutationUnit}, \text{mutationMax})$$

Where $mutationUnit = 1/L$, $L$ = total number of cromossomial bits, and $max$ = max tax of mutation designed for the algorithm. It represents a chance of 1 bit suffer mutation.

This formula increases the mutation if the score diversity decreases, and "stop" mutation if there is a player being much better than others (is desired to approach the other individuals to this one).
