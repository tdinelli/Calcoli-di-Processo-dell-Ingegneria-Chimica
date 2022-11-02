function P = PVapH2O(T)

    A =  7.3649E+01;
    B = -7.2582E+03;
    C = -7.3037E+00;
    D =  4.1653E-06;
    E =  2.0000E+00;

    P = exp(A + B./T + C .* log(T) + D * T.^E);
end