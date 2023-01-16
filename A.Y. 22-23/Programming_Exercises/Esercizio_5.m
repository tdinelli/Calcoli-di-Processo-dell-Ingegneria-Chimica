clear, close, clc

v = [5 4 6 8 11];

for i = 1:length(v)
    for j = 1:length(v)-1
        if v(i) <= v(j)
            b = v(i);
            v(i) = v(j);
            v(j) = b;
        end
    end
end