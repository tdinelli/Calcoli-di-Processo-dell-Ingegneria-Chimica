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

function [T, fval, exitFlag] = Tbubble(P, speciesname, comp, FG, solver)

% The function takes as arguments the Pressure, an array with the name of
% the species and an array with their molar fractions and returns the T
% bubble, and a first guess for the bubble temperature

options = optimset('Display','iter','PlotFcns',...
    {@optimplotx,@optimplotfval});%,'TolFun',1e-10);

    function sum = fbubble(T)
        % The nested function is a wrapper that uses the composition 
        % of the mixture to write the function that,once zeroed, 
        % provides the T bubble  
        % NOTE THAT ALL THE VARIABLES AVAILABLE IN THE FUNCTION Tbubble 
        % ARE ALSO AVAILABLE IN THE FUNCTIONS NESTED WITHIN IT!!!!      
        sum=0.;
        [nname mname] = size(speciesname);
        for i = 1:nname  % this for cycle calculates and add to sum each
                         % term of the summatory
            sum = sum + PVap4Comp(T,speciesname(i,:)) / P * comp(i);
         % by calling the function Pvap that takes as input the T 
         % and speciesname
        end

        sum = sum - 1.;
    end 
   
    if solver=='solve'
        [T, fval, exitFlag] = fsolve(@fbubble, FG, options);
    elseif solver=='fzero'
        [T, fval, exitFlag] = fzero(@fbubble, FG, options);
    end
    %else
        %error('The available solvers are fsolve | fzero')
end