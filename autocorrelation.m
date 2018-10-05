trace_name = 'hel13 tr37-1.dat';

close all

trace = table2array(readtable(trace_name));

don = trace(:, 2);
acc = trace(:, 3);
fret = acc./(acc + don);

figure
autocorr(don, 30);

figure
autocorr(acc, 30);

figure
autocorr(fret, 30);