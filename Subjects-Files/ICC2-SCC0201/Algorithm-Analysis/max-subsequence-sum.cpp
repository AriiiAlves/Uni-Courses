#include <vector>
#include <iostream>
#include <climits>
using namespace std;

// Kadane: O(n)
int kadane(vector<int> v, int n){
    if(n==1) return v[0];

    // Kadane
    int maxGlobalSum = INT_MIN;
    int localGlobalSum = INT_MIN;

    for(int i=1; i<n; i++){
        localGlobalSum = max(localGlobalSum + v[i], v[i]);
        if(localGlobalSum > maxGlobalSum) maxGlobalSum = localGlobalSum;
    }

    return maxGlobalSum;
}

// Brute-Force: O(n³)
int bruteforce(vector<int> v, int n){
    if(n==1) return v[0];

    int maxSum = INT_MIN;
    int sum;

    for(int i=0; i<n; i++){
        for(int j=i; j<n; j++){
            sum = 0;
            for(int k=i; k <= j; k++) sum+=v[k];
            maxSum = max(sum, maxSum);
        }
    }

    return sum;
}

// Brute-Force: O(n²)
int bruteforce2(vector<int> v, int n){
    if(n==1) return v[0];

    int sum, max =0;

    for(int i=0; i<n; i++){
        sum = 0;
        for(int j=i; j<n; j++){
            sum+=v[j];
            if(sum > max) max = sum;
        }
    }

    return max;
}

// Divide-And-Conquer: nlog(n)
int calcCenter(vector<int> v, int L, int center, int R){
    int maxSumL = INT_MIN;
    int maxSumR = INT_MIN;
    int sum = 0;
    for(int i=center+1; i<R; i++) {
        sum += v[i];
        maxSumR = max(sum, maxSumR);
    }
    if(center==R) maxSumR = v[center];
    sum = 0;

    for(int i=L; i<center; i++) {
        sum += v[i];
        maxSumL= max(sum, maxSumL);
    }

    return maxSumR + maxSumL;
}

int divideAndConquer(vector<int> v, int L, int R){
    if(L==R) return v[0];

    int maxL, maxR, maxC, center;

    if(maxL == maxR) return (v[maxL] < 0) ? 0 : v[maxL];
    center = (L + R) / 2;

    maxL = divideAndConquer(v, L, center);
    maxR = divideAndConquer(v, center+1, R);
    maxC = calcCenter(v, L, center, R);

    if(maxL > maxR && maxL > maxC) return maxL;
    if(maxR > maxL && maxR > maxC) return maxR;
    return maxC;
}

int main(){
    vector<int> v = {-2, 11, -4, 13, -5, -2};
    int n = v.size();

    cout << "Kadane: " << kadane(v, n) << endl;
    cout << "Brute-Force: " << bruteforce(v, n) << endl;
    cout << "Brute-Force: " << bruteforce2(v, n) << endl;
    cout << "Divide-And-Conquer: " << divideAndConquer(v, 0, v.size() - 1) << endl;
}