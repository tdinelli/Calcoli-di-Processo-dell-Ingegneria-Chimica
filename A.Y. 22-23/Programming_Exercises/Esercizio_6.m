clear, close, clc

A = [1 2 3; 4 5 6; 7 8 9];
[row, col] = size(A);
B = A;
for i = 1 : row
    mean = media(B,i);
    B(i,i) = mean;
end
 
disp(A);
disp(B);

function f = media (B, i)
    % Funzione che calcola la media della i-esima riga di una matrice
    [row, col] = size(B);
    sum = 0; 
    for j = 1 : col
        sum = sum + B(i,j);
    end
    f = sum / col;
end