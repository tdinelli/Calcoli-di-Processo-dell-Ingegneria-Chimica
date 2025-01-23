%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl <marco.mehl@polimi.it>                             %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%   CRECK Modeling Group <http://creckmodeling.chem.polimi.it>            %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Initial guess for variables [x y z lambda1 lambda2]
x0 = [1; 1; 0; 1; 1];

% Test the KKT (Karush-Kuhn-Tucker) system function
F_test = kkt_system(x0);
x_test = F_test(1);
y_test = F_test(2);
z_test = F_test(3);
lambda1_test = F_test(4);
lambda2_test = F_test(5);

% Solve the nonlinear system of equations
options = optimoptions( ...
    "fsolve", ...
    "MaxFunctionEvaluations", 10000, ...
    "MaxIterations", 10000);
[sol, fval, exitflag] = fsolve(@kkt_system, x0, options);

% Extract optimal solution
x_opt = sol(1);
y_opt = sol(2);
z_opt = sol(3);
lambda1_opt = sol(4);
lambda2_opt = sol(5);

% Print results
fprintf('Optimal Solution:\n')
fprintf('x = %.4f\n', x_opt)
fprintf('y = %.4f\n', y_opt)
fprintf('z = %.4f\n', z_opt)
fprintf('lambda1 = %.4f\n', lambda1_opt)
fprintf('lambda2 = %.4f\n', lambda2_opt)

% KKT system function to solve constrained optimization problem
function F = kkt_system(vars)
    % Unpack variables
    x = vars(1);
    y = vars(2);
    z = vars(3);
    lambda1 = vars(4);
    lambda2 = vars(5);

    % Initialize residual vector
    F = zeros(5,1);

    % First-order optimality conditions (partial derivatives)
    F(1) = 2*x - lambda1 - lambda2*y;        % ∂L/∂x = 0
    F(2) = 4*y - lambda1 - lambda2*(x + z);  % ∂L/∂y = 0
    F(3) = 6*z - lambda1 - lambda2*y;        % ∂L/∂z = 0

    % Constraint equations
    F(4) = x + y + z - 2;   % First constraint: x + y + z = 2
    F(5) = x*y + y*z - 1;   % Second constraint: x*y + y*z = 1
end
