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

function [t ,y]=euler_backward(funz,intervallo, y0,ninterval)
    t0=intervallo(1);      % salvo il tempo iniziale di integrazione
    tend=intervallo(2);    % salvo il tempo finale di integrazione
    h=(tend-t0)/ninterval; % divido l'intervallo di integrazione per il 
                           % numero di intervalli per determinare il passo
    t=t0; % inizializzo quello che diventerà il vettore tempo
    y=y0; % inizializzo quello che diventerà il vettore y
    for i=1:ninterval
        t(i+1)=t(i)+h; % aggiungo elemento vettore t
        % definisco la funzione da azzerare
        funz_to_0 = @(ypiu1) ypiu1-(y(i)+h*funz(t(i+1),ypiu1));

        y(i+1)=fzero(funz_to_0,y(i)); % calcolo y successiva
    end
end