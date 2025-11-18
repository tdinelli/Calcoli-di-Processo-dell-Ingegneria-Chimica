function integrale = trapezi(f, a, b, n_int)

    h = (b - a) / n_int;
    integrale = (f(a) + f(b)) / 2;

    for i = 1:n_int-1
        x_i  = a + i * h;
        integrale = integrale + f(x_i);
    end

    integrale = integrale * h;
end