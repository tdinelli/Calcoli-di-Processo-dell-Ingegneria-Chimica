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

clear, clc
stock=1000;          % starting value of the stocks 1000
stock_floor = stock; % Copy the same value in three differente variables
stock_ceil = stock;  % and after some calculations I will do different 
stock_round = stock; % types of rounding
 
% Loop for 10000 times perturbing the values of the stocks each cycle
% of a delta between +/-1 %
for i=1:1e4
    variation = (1 + (rand * 2 - 1) / 100); % rand return a random number between 0 and 1
    % In order to get a random variation of +/-1% multiply rand for 2 so I
    % will obtain a random number between 0 and 2, then I subtract 1 so the
    % number will be between -1 and 1 and finally I divide by 100 to obtain
    % a random number between -0.01 and 0.01
    
    stock = stock * variation;
    vectstock(i)=stock; % store the value inside a vector
    
    % same procedure and rounding using floor
    stock_floor = floor(stock_floor * variation * 100)/100;
    vectstock_floor(i)=stock_floor;
    
     % same procedure and rounding using two digits after the comma
    stock_round=round(stock_round*variation*100)/100;
    vectstock_round(i)=stock_round;

     % same procedure and rounding using ceil
    stock_ceil=ceil(stock_ceil*variation*100)/100;
    vectstock_ceil(i)=stock_ceil;
    
    % ceil e floor arrotondano all'intero successivo per eccesso e difetto.
    % moltiplicando per 100 l'argomento e dividendo per 100 il risultato
    % ottengo arrotondamenti alla seconda cifra decimale
    
    iter(i)=i;
end

figure(1)
hold on
title('Vancouver a nickel at a time!')
plot(iter,vectstock,'DisplayName','double', 'LineWidth', 2.5)
plot(iter, vectstock_round,'DisplayName','round', 'LineWidth', 2.5)
plot(iter, vectstock_floor,'DisplayName','floor', 'LineWidth', 2.5)
plot(iter, vectstock_ceil,'DisplayName','ceil', 'LineWidth', 2.5)
xlabel('time')
ylabel('Stock price [$]')
legend
