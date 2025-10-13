%-------------------------------------------------------------------------%
%   __  __    _  _____ _        _    ____    _  _      ____    _ ____     %
%  |  \/  |  / \|_   _| |      / \  | __ )  | || |    / ___|__| |  _ \    %
%  | |\/| | / _ \ | | | |     / _ \ |  _ \  | || |_  | |   / _` | |_) |   %
%  | |  | |/ ___ \| | | |___ / ___ \| |_) | |__   _| | |__| (_| |  __/    %
%  |_|  |_/_/   \_\_| |_____/_/   \_\____/     |_|    \____\__,_|_|       %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   Author: Marco Mehl      <marco.mehl@polimi.it>                        %
%           Timoteo Dinelli <timoteo.dinelli@polimi.it>                   %
%                                                                         %
%   CRECK Modeling Group <http://creckmodeling.polimi.it>                 %
%   Department of Chemistry, Materials and Chemical Engineering           %
%   Politecnico di Milano                                                 %
%   P.zza Leonardo da Vinci 32, 20133 Milano                              %
%                                                                         %
% ----------------------------------------------------------------------- %
clear variables  % Removes all variables from workspace
clc        % Clears command window

% Test the function
a = 10;
b = 30;
primes = find_primes(a, b);
fprintf('Prime numbers between %d and %d: %s\n', a, b, mat2str(primes));

function primes = find_primes(a, b)
    primes = [];
    
    for num = a:b
        if is_prime(num)
            primes = [primes, num];
        end
    end
end

function result = is_prime(n)
    % Check if n is prime
    if n < 2
        result = false;
        return;
    end
    
    if n == 2
        result = true;
        return;
    end
    
    if mod(n, 2) == 0
        result = false;
        return;
    end
    
    % Check odd divisors up to sqrt(n)
    for i = 3:2:sqrt(n)
        if mod(n, i) == 0
            result = false;
            return;
        end
    end
    
    result = true;
end