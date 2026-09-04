#include<stdio.h>

float pot(float base, int exp){
	float res = 1;

	if(exp==0) return 1;

	for(int i=0;i<exp;i++){
		res*=base;
	}

	if(exp<0) return 1/res;
	return res;
}

float fat(int n){
	float res = 1;

	if(n<0) return 0;

	for(int i=1; i<n;i++){
		res*=res+1;
	}
	return res;
}

// S = 1-X^2/3! + X^4/5! - X^6/7! + ...
float series(float x, int n){
	float res = 1;

	for(int i=1; i<=n; i++){
		res+= pot(-1, i) * pot(x, i*2) / fat(i*2 +1);
	}

	//printf("%f\n", res);
	return res;
}

int main(){
	float res = pot(2.0,5);
	printf("%.2f\n", res);
	res = fat(3);
	printf("%.0f\n", res);
	res = series(1,3);
	printf("%.5f\n", res);
	return 0;
}