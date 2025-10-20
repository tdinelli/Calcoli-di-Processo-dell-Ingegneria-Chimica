%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%          Author: Marco Mehl <marco.mehl@polimi.it>                      %
%                  Timoteo Dinelli <timoteo.dinelli@polimi.it>            %
%          CRECK Modeling Lab <www.creckmodeling.polimi.it>               %
%          Department of Chemistry, Materials and Chemical Engineering    %
%          Politecnico di Milano                                          %
%          P.zza Leonardo da Vinci 32, 20133 Milano                       %
%                                                                         %
% ----------------------------------------------------------------------- %
function [A, b] = gauss_elimination_scaled_pivoting(A, b)
    [rA, cA] = size(A); % Get the size of the input matrix
    W = [A b]; % Create the working matrix
    
    % Compute scaling factors ONCE at the beginning
    s = max(abs(W(:, 1:rA)), [], 2);
    
    for i = 1 : rA-1 % for all the rows i but the last one
        
        % Find the row with maximum scaled pivot
        [~, p] = max(abs(W(i:rA, i)) ./ s(i:rA));
        p = p + i - 1; % Adjust index to global row number
        
        % Swap rows if needed
        if p ~= i
            % Swap rows in working matrix
            temp = W(i,:);
            W(i,:) = W(p,:);
            W(p,:) = temp;
            
            % Swap scaling factors
            temp_s = s(i);
            s(i) = s(p);
            s(p) = temp_s;
        end
        
        % Perform elimination
        for k = i+1 : rA
            coeff = W(k,i) / W(i,i);
            W(k,:) = W(k,:) - coeff * W(i,:);
        end
    end
    
    A = W(:, 1:rA);
    b = W(:, rA+1);
end