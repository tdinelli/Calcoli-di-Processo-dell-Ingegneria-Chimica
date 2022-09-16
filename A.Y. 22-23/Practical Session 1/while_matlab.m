sum = 0;
token = 0;

while(sum < 325)
    token = token + 1;
    sum = sum + token;
end

disp(['Iteration number: ', num2str(token)])
disp(['Sum is equal to: ', num2str(sum)])