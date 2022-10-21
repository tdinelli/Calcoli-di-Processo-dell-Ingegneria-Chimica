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

function [A, b] = triangularizeU_PPb(A, b)

[rA, cA] = size(A); % Get the size of the input matrix
W = [A b]; % Create the working matrix

for i = 1:rA-1 %for all the rows i but the last one
        switch_lines = false;
        for j = i+1:rA
            if abs(W(j,i)/max(abs(W(j, 1:rA))))>abs(W(i,i)/max(abs(W(i,1:rA))))
                switch_lines = true;
                temp = W(i,:);
                W(i,:) = W(j,:);
                W(j,:) = temp;
            end
        end
        for k = i+1:rA
            coeff = W(k,i) / W(i,i);
            W(k,:) = W(k,:) - coeff * W(i,:);
        end
end

A = W(:, 1:rA);
b = W(:, rA+1);

end