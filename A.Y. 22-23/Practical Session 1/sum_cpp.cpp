#include <iostream>

int main(){

	int sum = 0;
	for(int i=1; i<=100; i++){
		sum = sum + i;
	}
	std::cout << "The sum of the first 100 naturals numbers is:  " << sum << std::endl; 
	return 0;

}
