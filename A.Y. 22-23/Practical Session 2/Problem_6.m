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

clc, clear

number = 95735585; % 95735588972543452378543353653635

babilonianSquareRoot = ComputeSquareRoot(number);
matlabSquareRoot = sqrt(number);

disp(['Babilonian: ', num2str(babilonianSquareRoot)])
disp(['Matlab: ', num2str(matlabSquareRoot)])

function SquareRoot = ComputeSquareRoot(S)

% Function that compute the square root of a number with the babylonian
% method
% y it is the variable that ends into SquareRoot the output of the function
% S is the value for which I'd like to compute the square root

iter = 0;
x0 = S; % x0 first guess

y = 0.5*(x0+S/x0); % First estimate of the square root

% As far as the difference between the first guess x0 and the estimate of
% the root obtained using the formula is higher than the tolerance (1e-5).
% The value x0 (first guess) is constantly updated with the estimate of the
% root obtained.

while abs(x0-y)>1e-5 && iter<50 

    % "iter" variable is needed to avoid infinite number of loops so double
    % conditions on the while statements
    
    x0 = y; 
    y = 0.5*(x0+S/x0);
    iter = iter+1;
end

disp(['Number of iteration to reach convergence: ', num2str(iter)])
SquareRoot = y;
end
