%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
% Clear the workspace and command window for a fresh start
clear all  % Removes all variables from workspace
close all  % Closes all figure windows
clc        % Clears command window

% Example input matrix
A = [1 2 3; 4 5 6; 7 8 9];

% Get size of matrix
n = size(A,1);

% Calculate sum of all elements in A
sumA = sum(A(:));

% Create matrix B
B = zeros(n); % Initialize with zeros for lower triangular part
B(1:n+1:end) = diag(A); % Set diagonal elements from A
B = triu(B); % Keep upper triangular part (including diagonal)
B(1:n+1:end) = diag(A); % Set diagonal again (in case it was affected by triu)
B(triu(true(n),1)) = sumA; % Set all elements above diagonal to sum

% Display results
disp('Matrix A:')
disp(A)
disp('Matrix B:')
disp(B)
