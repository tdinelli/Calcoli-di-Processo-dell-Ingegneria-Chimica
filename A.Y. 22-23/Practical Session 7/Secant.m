function [xn, iter] = Secant(funz,x0,x1,eps)

maxIter = 120;
iter = 0;

xmin1 = x0;  % avoidable if I just called xmin1 the x0 in the initial 
             % declaration
xn = x1;     % avoidable if I just called xn the x1 in the initial 
             % declaration

fmin1 = funz(xmin1);
fn = funz(xn);

while (abs(xn-xmin1))>eps && iter<=maxIter

    xplus1 = xn-fn/(fn-fmin1)*(xn-xmin1);
    
    xmin1 = xn;
    fmin1 = fn;
    
    xn = xplus1;
    fn = funz(xn);
    
    iter = iter+1;
end
end