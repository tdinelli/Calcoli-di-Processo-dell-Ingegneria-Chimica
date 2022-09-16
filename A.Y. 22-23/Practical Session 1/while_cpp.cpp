#include <iostream>

int main(){

	int sum = 0;
	int token = 0;

	while(sum < 325){
		token = token + 1;
		sum = sum + token;
	}

	std::cout << "Iteration number: " << token << std::endl;
	std::cout << "Sum is equal to: " << sum << std::endl;

	return 0;
}
