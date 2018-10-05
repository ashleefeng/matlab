% Written by Digvijay Singh  ( dgvjay@illinois.edu)
% Edited by Ashlee Feng (xfeng17@jhu.edu)

clear

% user input
TARGET_CATEGORY = 2;
% end of user input

fclose('all');
minInt=100;
ymax=800;
Directory_of_TracesFiles=input('Directory: ','s');

if isempty(Directory_of_TracesFiles)
    Directory_of_TracesFiles=pwd;
end

cd(Directory_of_TracesFiles);

GenericFileType='.traces';

FileIndexNumber=input('Index: ');

if isempty(FileIndexNumber)
    FileIndexNumber=1;
end

FileIndexNumber=num2str(FileIndexNumber);

TheFileThatWillbeAnalysed = strcat('hel', FileIndexNumber, GenericFileType);
fprintf(strcat(TheFileThatWillbeAnalysed, '\n'));

File_name = strcat('hel', FileIndexNumber, GenericFileType);
cat_filename = strcat('hel', FileIndexNumber, '_hfds.csv');
cat_file = csvread(cat_filename);
categ = cat_file(:, 2);
File_id=fopen(File_name,'r');
if File_id == -1
    fprintf(strcat('Error: File ', File_name, ' does not exist.\n'));
    return
end

Timeunit=input('Enter the value of the time unit i.e. frame rate [Default=0.1 sec] ');

if isempty(Timeunit)
    Timeunit=0.1;
end

GammaFactor=input('Enter the value of the Gamma Factor [Default is 1.0] :  ');

if isempty(GammaFactor)
    GammaFactor=1.0;
end

ChannelLeakage=input('Enter the value of the Channel Leakage [Default is 0.12] ');
if isempty(ChannelLeakage)
    ChannelLeakage=0.12;
    % T70S: 0.175
end


Length_of_the_TimeTraces=fread(File_id,1,'int32');% This fetches the total duration of the imaging that was carried out for the

disp('The length of the time traces is: ')
disp(Length_of_the_TimeTraces);

num_traces=fread(File_id,1,'int16');

disp('The number of traces in this file is:')
num_molecules = num_traces / 2;
disp(num_molecules);

Raw_Data=fread(File_id,num_traces*Length_of_the_TimeTraces,'int16');
disp('Done reading data');
fclose(File_id);

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
pks_fname = strcat('hel', FileIndexNumber, '.pks');
pks_id=fopen(pks_fname,'r');

A = fscanf(pks_id,'%f %f %f %f',[4 Inf]);
A = A';

fclose(pks_id);

newfolder = [FileIndexNumber '_hfd'];
mkdir(newfolder);

TracesCounter=0;
figure;
hd13=gcf;

step_count_list = zeros(num_molecules, 1);

while TracesCounter < num_traces/2
    TracesCounter = TracesCounter + 1 ;
    
%     disp(categ(TracesCounter));
    
    if categ(TracesCounter) == TARGET_CATEGORY
        
        
        
        %close all;
        
        figure(hd13);
        %    ax1=subplot(3,3,[1 2 3]);
        ax1 = subplot(2, 1, 1);
        plot(TimeSeries,Donors(TracesCounter,:),'g',...
            TimeSeries,(Acceptors(TracesCounter,:)-ChannelLeakage*Donors(TracesCounter,:)),'r');
        
        temp=axis;
        temp(2)=TimeSeries(end);
        temp(3)=-100;
        %    temp(4)=ymax; %adjust max y-axis
        axis(temp);
        
        
        xlabel('Time(s)');
        ylabel('Intensity (a.u.)');
        xlim([0 Length_of_the_TimeTraces * Timeunit]);
        TitleNameForThePlot=sprintf('Molecule %d / %d of %s',TracesCounter,num_traces/2,TheFileThatWillbeAnalysed);
        title(TitleNameForThePlot);
        
        ax2 = subplot(2, 1, 2);
        FRET_Time_Series=(Acceptors(TracesCounter,:)...
            -ChannelLeakage*Donors(TracesCounter,:))...
            ./(Acceptors(TracesCounter,:)...
            -ChannelLeakage*Donors(TracesCounter,:)...
            +(Donors(TracesCounter,:)));
        
        plot(TimeSeries,FRET_Time_Series,'LineWidth',1.2,'Color','b');
        xlabel('Time(s)');
        ylabel('FRET Efficiency');
        xlim([0 Length_of_the_TimeTraces * Timeunit]);
        ylim([-0.2 1.2]);
        temp=axis;temp(2)=TimeSeries(end);
        temp(3)=-0.1;
        temp(4)=1.1;
        axis(temp);
        
        linkaxes([ax1,ax2],'x');
        
        green = uint8([0 255 0]);
        
        % use '\' for PC
        fname1=[Directory_of_TracesFiles '/' newfolder  '/hel' FileIndexNumber ' tr' num2str(TracesCounter) '.dat'];
        Output_to_be_saved_inaFile=[TimeSeries()' Donors(TracesCounter,:)' (Acceptors(TracesCounter,:)-ChannelLeakage*Donors(TracesCounter,:))'];
        save(fname1,'Output_to_be_saved_inaFile','-ascii') ;
    end
    
end

fprintf('Done.\n');

close all;
