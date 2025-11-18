clear, close, clc

A = 3.3375e4;
B = 2.5864e4;
C = 9.3280e2;
D = 1.0880e4;
E = 4.2370e2;

Cp = @(T) A + B * (C ./ T ./ sinh(C ./ T)).^2 + ...
              D * (E ./ T ./ cosh(E ./ T)).^2;

Tmin = 230 + 273.15;
Tmax = 480 + 273.15;

n_steps = [0.1, 0.01, 0.001, 0.0001, ...
    0.00001];

for i = 1:length(n_steps)
    T_vettore = Tmin:n_steps(i):Tmax;
    fprintf("N intervalli %.1f\n", length(T_vettore))
    Cp_vettore = Cp(T_vettore);
    
    tic
    I_trapz = trapz(T_vettore, Cp_vettore);
    toc
    fprintf("Trapz = %.10f\n", I_trapz)
    I_integral = integral(Cp, Tmin, Tmax);
    fprintf("Integral = %.10f\n", I_integral)
    fprintf("Abs error: %.7f\n\n", abs(I_trapz - I_integral))
end




