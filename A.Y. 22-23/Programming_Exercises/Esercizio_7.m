clear, close, clc

A = [1 2 3; 4 5 6; 7 8 9];

[row, col] = size(A);

sum = somma(A);
 
for i = 1 : row
    for j = 1 : col
        if i < j
            B(i,j) = sum;
        elseif i > j
            B(i,j) = 0;
        end
        if i == j
            B(i,j) = A(i,j);
        end
    end
end
 
disp(A);
disp(B);

function f = somma (M)
    % Funzione che calcola la somma di tutti gli elementi della matrice B 
    % avente dimensioni r e 
    [row, col] = size(M);
    sum = 0;
    for i=1:row
        for j=1:col
            sum = sum + M(i,j);
        end
    end
    f = sum;
end