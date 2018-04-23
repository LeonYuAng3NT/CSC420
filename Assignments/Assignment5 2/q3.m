x = [5; 10];
y = 1;
w = [1.1; -6.0];
b = 2;

dLdw1 = x(1)*( h(w, x, b)-y);
dLdw2 = x(2)*( h(w, x, b)-y);
dLdb = h(w, x, b)-y;

disp(dLdw1);
disp(dLdw2);
disp(dLdb);

function result = h(w, x, b)
    result = 1/(1+exp(-1*((w.'*x)+b)));
end