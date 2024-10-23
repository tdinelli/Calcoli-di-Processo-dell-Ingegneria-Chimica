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

clear, close, clc;
%% Data
t = 1; % s
T = 450:0.5:650;
b = [0.5 0.5 0 0]';

%% Constan kinetic

k = [0.2 0.1 0.2 0.3];

A = [1+t*k(1)+t*k(4) 0               0 0;
    -k(1)            1+t*k(2)+t*k(3) 0 0;
    0                -t*k(2)         1 0;
    -t*k(4)         -t*k(3)          0 1];

opts.LT = true;
x = linsolve(A, b, opts);

disp(['Solution is: ', num2str(x')])

%% Arrhenius with temperature dependence
% Computing the kinetic constant
for i = 1:length(T)
    k(1,i) = 1e8*exp(-20000/1.987/T(i)); 
    k(2,i) = 1e6*exp(-15000/1.987/T(i));
    k(3,i) = 1e11*exp(-27000/1.987/T(i));
    k(4,i) = 1e9*exp(-23000/1.987/T(i));
end

% Writing the system of equations
for j=1:length(T)
    % Eq 1
    A(1,1,j) = 1 + t * k(1,j) + t * k(4,j);
    A(1,2,j) = 0;
    A(1,3,j) = 0;
    A(1,4,j) = 0;

    % Eq 2
    A(2,1,j) = -t * k(1,j);
    A(2,2,j) = 1+t * k(1,j) + t * k(3,j);
    A(2,3,j) = 0;
    A(2,4,j) = 0;

    % Eq 3
    A(3,1,j) = 0;
    A(3,2,j) = -t * k(2,j);
    A(3,3,j) = 1;
    A(3,4,j) = 0;

    % Eq 4
    A(4,1,j) = -t * k(4,j);
    A(4,2,j) = -t * k(3,j);
    A(4,3,j) = 0;
    A(4,4,j) = 1;
end

% Solving n-systems of equations
for i = 1:length(T)
    x(:,i) = A(:,:,i) \ b;
    % x(:,i) = linsolve(A(:,:,i),b);
end

%% Plot results
hold on
plot(T, x(1, :), 'LineWidth',2,'Color','red')
plot(T, x(2, :), 'LineWidth',2,'Color','black')
plot(T, x(3, :), 'LineWidth',2,'Color','blue')
plot(T, x(4, :), 'LineWidth',2,'Color','green')
xlabel('T [K]', 'FontSize', 18)
ylabel('Concentration', 'FontSize', 18)
legend('CA','CB','CC','CD','FontSize',18)
