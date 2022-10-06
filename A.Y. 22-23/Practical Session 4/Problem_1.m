clear, close, clc;

Matrice1 = [1 2 3 78; 2 3 4 7; 5 7 6 5];
Matrice2 = [55 89 57 1; 3 5 6 2; 76 847 1283 56];

ResultingMatrix = SumMatrix(Matrice1, Matrice2);
ResultingMatlab = Matrice1 + Matrice2;

disp('My Sum Function')
disp(ResultingMatrix)

disp('MATLAB Sum Function')
disp(ResultingMatlab)

%% Function definition

function SM = SumMatrix(A, B)

[nr1, nc1] = size(A);
[nr2, nc2] = size(B);

SM = ones(nr1, nc1);

if nr1 == nr2 && nc1 == nc2
    for i = 1:nr1
        for j = 1:nc1
            SM(i,j) = A(i,j) + B(i,j);
        end
    end
else
    error('The dimensions of the two matrices are not coherent!')
end

end
