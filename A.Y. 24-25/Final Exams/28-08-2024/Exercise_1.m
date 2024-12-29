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
% Function that counts how many times each unique name appears in a list
% Input: Names - an array of names
% Output: ListOfNames - list of unique names
%         Numerosity - count of how many times each name appears
function [ListOfNames, Numerosity] = CountFrequency(Names)
    % Check if the input array has at least one element
    if length(Names) >= 1
        % Initialize ListOfNames with the first name from input
        ListOfNames = [Names(1)];

        % First loop: Build list of unique names
        % Go through each name in the input array
        for i = 1:length(Names)
            % If current name is not already in our list (ismember returns 0)
            if ismember(Names(i), ListOfNames) == 0
                % Add it to ListOfNames
                ListOfNames = [ListOfNames; Names(i)];
            end
        end

        % Create a vector of zeros to store counts, size matches unique names
        Numerosity = zeros(length(ListOfNames), 1);

        % Second loop: Count occurrences of each name
        % For each unique name in ListOfNames
        for i = 1:length(ListOfNames)
            % Compare with every name in original input
            for j = 1:length(Names)
                % If names match
                if ListOfNames(i) == Names(j)
                    % Increment the counter for this name
                    Numerosity(i) = Numerosity(i) + 1;
                end
            end
        end
    else
        % If input is empty, return empty list and zero
        ListOfNames = [];
        Numerosity = 0;
    end
end
