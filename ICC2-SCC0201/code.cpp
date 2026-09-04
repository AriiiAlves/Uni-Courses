#include<bits/stdc++.h>
#include<stdio.h>
using namespace std;

int main(){
    vector<vector<int>> M;
    int n;

    cout << "[[";
    for(int i=0;i<n;i++){
        if(i) cout << " [";
        vector<int> row;
        for(int j=0;i<n;j++){
            row.push_back(rand() % 100);

            if(j<n-1) cout << row[j] << ", ";
            else cout << row[j];
        }
        M[i].push_back(row);
        if(i<n-1) cout << "]," << endl;
        else cout << "]" << endl;
    }
}