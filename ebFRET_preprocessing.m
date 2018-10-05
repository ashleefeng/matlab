% Adapted from Digvijay Singh's code ( dgvjay@illinois.edu)
% by Ashlee Feng (xfeng17@jhu.edu)

% Pre-process single-molecule traces for ebFRET analysis

n_init_frames = 10; % initial frames to ignore

directory=input('Directory: ','s');
if isempty(directory)
    directory=pwd;
end
cd(directory);
suffix='.traces';
index=input('Index: ');
if isempty(index)
    index=1;
end
index=num2str(index);
filename = strcat('hel', index, suffix);
fileID=fopen(filename,'r');
if fileID == -1
    fprintf(strcat('Error: File ', filename, ' does not exist.\n'));
    return
end

time_unit=input('Enter the value of the time unit i.e. frame rate [Default=0.1 sec] ');
if isempty(time_unit)
    time_unit=0.1;
end

gamma=input('Enter the value of the Gamma Factor [Default is 1.0] :  ');
if isempty(gamma)
    gamma=1.0;
end

leakage=input('Enter the value of the Channel Leakage [Default is 0.12] ');
if isempty(leakage)
    leakage=0.12;
    % T70S: 0.175
end

n_frames=fread(fileID,1,'int32');

disp('The n_frames of the time traces is: ')
disp(n_frames);

num_traces=fread(fileID,1,'int16');

disp('The number of traces in this file is:')
num_molecules = num_traces / 2;
disp(num_molecules);

raw_data=fread(fileID,num_traces*n_frames,'int16');
disp('Done reading data');
fclose(fileID);

indices=(1:num_traces*n_frames);
matrix=zeros(num_traces,n_frames);
donors=zeros(num_traces/2,n_frames);
acceptors=zeros(num_traces/2,n_frames);
matrix(indices)=raw_data(indices);

for i=1:(num_traces/2)
    donors(i,:)=matrix(i*2-1,:);
    acceptors(i,:)=gamma.*matrix(i*2,:);
end

time_series=(0:(n_frames-1))*time_unit;
pks_fname = strcat('hel', index, '.pks');
pks_id=fopen(pks_fname,'r');

A = fscanf(pks_id,'%f %f %f %f',[4 Inf]);
A = A';

fclose(pks_id);

newfolder = [index ' for ebFRET'];
mkdir(newfolder);
out_name=[directory '/' newfolder  '/hel' index '_eb.dat'];

trace_counter=0;

while trace_counter < num_traces/2
    
    trace_counter = trace_counter + 1;
    
    fret_series=(acceptors(trace_counter,:)...
        -leakage*donors(trace_counter,:))...
        ./(acceptors(trace_counter,:)...
        -leakage*donors(trace_counter,:)...
        +(donors(trace_counter,:)));
    
    for m=1:n_frames
        if fret_series(m) < - 0.2 || fret_series(m) > 1.2
            fret_series(m)=NaN;
        end
    end
    
    results_to_save=...
        [ones(1, n_frames - n_init_frames)'*trace_counter ...
        donors(trace_counter, (n_init_frames+1):end)' ...
        (acceptors(trace_counter,(n_init_frames+1):end) - ...
        leakage*donors(trace_counter,(n_init_frames+1):end))'];
    
    out_file = fopen(out_name);
    if out_file == -1
        save(out_name,'results_to_save', '-ascii');
    else
        fclose(out_file);
        save(out_name,'results_to_save','-ascii', '-append');
    end
end

fprintf('Done.\n');

close all;