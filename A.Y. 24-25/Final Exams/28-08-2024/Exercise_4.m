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
% Find first solution point (maximum X, minimum Y)
[Sol1] = fsolve(@sysAlg, [10 5]); % Solve system starting from point [10 5]
Xmax = Sol1(1);                   % Store maximum X value
Ymin = Sol1(2);                   % Store minimum Y value

% Find second solution point (minimum X, maximum Y)
[Sol2] = fsolve(@sysAlg, [5 10]); % Solve system starting from point [5 10]
Xmin = Sol2(1);                   % Store minimum X value
Ymax = Sol2(2);                   % Store maximum Y value

% Store the ranges of X and Y values
Xrange = [Xmin Xmax];
Yrange = [Ymin Ymax];

%% Plots
% Create and plot the profit function
x = 0:0.1:15;                       % Create x-axis points from 0 to 15
prof = profit(x);                   % Calculate profit for each x value
plot(x, prof);                      % Plot the profit curve

%% Functions definition
% Test function for the algebraic system
function y = sysAlg(x)
    xs = x(1);    % First variable (possibly supply quantity)
    xw = x(2);    % Second variable (possibly demand quantity)

    % First equation: total quantity constraint
    y(1) = xw + xs - 15;    % Sum must equal 15

    % Calculate prices using given formulas
    Pw = 0.36*(xw)^0.5;     % Price function for w
    Ps = 0.77*log(1 + 0.19*xs);  % Price function for s

    % Second equation: price constraint
    y(2) = 15*0.11 - Pw - Ps;    % Total price constraint
end

% Function to calculate total profit
function y = profit(xs)
    xw = 15 - xs;    % Calculate xw based on xs (using constraint)

    % Calculate prices using same formulas
    Pw = 0.36*(xw).^0.5;
    Ps = 0.77*log(1 + 0.19*xs);

    % Total profit is sum of both prices
    y = Pw + Ps;
end
