DIR = dir;
% set(0,'defaultfigurewindowstyle','docked');
% fig = figure;
j = 3;

num_molecules = input('Enter the number of traces in this folder\n');

fret_list = zeros(num_molecules, 1);

counter = 1;

while true
    FILENAME = DIR(j).name;
    hel = readtable(FILENAME);
    time = table2array(hel(:, 1));
    don = table2array(hel(:, 2));
    acc = table2array(hel(:, 3));
    tot = don + acc + ones(1000, 1) * 500;
    fret= acc./(acc + don);
%     for i = 1:1000
%         if ((fret(i, 1) < -0.2) || (fret(i, 1) > 1.2))
%             fret(i, 1) = NaN;
%         end
%     end

    fret_list(counter) = mean(fret(1:20));  
    
%     subplot(2, 1, 1);
    
%     plot(time, don, 'g');
%     hold on
%     plot(time, acc, 'r');
%     plot(time, tot, 'b');
%     xlabel('Time(s)');
%     ylabel('Intensity (a. u.)');
%     title(FILENAME);
%     hold off
%     subplot(2, 1, 2);
%     plot(time, fret, 'b');
%     xlabel('Time(s)');
%     ylabel('FRET efficiency');

    
    j = j + 1;
    if j > size(DIR, 1)
        j = j - 1;
        disp('This is the last trace!');
        break
    end
    if j < 3
        j = 3;
    end
    
    counter = counter + 1;
end

% close();