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
function v = FindOccurrence(v, f)
    % Function that counts how many times each element in vector v appears
    % in vector f
    % Input:  v - vector to check
    %         f - vector to search in
    % Output: v - modified input vector with counts
    
    % Loop through each element in vector v
    for i = 1:length(v)
        % Initialize counter for current element
        counter = 0;
        
        % Loop through each element in vector f
        for j = 1:length(f)
            % If element from v matches element from f
            if v(i) == f(j)
                % Increment counter
                counter = counter + 1;
            end
        end
        
        % Replace original value with count of occurrences
        v(i) = counter;
    end
end