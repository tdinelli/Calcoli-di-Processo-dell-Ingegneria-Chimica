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
function [xmm, ymm] = MobileAverage(x, y, nelements)
%MOBILEAVERAGE Calculates the moving average of a dataset
%   This function computes the moving average of a dataset using a specified
%   window size. It also creates a plot comparing the original data with the
%   moving average.
%
% Inputs:
%   x         - Vector containing independent variable values
%   y         - Vector containing dependent variable values
%   nelements - Number of elements to use in the moving average window
%
% Outputs:
%   xmm       - Vector of x values corresponding to moving average points
%   ymm       - Vector of moving average values
%
% Example:
%   x = 1:100;
%   y = sin(x) + randn(1,100)*0.1;
%   [xmm, ymm] = MobileAverage(x, y, 5);
%
% Note:
%   The first moving average point corresponds to the x-value at position
%   nelements in the input vector. The function also creates a plot comparing
%   the original data with the moving average.

    % Get lengths of input vectors
    lx = length(x);
    ly = length(y);
    
    % Check if input vectors have the same length
    if lx == ly
        % Initialize output vectors
        xmm = zeros(1, lx-nelements+1);
        ymm = zeros(1, lx-nelements+1);
        
        % Calculate moving average
        for i = nelements:lx
            % Store x value corresponding to current window
            xmm(i-nelements+1) = x(i);
            
            % Extract window of y values for current calculation
            ytemp = y((i-nelements+1):i);
            
            % Calculate average for current window
            ymm(i-nelements+1) = sum(ytemp)/nelements;
        end
        
        % Create plot comparing original data with moving average
        plot(x, y, xmm, ymm);
        legend('Input Data', 'Moving Average');
        grid on;
        xlabel('X');
        ylabel('Y');
        title(['Moving Average with Window Size = ' num2str(nelements)]);
        
    else
        % Error handling for mismatched vector lengths
        warning('Error: Input vectors must have the same length');
        xmm = [];
        ymm = [];
    end
end