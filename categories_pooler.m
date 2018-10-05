hela_name = 'hel18_hfds.csv';
helb_name = 'hel21_hfds.csv';
% helc_name = 'hel25_hfds.csv';

hela = csvread(hela_name);
helb = csvread(helb_name);
% helc = csvread(helc_name);

% helpool = [hela(:, 2); helb(:, 2); helc(:, 2)];
helpool = [hela(:, 2); helb(:, 2)];

h = histcounts(helpool)