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
clear, close, clc

% Sum from 1 to 1000000 (forward)
sum_forward_single = single(0);
sum_forward_double = 0;
for n = 1:1000000
    sum_forward_single = sum_forward_single + single(1/n);
    sum_forward_double = sum_forward_double + 1/n;
end

% Sum from 1000000 to 1 (backward)
sum_backward_single = single(0);
sum_backward_double = 0;
for n = 1000000:-1:1
    sum_backward_single = sum_backward_single + single(1/n);
    sum_backward_double = sum_backward_double + 1/n;
end

% Display results
fprintf('Forward sum (single):  %.10f\n', sum_forward_single);
fprintf('Forward sum (double):  %.15f\n', sum_forward_double);
fprintf('Backward sum (single): %.10f\n', sum_backward_single);
fprintf('Backward sum (double): %.15f\n', sum_backward_double);

fprintf('\nDifferences:\n');
fprintf('Single precision:  %.10e\n', ...
    abs(sum_forward_single - sum_backward_single));
fprintf('Double precision:  %.15e\n', ...
    abs(sum_forward_double - sum_backward_double));