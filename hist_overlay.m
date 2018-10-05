%FILENAMES = ["2_B2_5000x/fret_hist.dat" "5_0.5nM_SWR1/fret_hist.dat" ...
%    "3_5nM_SWR1/fret_hist.dat" "4_5nM_SWR1_1mM_ATP/fret_hist.dat"];
%FILENAMES = ["2_B2_5000x/fret_hist.dat" "5_ssDNA/fret_hist.dat" "3_ssDNA/fret_hist.dat" "4_ssDNA/fret_hist.dat"];
TITLES = ["Nuc only" "+ 0.02 nM SWR1" "+ 0.1 nM SWR1" "+ 5 nM SWR1" "+ 10n nM ZB + 1 mM ATP"];
% FILENAMES = ["3_1nM_SWR1/fret_hist.dat" "4_5nM_SWR1/fret_hist.dat"];
% FILENAMES = ["4_5nM_SWR1/fret_hist.dat"];
FILENAMES = ["2_B2_3000X/fret_hist.dat" "5_0.02nM_SWR1/fret_hist.dat"...
    "4_0.1nM_SWR1/fret_hist.dat" "3_5nM_SWR1/fret_hist.dat"...
    "3_10nM_ZB_1mM_ATP/fret_hist.dat"];
colors = 'krmbg';
num_files = size(FILENAMES, 2);

for i = 1:num_files
    filename = FILENAMES(i);

    frethist = readtable(filename, 'Delimiter', '\t');

    x = table2array(frethist(:, 1));
    x = x(1:size(x, 1));
    y = table2array(frethist(:, 3));
    y = y(1:size(y, 1));
    
    subplot(num_files, 1, i);
    f = bar(x, y);
    f.FaceColor = colors(i);
    f.FaceAlpha = 0.3;
    f.EdgeColor = colors(i);
    f.LineWidth = 0.5;
    f.BarWidth = 1;
    title(TITLES(i));
    xlabel("FRET efficiency");
    ylabel("Frequency");
    xlim([0 1]);
    ylim([0 0.055]);
    set(gca,'FontSize',15);
    
    hold on
end

hold off

% title(TITLE);
% hold on
% 
% fitx = table2array(fit(:, 1));
% fit1 = table2array(fit(:, 3));
% fit2 = table2array(fit(:, 4));
% fit3 = table2array(fit(:, 5));
% 
% plot(fitx, fit1, '--', 'LineWidth', 3, 'color', 'm');
% plot(fitx, fit2, '--', 'LineWidth', 3, 'color', 'g');
% plot(fitx, fit3, '--', 'LineWidth', 3, 'color', 'r');

% xt = get(gca, 'XTick');
% set(gca, 'FontSize', 20);
% yt = get(gca, 'YTick');
% set(gca, 'FontSize', 20);
% xlabel('FRET efficiency', 'FontSize', 30);
% ylabel('Frequency', 'FontSize', 30);
% saveas(gcf, strcat(SAVEAS, '.png'));
% saveas(gcf, strcat(SAVEAS, '.fig'));