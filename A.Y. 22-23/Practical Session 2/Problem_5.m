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

% inizializzo le variabili totale (capitale_iniziale e anno 0)
totale=10000;
year=0;

% fino a che totale è minore di 30000
while totale<30000
    % aggiungo 1 anno
    year=year+1;
    % aggiorno il valore del totale aggiungendo l'interesse
    totale=totale*1.0351;
    % e salvo in due vettori alla posizione i-esima con i pari all'anno
    x(year)=year; % il numero dell'anno
    y(year)=totale; % e il corrispondente capitale maturato
end

%% Plots

plot(x,y)