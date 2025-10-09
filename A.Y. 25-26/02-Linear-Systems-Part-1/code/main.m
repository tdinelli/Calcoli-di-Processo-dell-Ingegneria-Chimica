%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%          Author: Marco Mehl <marco.mehl@polimi.it>                      %
%                  Timoteo Dinelli <timoteo.dinelli@polimi.it>            %
%          CRECK Modeling Lab <www.creckmodeling.polimi.it>               %
%          Department of Chemistry, Materials and Chemical Engineering    %
%          Politecnico di Milano                                          %
%          P.zza Leonardo da Vinci 32, 20133 Milano                       %
%                                                                         %
% ----------------------------------------------------------------------- %
clear variables
clc

%% Exercise 1: Upper triangular solver
fprintf('=== Exercise 1: Upper Triangular Solver ===\n');
A_test = [
    2, 3;
    0, 4
];
b_test = [8; 12];
x_test = solve_upper_triangular(A_test, b_test);
fprintf('Solution: x1 = %.4f, x2 = %.4f\n\n', x_test(1), x_test(2));

%% Exercise 2: Gauss Elimination
fprintf('=== Exercise 2: Gauss Elimination ===\n');
A_test2 = [1, 2, -1, 2; 1, 0, 2, 1; 2, 1, 0, -2; 0, 0, -1, 1];
b_test2 = [3; 1; 1; 2];
[U_result, b_result] = gauss_eliminate(A_test2, b_test2);
fprintf('Upper triangular matrix U created successfully\n');
fprintf('U = [\n');
fprintf(' %.2f, %.2f, %.2f, %.2f\n', U_result(1,:));
fprintf(' %.2f, %.2f, %.2f, %.2f\n', U_result(2,:));
fprintf(' %.2f, %.2f, %.2f, %.2f\n', U_result(3,:));
fprintf(' %.2f, %.2f, %.2f, %.2f\n', U_result(4,:));
fprintf(']\n');
fprintf('Modified b: [%.2f, %.2f, %.2f, %.2f]\n\n', b_result);

%% Exercise 3: Combine gauss elimination and backsostitution
fprintf('=== Exercise 3: Complete Linear Solver ===\n');
fprintf('Test System 1:\n');
A1 = [1, 2, -1, 2; 1, 0, 2, 1; 2, 1, 0, -2; 0, 0, -1, 1];
b1 = [3; 1; 1; 2];
x1 = my_linear_solver(A1, b1);
x1_matlab = A1 \ b1;

fprintf('My solution:       [%.4f, %.4f, %.4f, %.4f]\n', x1);
fprintf('MATLAB solution:   [%.4f, %.4f, %.4f, %.4f]\n', x1_matlab);
fprintf('Residual ||Ax-b||: %.5e\n\n', norm(A1*x1 - b1));

fprintf('Test System 2:\n');
A2 = [1, 45, 0, -1; 1, 0, 0, -3; 1, 1, 1, 0; 1, -1, 1, 1];
b2 = [6; 12; -6; 12];
x2 = my_linear_solver(A2, b2);
x2_matlab = A2 \ b2;

fprintf('My solution:       [%.4f, %.4f, %.4f, %.4f]\n', x2);
fprintf('MATLAB solution:   [%.4f, %.4f, %.4f, %.4f]\n', x2_matlab);
fprintf('Residual ||Ax-b||: %.5e\n\n', norm(A2*x2 - b2));

%% Exercise 4:
fprintf('=== Exercise 4: LU Decomposition ===\n');

% Test on System 1
fprintf('Test System 1 using LU:\n');
[L1, U1] = my_lu_decompose(A1);
x1_lu = my_lu_solver(A1, b1);

fprintf('LU solution:     [%.4f, %.4f, %.4f, %.4f]''\n', x1_lu);
fprintf('Decomposition accuracy ||L*U - A||: %.2e\n', norm(L1*U1 - A1));
fprintf('Solution accuracy ||Ax - b||: %.2e\n\n', norm(A1*x1_lu - b1));

% Test on System 2
fprintf('Test System 2 using LU:\n');
[L2, U2] = my_lu_decompose(A2);
x2_lu = my_lu_solver(A2, b2);

fprintf('LU solution:     [%.4f, %.4f, %.4f, %.4f]''\n', x2_lu);
fprintf('Decomposition accuracy ||L*U - A||: %.2e\n', norm(L2*U2 - A2));
fprintf('Solution accuracy ||Ax - b||: %.2e\n\n', norm(A2*x2_lu - b2));

% Compare with MATLAB's built-in LU
[L_matlab, U_matlab, P_matlab] = lu(A1);
fprintf('Note: MATLAB''s lu() uses pivoting (returns permutation matrix P)\n');
fprintf('Our LU: ||L*U - A|| = %.2e\n', ...
    norm(L1*U1 - A1));
fprintf('MATLAB: ||L*U - P*A|| = %.2e\n', ...
    norm(L_matlab*U_matlab - P_matlab*A1));

% Helper function: Forward Substitution for LU solver
function y = solve_lower_triangular(L, b)
    % Solves a lower triangular system Ly = b using forward substitution
    % Input:  L - n×n lower triangular matrix
    %         b - n×1 vector
    % Output: y - n×1 solution vector
    
    n = length(b);
    y = zeros(n, 1);
    
    % Start from the first equation
    y(1) = b(1) / L(1, 1);
    
    % Work forward from row 2 to n
    for i = 2:n
        sum_terms = 0;
        for j = 1:i-1
            sum_terms = sum_terms + L(i, j) * y(j);
        end
        y(i) = (b(i) - sum_terms) / L(i, i);
    end
end

function x = my_lu_solver(A, b)
    % Solves Ax = b using LU decomposition
    % Input:  A - n×n matrix
    %         b - n×1 vector
    % Output: x - n×1 solution vector
    
    % Step 1: Decompose A = LU
    [L, U] = my_lu_decompose(A);
    
    % Step 2: Solve Ly = b (forward substitution)
    y = solve_lower_triangular(L, b);
    
    % Step 3: Solve Ux = y (back substitution)
    x = solve_upper_triangular(U, y);
end