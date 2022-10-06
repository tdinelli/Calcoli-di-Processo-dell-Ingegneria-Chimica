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
%                                                                         %
%       Function to perform the solve the system                          %
%       composed by the triangularized matrix                             %
%                                                                         %
% ----------------------------------------------------------------------- %

function b=solveUTr(A,b)

[nA,mA]=size(A); % Detect the size of A

for i = nA : -1: 1  % Starting from the last line and moving up 
   for k = i+1 : nA   
      b(i) = b(i) - A(i,k) * b(k); % The value of b(i) is updated using all the value of x already calculated and already stored in the b(i+1:nA)portion of b  
   end
   b(i) = b(i) / A(i,i); % The value of the i-th unknown is calculated and stored in b(i)
end
end