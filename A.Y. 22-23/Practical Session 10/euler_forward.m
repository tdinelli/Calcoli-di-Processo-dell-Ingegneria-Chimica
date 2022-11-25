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

function [t, y]=euler_forward(funz,range,y0,nint)

    h = diff(range)/nint; % Calculates the step size
    t(1)=range(1);      % initialize the first element of the
                        % output vector of the independent variable using
                        % the lower extreme of the interval
    y(1)=y0; % initialize the first element of the output
             % vector of the y using the initial value
    for i=1:nint
        t(1+i)=t(i)+h; % for each interval increments i+1 element of t by h
        y(1+i)=y(i)+funz(t(i),y(i))*h; % for each interval sets the i+1 
                                       % element of y by the derivative at 
                                       % t(i) multiplied by h (func(t,y)*h)
    end 
end
