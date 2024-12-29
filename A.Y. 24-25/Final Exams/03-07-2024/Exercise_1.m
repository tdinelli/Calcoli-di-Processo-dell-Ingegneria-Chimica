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
% Solution vector order = [Vegetables Bread Dessert Fish]
global cal prot carb fat cal_tot prot_tot carb_tot fat_tot

% Define nutritional content per gram for each food
cal = [0.37 4.08 3.05 4.51];    % Calories per gram [cal/g]
prot = [0.04 0.09 0.006 0.067]; % Protein per gram [prot/g]
carb = [0.05 0.7 0.58 0.74];    % Carbohydrates per gram [carb/g]
fat = [0.001 0.08 0.002 0.14];  % Fat per gram [fat/g]

% Define daily nutritional targets
cal_tot = 476;    % Total calories target
prot_tot = 10;    % Total protein target
carb_tot = 80;    % Total carbohydrates target
fat_tot = 10;     % Total fat target

% Test block
cibo_test = [50 100 20 90];  % Test meal in grams [Veg Bread Dessert Fish]
sol_test = pastoCompleto(cibo_test);

% Solve for optimal meal portions
x0 = [50 100 20 90];                      % Initial guess for food amounts
grammiCibo = fsolve(@pastoCompleto, x0);  % Find optimal food amounts

%% Functions definition
% Function to calculate nutritional balance
function eq = pastoCompleto(x)
    global cal prot carb fat cal_tot prot_tot carb_tot fat_tot

    % Assign meaningful variable names to input vector
    V = x(1);      % Vegetables (grams)
    Pan = x(2);    % Bread (grams)
    D = x(3);      % Dessert (grams)
    Pes = x(4);    % Fish (grams)

    % System of equations for nutritional balance
    % Each equation: actual nutrients - target nutrients = 0
    eq(1) = cal(1)*V + cal(2)*Pan + cal(3)*D + cal(4)*Pes - cal_tot;    % Calories balance
    eq(2) = prot(1)*V + prot(2)*Pan + prot(3)*D + prot(4)*Pes - prot_tot;    % Protein balance
    eq(3) = carb(1)*V + carb(2)*Pan + carb(3)*D + carb(4)*Pes - carb_tot;    % Carbs balance
    eq(4) = fat(1)*V + fat(2)*Pan + fat(3)*D + fat(4)*Pes - fat_tot;    % Fat balance
end
