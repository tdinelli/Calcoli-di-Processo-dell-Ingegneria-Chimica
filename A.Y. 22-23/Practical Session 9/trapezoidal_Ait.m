function integral8=trapezoidal_Ait(f,a,b,n)

if mod(n,8) == 0
else
    % check if n is a multiple of 8 (we want 2 to be the minimum)
    % and, if necessary, djust the value accordingly
    n = (floor(n/8)+1)*8;
    disp(['n must be a multiple of 8, it has been increased to ' num2str(n)])
end

h = (b-a)/n; % calculate the width of the interval
integral2 = (f(a)+f(b))/2; % sum the f(x) at the two extremes
                           % (weight = 0.5)for the tree different integrals
integral4 = integral2;
integral8 = integral2;

for i=1:n-1
    funct = f(a+i*h);
    if round(i/4) == i/4 % depending on the index the value 
                         % of the f(x) is summed or not
        integral2 = integral2+funct;
    end
    if  floor(i/2) == i/2
        integral4 = integral4 + funct;
    end
    integral8 = integral8 + funct;
end

integral2 = integral2 * h * 4; % multiply by the width (note that the 
                               % width depends on the integral: n, 2n, 4n
integral4 = integral4 * h * 2;
integral8 = integral8 * h;


    
integral8 = integral8 - ((integral8-integral4)^2)/(integral8+integral2-2*integral4);
end

   
    

