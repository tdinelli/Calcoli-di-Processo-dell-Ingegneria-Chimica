function dfdx = forward_diff(f, x)
    h = 1e-7;
    dfdx = (f(x + h) - f(x))/h;
end