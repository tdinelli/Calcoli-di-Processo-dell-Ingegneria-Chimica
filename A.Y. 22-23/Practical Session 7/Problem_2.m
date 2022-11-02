

clear, close, clc;

%% Data

Tinf = 273.16; % K
Tsup = 647.13; % K

T_vect = Tinf:0.001:Tsup;
P0vap = PVapH2O(T_vect);

options = optimset('Display','iter','PlotFcns', ...
    {@optimplotx,@optimplotfval}, 'TolX', 1e-20, ...
    'MaxFunEvals', 2e3, 'MaxIter', 2e3); % show iterations

%% Solve the problem

[sol_fsolve, fval_fsolve, exitFlag_fsolve] = fsolve(@target,...
                                                    310, options);

%% Plots

figure(2)
hold on
plot(T_vect, P0vap, 'LineWidth', 2.5)
scatter(sol_fsolve, fval_fsolve, 140, 'MarkerFaceColor', 'red')
ylabel('P^{0}_{vap} [Pa]', 'FontSize', 18)
xlabel('T [K]', 'FontSize', 18)

%% Functions

function f = target(T)
    f = PVapH2O(T) - 5.0662e4;
end