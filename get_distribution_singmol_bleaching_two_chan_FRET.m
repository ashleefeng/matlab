
function get_distribution_singmol_bleaching_two_chan
%% ----- read data from the file location path. Should have .traces files.
% change the time and int_donor intial points to exclude vesicle data
path = input('Directory with .traces files :   ');
cd(path);

filename = input('index # of filename [default=1]:    ');
filename = num2str(filename);
['hel' filename '.traces'];

newname = strcat('hel_',filename);

mkdir('hel_12_new');
mkdir1=['/hel_12_new'];
%% ---------- reading the data into the 'raw' ---------------------------
file_id = fopen(['hel' filename '.traces'],'r');
length = fread(file_id,1,'int32');
display('The time length of the file: ');
display(length);
number_of_molecules=fread(file_id,1,'int16');
display('The number of single molecules:')
display(number_of_molecules/2);
raw = fread(file_id, number_of_molecules*length,'int16');
disp('Done reading data.');

%% --------- separate 'raw' into the individual single molecule data -----
index=(1:number_of_molecules*length);
Data=zeros(number_of_molecules,length);
donor=zeros(number_of_molecules/2,length);
acceptor=zeros(number_of_molecules/2,length);
Data(index)=raw(index);

for i=1:(number_of_molecules/2)
   donor(i,:)=Data(i*2-1,:);   
   acceptor(i,:)=Data(i*2,:);   
end
   
time = (0:(length-1))*0.1;

%% -----read each molecule intensity values ------------------

for molecule_id = 1:number_of_molecules/2
    intensity_donor = donor(molecule_id,:);
    intensity_acceptor = acceptor(molecule_id,:);
    
     
        newname = mkdir1;
        path2 = strcat(path,newname);
        cd(path2);       
        fname2=[filename ' tr' num2str(molecule_id) '_S2.dat'];
        output=[time' intensity_donor' intensity_acceptor'];
        save(fname2,'output','-ascii') ;
        cd('..');
    
    
   
%dlmwrite([filename 'average_vesicle'],average_vesicle', 'delimiter', '\t');
%dlmwrite([filename 'average_gfp'], average_gfp','delimiter','\t');
end
end