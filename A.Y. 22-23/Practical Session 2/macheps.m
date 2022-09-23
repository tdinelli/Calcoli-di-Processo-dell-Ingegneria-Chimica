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

clear, clc; 

v=0:.1:10; % initialize a vector n going from 0 to 1 with 0.1 spacing factor

for i=1:length(v) % for cycle on the all elements of v
    vecteps(i)=macheps_ese2(v(i)); % assigning to v the value of the function 
    vectMATLABeps(i)=eps(v(i)); % let's also use the built-in MATLAB function to compute the macheps
    
end

figure(1)
hold on
plot(v, vecteps, 'Color', 'green', 'LineWidth', 3);
plot(v, vectMATLABeps, 'Color', 'red', 'LineStyle',':', 'LineWidth', 3)

%% Functions definitions

function epsilon=macheps_ese2(n)
    % This function compute the macheps of a number n 
    epsilon = 1; % Initialize epsilon to 1
    while n+epsilon/2 > n % Iterate as long as the difference between n and n + epsilon / 2 > 0
    
        epsilon=epsilon/2; % every cycle the value of epsilon is halved
    end
    % At the end of the cycle I have found the smallest value causing a non
    % zero difference between n and n + epsilon / 2

    epsilon=(n+epsilon)-n;
    
    % At this point the effective difference between n and its incremented
    % value is computer, returning the distance between two consecutive 
    % numbers inside the floating point numbers that a computer is able to 
    % represent.

end
