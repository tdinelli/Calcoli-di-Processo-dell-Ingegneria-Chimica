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
%       Function to perform the upper triangluarization of a matrix       %
%                                                                         %
% ----------------------------------------------------------------------- %

function [At, bt]=triangularize_U(A,b)

    [n_rows, n_cols]=size(A); % Get the size of A

    W = [A b]; % Pair the Matrix A and the vector b to geneate the Working matrix

    for i=1:n_rows-1     % For all the rows i but the last one
        for k=i+1:n_rows % and all the rows k below i
            coeff= W(k,i) / W(i,i);   % Compute the coefficient I will use 
                                      % to multiply the row i so that the 
                                      % element below the present pivot 
                                      % can be set to zero through a 
                                      % linear combination of the rows i and j

            % At this point I can use a for cycle to operate on all the 
            % elements of the row k (Alternative 1)

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Alternative 1
            %        for n=i:n_rows+1
            %             W(k,n) = W(k,n)- coeff*W(i,n);
            %        end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Alternative 1

            % Or take advantage of the Matlab construct : which indicates all the
            % elements in a line or a column (remember dot notation)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Alternative 2
            W(k,:) = W(k,:) - coeff * W(i,:);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    Alternative 2

            % At this point the element of the row i below the pivor is zero and the
            % programs move on to the next row by skipping at the beginning of this for
            % block
        end
    end

    % The last instructions copy on the original A and b the new values after
    % the triangulation process using the : construct that indicates all the
    % elements or, a range (e.g. 1:n_rows)

    At = W(:, 1:n_rows);
    bt = W(:, n_rows+1);

end
