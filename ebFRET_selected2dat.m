% converts .dat files for individual traces to one .dat file for ebFRET
% Xinyu A. Feng

% user: modify for your own use

clear;

out_name = 'ebf/hel16_ebf_hfd.dat';

folders = ["16_hfd"];
n_frames = 5000; % total length of one trace

n_init = 0; % initial frame to cut out

% end of user input

n_folders = size(folders, 2);
id = 1;
out_file = fopen(out_name, 'w');

for i = 1 : n_folders
    
    foldername = char(folders(i));
    DIR = dir([foldername '/*.dat']);
    n_files = size(DIR, 1);
    
    for j = 1 : n_files
        
        filename = DIR(j).name;
        hel = readtable(strcat(foldername, '/', filename));
        don = table2array(hel(:, 2));
        acc = table2array(hel(:, 3));
        
        to_save = [ones(1, n_frames)'*id ...
            don(n_init+1:(n_init + n_frames)) ...
            acc(n_init+1:(n_init + n_frames))];
        
        save(out_name,'to_save','-ascii', '-append');
        
        id = id + 1;
        
        if mod(id, 100) == 0
            
            fprintf(strcat("Wrote ", string(id), " traces\n"));
        
        end            
        
    end
   
end

fclose(out_file);

