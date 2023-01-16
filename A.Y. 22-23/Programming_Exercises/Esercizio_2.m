clear, close, clc

A = [1 5 -3 -9];
counter = 0;
for i = 1:length(A)
   if A(i) >= 0
       counter = counter + 1;
   end
end

disp(['In totale il numero di elementi positivi è: ', num2str(counter)])