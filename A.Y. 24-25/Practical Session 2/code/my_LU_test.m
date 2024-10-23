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

clear, clc, close;

rng(1) % Set the seed of the random generator
       % in order to obtain always the same 
       % random generated matrix
A = rand(3);

[L,U] = LU_decomposition(A); % Apply the function for the LU decomposition

Astar = L * U; % Test the LU factorization

disp('Error due to the factorization: ')
disp(A - Astar)

%% Use LU decomposition
A = [1 0 0 -1 1 0;...
    -1 1 -1 0 0 0;...
     0 0 1 0 -1 1;...
     1 0 -3 0 0 0; ...
     0 2 3 0 0 0;...
     0 0 0 4 0 0];

b = [0 0 0 -100 200 -100]';

[L, U] = LU_decomposition(A);

for i=1:1000 % Solve 1000 times the system of equations factorizing the 
             % matrix just one time updating the vector containing the
             % vector of the known elements.
    bnew = rand(6,1);
    Bnew(i,:) = bnew;
    y = linsolve(L,bnew);
    x(i,:) = linsolve(U, y);
end

E1 = Bnew(:,4);
E2 = Bnew(:,5);
I3 = x(:,3);

[xq, yq] = meshgrid(-1:.002:1, -1:.002:1);
vq = griddata(E1, E2, I3, xq, yq);

mesh(xq, yq, vq)
hold on
plot3(E1,E2,I3, 'ro')
