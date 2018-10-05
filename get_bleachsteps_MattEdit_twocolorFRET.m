function get_bleachsteps_MattEdit
%%%%----- read data from the file location path. Should have .dat files.
%%%%---change the time and int_donor intial points to exclude vesicle data
    path = input('Directory   ');
	if isempty(path)
   	path='Y:\MattP\Ahana\Matt Analysis\SWR1 binding\hel_121';
	end
cd(path);
fnames = dir('*.dat');
f = 0;

%% -----start loop for each .dat file in folder------------------
for f = 1:length(fnames)
    filename =fnames(f).name;   % f is the counter for filename
    disp (filename);
    fid =fopen (filename, 'r');
        %there are 3 columns to scan in the data set. Stored in data below
        data =fscanf(fid,'%f %f', [3 inf]);   
        fclose(fid);
        data = data';
    tr_length = length(data); %length of the int_donorce, i.e the time points
    time = data(1:end,1); %data(94:end,1)time points are stored in this matrix
    int_donor = data(1:end,2);  %change the intial point to exclude vesicle data
    int_acceptor = data(1:end,3);
    %%int_donor_diff = diff(int_donor);
    tr_length_new = (tr_length); % to adjust the trace length accordingly
    % this number is one less than initial data point in 'time'
    j = 0;
    
    %% -------plot the intensity histogram and the raw data-----------------------------      
    
    l2= length(int_donor);
    x2= 1:l2;
    h = gcf;
    figure(h);
    subplot(3,1,1); 
    hist(int_donor,50);
    grid on;
    subplot(3,1,2); 
    plot (x2,int_donor, 'green', 'LineWidth', 2);
    grid on;
    subplot(3,1,3); 
    plot (x2,int_acceptor, 'red', 'LineWidth', 2);
    grid on;
    title(['Trace Name     ',filename]);

    output=[time int_donor int_acceptor];
    
    
    %pause; 
    %pauses script to adjust zoom in on graph. This fixes a bug in
    %Matlab2016a. Press any key to continue the script.
    ans=input('press s to save and press p to pass.','s');


    %% ---------------Photobleaching Steps-----------------%%%%%    
if ans=='1'
   mkdir('1steps');
   newname='/1steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='2'
    mkdir('2steps');
   newname='/2steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='3'
    mkdir('3steps');
   newname='/3steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd .. 
end


if ans=='4'
   mkdir('4steps');
   newname='/4steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd .. 
end


if ans=='5'
   mkdir('5steps');
   newname='/5steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='6'
   mkdir('6steps');
   newname='/6steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='7'
   mkdir('7steps');
   newname='/7steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='8'
   mkdir('8steps');
   newname='/8steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='9'
   mkdir('9steps');
   newname='/9steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end


if ans=='0'
   mkdir('Rej');
   newname='/Rej';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='`'
   mkdir('transient');
   newname='/transient';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='+'
   mkdir('10steps');
   newname='/10steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='/'
   mkdir('11steps');
   newname='/11steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='*'
   mkdir('12steps');
   newname='/12steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

if ans=='-'
   mkdir('13steps');
   newname='/13steps';
   path2=strcat(path,newname);
   cd(path2);
   dlmwrite(filename,output,'delimiter', '\t') ;
   cd ..
end

end
end

