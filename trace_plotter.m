
DIR = dir('*.dat');
set(0,'defaultfigurewindowstyle','docked');
fig = figure;
j = 1;

num_molecules = size(dir('*.dat'), 1);

category_list = zeros(num_molecules, 1);
filename = DIR(j).name;
temp = split(filename);
suffix = temp(1);

while true
    
    hel = readtable(filename);
    time = table2array(hel(:, 1));
    don = table2array(hel(:, 2));
    acc = table2array(hel(:, 3));
    %     tot = don + acc + ones(1000, 1) * 500;
    fret= acc./(acc + don);
    for i = 1:length(time)
        if ((fret(i, 1) < -0.2) || (fret(i, 1) > 1.2))
            fret(i, 1) = NaN;
        end
    end
    subplot(2, 1, 1);
    
    plot(time, don, 'g');
    hold on
    plot(time, acc, 'r');
    %     plot(time, tot, 'b');
    xlabel('Time(s)');
    ylabel('Intensity (a. u.)');
    title(filename);
    hold off
    subplot(2, 1, 2);
    plot(time, fret, 'b');
    xlabel('Time(s)');
    ylabel('FRET efficiency');
    ylim([-0.1 1]);
    figure(fig);
    in = input('Enter q to quit\nb to go back\nc to categorize\ng to go to a particular trace\ns to select a trace\n', 's');
    
    if in == 'q'
        break;
    end
    
    if in == 'b'
        j = j - 2;
    end
    
    if in == 'c'
        category = input('Category for this trace:\n');
        if ~isempty(category)
            category_list(j) = category;
        end
    end
    
    if in == 'g'
        index = input('Which trace do you want to go to?\n');
        filename = strcat(suffix, ' tr', string(index), '.dat');
        continue;
    end
    
    if in == 'x'
        status = copyfile(filename, ['../../hfd/' filename]);
        assert(status == 1);
    end
    
    j = j + 1;
    if j > num_molecules
        j = j - 1;
        disp('This is the last trace!');
    end
   
    
    if j < 1
        j = 1;
    end
    
    filename = DIR(j).name;
end

close();