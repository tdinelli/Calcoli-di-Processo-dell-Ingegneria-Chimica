function P=PVap4Comp(T,comp)

    % This function takes the T and the name of the species 
    % (3 charachters) and returns the vapor pressure in atm
    % Data are from different sources and, a priori, each component can be 
    % treated using specific equations

    if comp=='H2O'
        A =  7.3649E+01;
        B = -7.2582E+03;
        C = -7.3037E+00;
        D =  4.1653E-06;
        E =  2.0000E+00;
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC6'
        A = 10.465E+01;
        B = -6.9955E+03;
        C = -1.2702E+01;
        D =  1.2381E-05;
        E =  2.0000E+00;
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC7'      
        A =  8.7829E+01;
        B = -6.9964E+03;
        C = -9.8802E+00;
        D =  7.2099E-06;
        E =  2.0000E+00;   
        P = exp(A + B/T + C*log(T) + D*T^E)/101325.;
    elseif comp=='NC3'
        A=21.447;
        B=-1462.7;
        C=-5.261;
        D=3.2820E-11;
        E=3.7349E-06;
        P=10^(A+B/T+C*log10(T)+D*T+E*T^2)/760;   
    elseif comp=='IC4'
        A=31.254;	
        B=-1953.2;	
        C=-8.806;
        D=8.9246E-11;
        E=5.7501E-06;
        P=10^(A+B/T+C*log10(T)+D*T+E*T^2)/760;
    elseif comp=='NC4'
        A=27.044;	
        B=-1904.9;
        C=-7.1805;
        D=-6.6845E-11;
        E=4.2190E-06;
        P=10^(A+B/T+C*log10(T)+D*T+E*T^2)/760;
    elseif comp=='NC5'
        A=33.324;
        B=-2422.7;
        C=-9.2354;
        D=9.0199E-11;
        E=4.1050E-06;
        P=10^(A+B/T+C*log10(T)+D*T+E*T^2)/760;  
    end
end
