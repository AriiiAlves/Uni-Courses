#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstdio>

int main(int argc, char* argv[]) {
	using namespace std;

	vector<vector<string>> data;
	vector<string> row;
	vector<int> gen;
	vector<int> bestScore;
	vector<double> avgScore;
	string line;

	if(argc < 4){ cerr << "Correct use: " << argv[0] << " <csvFileName> <initGen> <endGen>" << endl; return 1; }
	
	string fileName = argv[1];
	int initGen = stoi(argv[2]);
	int endGen = stoi(argv[3]);
	int lineCount = 0;

	ifstream file(fileName);
	if(!file.is_open()) { cerr << "Failed to open file" << endl; return 1; }

	while(getline(file, line)){
		if(lineCount == 0) { lineCount++; continue; }
		if(lineCount >= endGen) break;
		if(lineCount >= initGen){
			vector<string> row;
			stringstream ss(line);
			string cell;

			while(getline(ss, cell, ',')) row.push_back(cell);
			if(!row.empty()) data.push_back(row);
		}

		lineCount++;
	}

	for(int i=0;i<data.size();i++){
		gen.push_back(stoi(data[i][0]));
		bestScore.push_back(stoi(data[i][1]));
		avgScore.push_back(stod(data[i][2]));
	}

	file.close();

	// Generating charts
	FILE* gp = popen("gnuplot -persistent", "w");
	if(!gp) return 1;

	fprintf(gp, "set title 'Fitness over generations'\n");
	fprintf(gp, "set xlabel 'Generation'\n");
	fprintf(gp, "set ylabel 'Score'\n");

	// Optional: save into PNG instead opening window
	// fprintf(gp, "set term png size 800,600\n");
    	// fprintf(gp, "set output 'grafico.png'\n");
	
	// Prepara os plots: '-' significa que os dados virão nas próximas linhas
	fprintf(gp, "plot '-' with lines lw 2 lc rgb 'blue' title 'Best Fitness', \\\n");
	fprintf(gp, "     '-' with lines lw 2 lc rgb 'red' title 'Avg Fitness'\n");

	// 1. Envia os dados da curva 1
	for (size_t i = 0; i < gen.size(); ++i) fprintf(gp, "%d %d\n", gen[i], bestScore[i]);
	fprintf(gp, "e\n"); // 'e' avisa ao gnuplot que a primeira curva terminou

	// 2. Envia os dados da curva 2
	for (size_t i = 0; i < gen.size(); ++i) fprintf(gp, "%d %.2f\n", gen[i], avgScore[i]);
	fprintf(gp, "e\n"); // termina a segunda curva

	fflush(gp);
	pclose(gp);

	return 0;
}
