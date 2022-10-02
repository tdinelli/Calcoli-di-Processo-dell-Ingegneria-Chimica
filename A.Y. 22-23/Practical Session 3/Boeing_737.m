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

% Un Boeing 737 tocca la pista d'atterraggio ad una velocità v= 210 km/h.
% Vengono subito attivati gli inversori di spinta per deviare i gas di
% scarico dell'aereo nella stessa direzione del moto, ottenendo ...
% di conseguenza un'azione frenante. 
% Calcolare la velocità d'uscita dei gas di scarico (relativa) che 
% permette all'aereo di fermarsi in un tempo t=15 s. 

%% Data
clear, close, clc;

global Sout f A m0 rho v_in t_stop

v_in = 210 / 3.6; % m / s N.B. consistent unit of measurements
t_stop = 15; % s
m0 = 35000; % kg
Sout = 0.085; % m2
f = 0.97; % [-]
A = 25; % m2
rho = 1; % kg/m3

%% Numerical Solution (Metodo delle sostituzioni successive)

v_firstguess = 10; % First guess solution
epsi = 1.e-5;       % Tolerance
max_iter = 150;      % Avoid infinite number of loops
iter_number = 1;    % Iteration counter

formatSpec_v = '%.5f';
formatSpec_f = '%.4e'; 

v = EquationModified(v_firstguess);
error = abs(v_firstguess - v);

while abs(v_firstguess - v) > epsi && iter_number < max_iter
    
    v_old = v_firstguess;

    v_firstguess = v;
    v = EquationModified(v_firstguess);
    
    v_computed(iter_number) = v; % Save results into an additional variable
    vector_FG(iter_number) = v_firstguess; % Save results into an additional variable

    computed_error(iter_number) = abs(v_firstguess - v); % Save results into an additional variable

    % Print on the screen the evolution of the solution 
  
    disp([num2str(iter_number),')   v_FG = ', ...
        num2str(v_firstguess, formatSpec_v), '    f(v) = ', ... 
        num2str(v, formatSpec_v), '   error = ',...
        num2str(abs(v_firstguess - v), formatSpec_f)])

    iter_vector(iter_number) = iter_number; % Save results into an additional variable
    iter_number = iter_number + 1; % Increment iteration counter each cycle
end

disp('    ')
disp('Solution found:')
disp(['      velocity = ', num2str(v_computed(end)), ' m/s,  error = ',...
    num2str(computed_error(end))])
disp('    ')

subplot(2,1,1)
hold on
plot(iter_vector, computed_error,'r-o', 'LineWidth',2)
scatter(iter_vector(end), computed_error(end), 140,'green', 'filled','square')
xlabel('Iteration number', 'FontSize', 16)
ylabel('Computed error', 'FontSize', 16)
legend('Error Function', 'Convergence', 'FontSize', 18)

subplot(2,1,2)
hold on
plot(iter_vector, v_computed, 'LineWidth', 2.5, 'Color', 'blue')
scatter(iter_vector, vector_FG, 70, "red")
xlabel('Iteration number', 'FontSize', 16)
ylabel('Velocity [m/s]', 'FontSize', 16)
legend('Computed Velocity', 'First Guess', 'FontSize', 18)

%% MATLAB Numerical Solution

v_firstguess=1000;
options = optimset('Display','iter'); % show iterations
[x,fval,exitFlag] = fsolve(@EquationNotIntegrated, v_firstguess, options);

disp(['Solution with "fsolve"  x = ',num2str(x),' f(x) = ',num2str(fval)]);
disp(['ExitFlag of fsolve: ',num2str(exitFlag),...
    '   (if > 0 convergence reached!)']);

%% Functions

function EM = EquationModified(v_gas)

global Sout f A m0 rho v_in t_stop

alpha=2 * Sout * v_gas^2;
beta=0.5 * f * A;
gamma=m0;
delta=2 * rho * Sout * v_gas;

term_1 = (-delta / (rho * sqrt(alpha * beta))) * atan(v_in * sqrt(beta/alpha));

EM = (gamma / (2 * rho * Sout * t_stop)) * (1 - exp(term_1));
end

% This function is then solved with fsolve
function F=EquationNotIntegrated(v_gas)

global Sout f A m0 rho v_in t_stop

alpha = 2 * Sout * v_gas^2;
beta = 0.5 * f * A;
gamma = m0;
delta = 2 * rho * Sout * v_gas;

syms v t
f1 = 1 / (alpha + beta * v^2);
f2 = rho / (gamma - delta * t);

I1 = int(f1, v, v_in, 0);
I2 = int(f2, t, 0, t_stop);


F = (double(I1) + double(I2)) * 10^7;

end
