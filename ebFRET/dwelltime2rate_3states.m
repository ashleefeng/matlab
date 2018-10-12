% Analyzes dwell time from ebFRET results, for 3 states
% Needs getDT_3states.m on path

% Xinyu (Ashlee) Feng
% Oct 12, 2018


N = 3; % number of states
t_exp = 0.1; % (s)
n_bins = 100;

% Run in cmd line: ebf = ebFRET();

viterbi_series = ebf.analysis(N).viterbi;
num_series = size(viterbi_series, 2);

dtA = [];
dtB = [];
dtC = []; 

for i = 1: num_series
    [dtA_i, dtB_i, dtC_i] = getDT_3states(viterbi_series, i);
    dtA = [dtA dtA_i];
    dtB = [dtB dtB_i];
    dtC = [dtC dtC_i];
end

figure

hA = histogram(dtA, n_bins);
title('State A histogram');
% hA.Normalization = 'probability';
% hA_one_minus_cdf = pdf2cdf(hA.Values);
xA = ((hA.BinEdges(1: (end - 1)) + hA.BinWidth/2) * t_exp)';
% fitA = fit(x, hA_one_minus_cdf', 'exp1');
fitA = fit(xA, hA.Values', 'exp1');

figure
hB = histogram(dtB, n_bins);
title('State B histogram');
% hB.Normalization = 'probability';
% hB_one_minus_cdf = pdf2cdf(hB.Values);
xB = ((hB.BinEdges(1: (end - 1)) + hB.BinWidth/2) * t_exp)';
% fitB = fit(x, hB_one_minus_cdf', 'exp1');
fitB = fit(xB, hB.Values', 'exp1');

figure
hC = histogram(dtC, n_bins);
title('State C histogram');
xC = ((hC.BinEdges(1: (end - 1)) + hC.BinWidth/2) * t_exp)';
fitC = fit(xC, hC.Values', 'exp1');

figure
% plot(fitA, x, hA_one_minus_cdf');
plot(fitA, xA, hA.Values');
title('State A');
xlabel('Dwell time (s)');
% ylabel('1 - CDF');
set(gca, 'FontSize', 20);
legend(['data', strcat('fit, k = ', string(-fitA.b))]);

figure
% plot(fitB, x, hB_one_minus_cdf');
plot(fitB, xB, hB.Values');
title('State B');
xlabel('Dwell time (s)');
% ylabel('1 - CDF');
set(gca, 'FontSize', 20);
legend(['data', strcat('fit, k = ', string(-fitB.b))]);

figure
plot(fitC, xC, hC.Values');
title('State C');
xlabel('Dwell time (s)');
set(gca, 'FontSize', 20);
legend(['data', strcat('fit, k = ', string(-fitC.b))]);


fitA
fitB
fitC
