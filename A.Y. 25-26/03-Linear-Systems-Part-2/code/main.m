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

%% Exercise 1
% Define a system where scaling matters
A1 = [2, 100000; 1, 1];
b1 = [100000; 2];

fprintf('System Matrix A:\n');
disp(A1);
fprintf('Right-hand side b:\n');
disp(b1);

% Exact solution (for comparison)
x_exact = A1 \ b1;
fprintf('Exact solution: x = [%.6f, %.6f]^T\n\n', x_exact);

% Without pivoting (naive Gauss elimination)
fprintf('--- Without Pivoting ---\n');
A_temp = A1;
b_temp = b1;

% Manual elimination for demonstration
m21 = A_temp(2,1) / A_temp(1,1);
A_temp(2,:) = A_temp(2,:) - m21 * A_temp(1,:);
b_temp(2) = b_temp(2) - m21 * b_temp(1);
fprintf('Multiplier m21 = %.6f\n', m21);
fprintf('After elimination, row 2: [%.2e, %.2e | %.2e]\n', ...
        A_temp(2,1), A_temp(2,2), b_temp(2));
fprintf('Notice: Very small pivot leads to numerical issues!\n\n');

% With scaled partial pivoting
fprintf('--- With Scaled Partial Pivoting ---\n');
[A_scaled, b_scaled] = gauss_elimination_scaled_pivoting(A1, b1);
fprintf('Upper triangular form:\n');
disp([A_scaled, b_scaled]);

% Solve by back substitution
x_scaled = solve_upper_triangular(A_scaled, b_scaled);
fprintf('Solution: x = [%.6f, %.6f]^T\n', x_scaled);
fprintf('Error: ||x_exact - x_scaled|| = %.2e\n\n', norm(x_exact - x_scaled));

%% Exercise 2: 3x3 System from Lecture Slides
fprintf('========== EXAMPLE 2: 3x3 System ==========\n\n');

A2 = [2, 1, -1;
      -3, -1, 2;
      -2, 1, 2];
b2 = [8; -11; -3];

fprintf('System Matrix A:\n');
disp(A2);
fprintf('Right-hand side b:\n');
disp(b2);

% Apply scaled partial pivoting
[A_upper, b_upper] = gauss_elimination_scaled_pivoting(A2, b2);

fprintf('Upper triangular form:\n');
disp([A_upper, b_upper]);

% Solve the system
x2 = solve_upper_triangular(A_upper, b_upper);
fprintf('Solution: x = [%.6f, %.6f, %.6f]^T\n', x2);

% Verify solution
residual = A2 * x2 - b2;
fprintf('Residual ||Ax - b|| = %.2e\n\n', norm(residual));

%% Exercise 3: Ill-Conditioned System
% Hilbert matrix (notoriously ill-conditioned)
n = 4;
A3 = hilb(n);
b3 = sum(A3, 2); % Solution should be x = [1, 1, 1, 1]^T

fprintf('Hilbert Matrix (4x4) - highly ill-conditioned:\n');
disp(A3);
fprintf('Condition number: %.2e\n\n', cond(A3));

% Solve with scaled partial pivoting
[A_upper3, b_upper3] = gauss_elimination_scaled_pivoting(A3, b3);
x3 = solve_upper_triangular(A_upper3, b_upper3);

fprintf('Computed solution:\n');
disp(x3');
fprintf('Expected solution: [1, 1, 1, 1]^T\n');
fprintf('Error: ||x - [1,1,1,1]^T|| = %.2e\n\n', norm(x3 - ones(n,1)));

%% Exercise 4
% Material balance for a multi-component system
% Component balances: A, B, C in three unit operations
% Variables: x1, x2, x3 (flow rates in kmol/h)

fprintf('Material Balance Equations:\n');
fprintf('Unit 1:  2*x1 + 3*x2 + x3 = 100  (Component A)\n');
fprintf('Unit 2:  x1 + 2*x2 + 3*x3 = 150  (Component B)\n');
fprintf('Unit 3:  3*x1 + x2 + 2*x3 = 120  (Component C)\n\n');

A4 = [2, 3, 1;
      1, 2, 3;
      3, 1, 2];
b4 = [100; 150; 120];

% Solve
[A_upper4, b_upper4] = gauss_elimination_scaled_pivoting(A4, b4);
x4 = solve_upper_triangular(A_upper4, b_upper4);

fprintf('Flow rates (kmol/h):\n');
fprintf('  x1 = %.2f kmol/h\n', x4(1));
fprintf('  x2 = %.2f kmol/h\n', x4(2));
fprintf('  x3 = %.2f kmol/h\n', x4(3));

% Verify material balance
fprintf('\nVerification:\n');
fprintf('  Component A: %.2f = %.2f\n', A4(1,:)*x4, b4(1));
fprintf('  Component B: %.2f = %.2f\n', A4(2,:)*x4, b4(2));
fprintf('  Component C: %.2f = %.2f\n', A4(3,:)*x4, b4(3));