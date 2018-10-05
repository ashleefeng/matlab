% Written by Digvijay Singh  ( dgvjay@illinois.edu)
% This script generate a FRET histogram from a directory containing .traces file
% Edited by Ashlee Feng (xfeng17@jhu.edu)

close all;
clear all;
fclose('all');
minInt=150;
ymax=1200;
Directory_of_TracesFiles=input('Directory: ','s');

if isempty(Directory_of_TracesFiles)
    Directory_of_TracesFiles=pwd;
end

cd(Directory_of_TracesFiles);

% This script assumes that the .traces file in the folder(input above) is
% in the following order in your directory
% like hel1.traces...hel2.traces...hel3.traces

GenericFileType='.traces';   % The single molecule information post IDL analysis is stored in the .traces file
% for each movie analysed.

FileIndexNumber=input('Index: ');

if isempty(FileIndexNumber)
    FileIndexNumber=1;
end

FileIndexNumber=num2str(FileIndexNumber);

TheFileThatWillbeAnalysed = strcat('hel', FileIndexNumber, GenericFileType); %displays the .traces file that will be used to show
fprintf(strcat(TheFileThatWillbeAnalysed, '\n'));

%FilePointer
File_name = strcat('hel', FileIndexNumber, GenericFileType);
File_id=fopen(File_name,'r');
if File_id == -1
    fprintf(strcat('Error: File ', File_name, ' does not exist.\n'));
    return
end

% Define time unit (seconds)
Timeunit=input('Enter the value of the time unit i.e. frame rate [Default=0.1 sec] ');

if isempty(Timeunit)
    Timeunit=0.1;
end

% We typically employ a GammaFactor of 1.0 but if you want to change
% it...you can change it with the routine below
GammaFactor=input('Enter the value of the Gamma Factor [Default is 1.0] :  ');

if isempty(GammaFactor)
    GammaFactor=1.0;
end

% Part of the FRET Calculation
% Channel Leakage Value
ChannelLeakage=input('Enter the value of the Channel Leakage [Default is 0.12] ');
if isempty(ChannelLeakage)
    ChannelLeakage=0.12;
    % T70S: 0.175
end


% Extracting important information from .traces binary file
Length_of_the_TimeTraces=fread(File_id,1,'int32');% This fetches the total duration of the imaging that was carried out for the

% concerned .traces file...please note that .traces is a binary file and
% this is the way it was binarized and we are just extracting the
% information from the binary file
disp('The length of the time traces is: ')
disp(Length_of_the_TimeTraces);% This displays the total duration of the imaging that was carried out for the
% concerned .traces file.

num_traces=fread(File_id,1,'int16');  % This fetches the total number of single molecule spots in the
% concerned .traces file...since each spot has a pair i.e. Green channel
% and a red channel therefore we would need to divide this number by 2 to
% get the actual number of spots.

disp('The number of traces in this file is:')
num_molecules = num_traces / 2;
disp(num_molecules);% This displays the total number of single molecule spots in the
% concerned .traces file.

%Reading in the entire raw data from the .traces binary file encoded in
%int16 format as noted above that .traces is a binary file and
% this is the way it was binarized and we are just extracting the
% information from the binary file.
Raw_Data=fread(File_id,num_traces*Length_of_the_TimeTraces,'int16');
disp('Done reading data');
fclose(File_id);  % We close the file pointer here as all the information that we needed from it
% has been extracted succesffuly and stored into local variables like Raw_Data, num_traces etc etc.


% Converting into Donor and Acceptor traces of several selected spots in
% the movie.
Index_of_SelectedSpots=(1:num_traces*Length_of_the_TimeTraces);
DataMatrix=zeros(num_traces,Length_of_the_TimeTraces);
Donors=zeros(num_traces/2,Length_of_the_TimeTraces);
Acceptors=zeros(num_traces/2,Length_of_the_TimeTraces);
DataMatrix(Index_of_SelectedSpots)=Raw_Data(Index_of_SelectedSpots);

for i=1:(num_traces/2)
    Donors(i,:)=DataMatrix(i*2-1,:);   %So this will be a matrix where each column will be the Donor time series of each selected spot of the movie
    Acceptors(i,:)=GammaFactor.*DataMatrix(i*2,:); %So this will be a matrix where each column will be the Acceptor time series of each selected spot of the movie
end

TimeSeries=(0:(Length_of_the_TimeTraces-1))*Timeunit;
%TimeSeries is nothing but the index of each frame event in the series.
% Suppose you made a movie which is 10 seconds long, if the frame rate was 100ms. It means you have collected
%     10/0.1 ==100 frames. TimeSeries is simply a series from 1 to 100 where index 1 would correspond to first frame
%     index 2 would correspond to frame2 and index 3 would correspond to frame numbrr 3 and so on and each frame number
%     would have a particular intensity for the spot in the Green channel and the red channel.

% open and read the .pks for coordinates

pks_fname = strcat('hel', FileIndexNumber, '.pks');
pks_id=fopen(pks_fname,'r');

A = fscanf(pks_id,'%f %f %f %f',[4 Inf]);
A = A';

fclose(pks_id);

newfolder = [FileIndexNumber ' selected traces'];
mkdir(newfolder);

% ==========================================================================

TracesCounter=0;
%Now we will be going over the trace one by one to select them or whatever
figure;
hd13=gcf;

% for making histogram
fret_data = zeros(num_traces/2, 1);

step_count_list = zeros(num_molecules, 1);

tif_fname = strcat('hel', FileIndexNumber, '_ave.tif');
tif_fileID = fopen(tif_fname);

if tif_fileID ~= -1
    fclose(tif_fileID);
else
    fprintf(strcat('\nError: ', tif_fname, ' does not exist.\n\n'));
end

while TracesCounter < num_traces/2
    TracesCounter = TracesCounter + 1 ;

    FRET_Time_Series=(Acceptors(TracesCounter,:)...
        -ChannelLeakage*Donors(TracesCounter,:))...
        ./(Acceptors(TracesCounter,:)...
        -ChannelLeakage*Donors(TracesCounter,:)...
        +(Donors(TracesCounter,:)));
    
    for m=1:Length_of_the_TimeTraces
        if Acceptors(TracesCounter,m)+Donors(TracesCounter,m)<minInt
            FRET_Time_Series(m)=NaN;
        end
    end
    
    fret_data(TracesCounter) = mean(FRET_Time_Series(3:8));
    
end

close all;

a = histogram(fret_data)
a.BinWidth = 0.01;
a.BinfLimits = [-1, 2];



