%Bach_correction By Sangwoo Park. 2015.
%Simpler version with only leakage correction

%frame set up 
stp1=2; len1=5;     % green exitation range
stp2=12; len2=5;    % red exitation range

%intensity matrix (Donor/Acceptor channel in Donor exciation, Acceptor channel in Acceptor excitation)
D=[];A=[];R=[];

%correction factors (leakage)
C=[];

%minimum donor-only spot number for correction
t_leak=100;

%default correction factor
d_Dback=0; d_Aback=0; d_Rback=0; d_leak=0.2; d_dir=0; d_gamma=1;

%scatter/histogram plot bound
binwidth=0.01; mini=-0.2; maxi=1.2; bound=[mini:binwidth:maxi];

%Do intensity selection?
choice='yes';
%choice='n'
%Take off Donor only peak?
custom='yes';
%custom='no';

%read trace files
[file_list,path]=uigetfile('*.traces','MultiSelect','off');
disp(path)
cd(path);
file_list=dir;

 for l=1:length(file_list);
     file_name=file_list(l).name;
     if (length(file_name) >=6) & (file_name(end-5:end) == 'traces');
         disp(file_name)
         fid=fopen(file_name,'r');
         len=fread(fid,1,'int32');
         disp(len);
         Ntraces=fread(fid,1,'int16');
         raw=fread(fid,Ntraces*len,'int16');
         fclose(fid);
         index=(1:Ntraces*len);
         Data=zeros(Ntraces,len);
         Data(index)=raw(index);
         for k=1:Ntraces/2
             D=[D;mean(Data(2*k-1,stp1:stp1+len1-1))];
             A=[A;mean(Data(2*k,stp1:stp1+len1-1))];
             R=[R;mean(Data(2*k,stp2:stp2+len2-1))];
             %R=[R;mean(Data(2*k-1,stp2:stp2+len2-1))];
         end
     end
 end
 
 %temp = D;
 %D = A;
 %A = temp;

% Set-up intensity range (cut off bad spots)
if choice == 'yes'
    I=D+A; E=A./(D+A);
    f=figure('units','normalized','outerposition',[0.15 0.025 0.7 0.98]);

    ax1= subplot(2,2,1);
    a=hist(E,bound);hist(E,bound);
    axis([bound(1), bound(end),0,max(a)+50]);
    ylabel('Count'); grid on;
    h1 = findobj(gca,'Type','patch');
    set(h1,'FaceColor','b','EdgeColor','k');

    ax3= subplot(2,2,3);
    plot(E, I,'.','MarkerSize',5,'Color','k');
    axis([bound(1),bound(end),min(I),max(I)]);
    zoom on; grid on; xlabel('E'); ylabel('I');

    ax4= subplot(2,2,4);
    [a,b]=hist(I,[min(I):50:max(I)]); barh(b,a,'k');
    axis([0,max(a)+50, min(I), max(I)]);
    xlabel('Count'); grid on;

    linkaxes([ax1,ax3],'x');
    linkaxes([ax3,ax4],'y');

    set(ax3,'Position',[0.07 0.07 0.7 0.7]);
    set(ax1,'Position',[.07 .8 .7 .18]);
    set(ax4,'Position',[.8 .07 .15 .7]);

    disp('Select Lower bound of I')
    [dummy,lower_I]=ginput(1);
    disp('Select Upper bound of I')
    [dummy,upper_I]=ginput(1);

    spot_list=[];
    for i=[1:length(I)]
        if (I(i) > lower_I) && (I(i) < upper_I)
            spot_list=[spot_list;i];
        end
    end
    D=D(spot_list); A=A(spot_list); R=R(spot_list);

    close(f)
end

% Display raw graphs
I=D+A; E=A./(D+A); %S=R./(D+R);
S=(D+A)./(D+A+R);

f=figure('units','normalized','outerposition',[0.15 0.025 0.7 0.98]);

ax1= subplot(2,2,1);
a=hist(E,bound);hist(E,bound);
axis([bound(1), bound(end),0,max(a)+50]);
ylabel('Count'); grid on;
h1 = findobj(gca,'Type','patch');
set(h1,'FaceColor','b','EdgeColor','k');

ax3= subplot(2,2,3);
scatter(E, S,10,I,'filled');
axis([bound(1),bound(end),bound(1),bound(end)]);
zoom on; grid on; xlabel('E'); ylabel('S');

ax4= subplot(2,2,4);
[a,b]=hist(S,bound); barh(b,a,'r');
axis([0,max(a)+50,bound(1), bound(end)]);
xlabel('Count'); grid on;

linkaxes([ax1,ax3],'x');
linkaxes([ax3,ax4],'y');

set(ax3,'Position',[0.07 0.07 0.7 0.7]);
set(ax1,'Position',[.07 .8 .7 .18]);
set(ax4,'Position',[.8 .07 .15 .7]);

fname=['ES_scatter_batch.png'];
print(fname,'-dpng');

% get inputs
disp('Select Donor-Only spots')
[E_range1,S_range1]=ginput(2);

% sort-out
d_only=[];
for i=[1:length(E)]
    if (E(i) > E_range1(1)) && (E(i) < E_range1(2)) && ...
       (S(i) > S_range1(2)) && (S(i) < S_range1(1))
        d_only=[d_only;i];
    end
end

ratio=(length(D)-length(d_only))/length(D);
disp(['Dual-labeled / Cy3 labeled ratio: ', num2str(ratio)])

close(f);

% leakage correction
E=A./(D+A); S=(D+A)./(D+A+R);
l=A(d_only)./D(d_only);

figure('units','normalized','outerposition',[0.23 0.1 0.5 0.8],'Name','leakage factor')

subplot(2,1,1)
hist(l,[0:0.01:1]); hold on;
if length(d_only) > t_leak
    modelfun=@(b,x)(exp(-0.5*((x-b(2))./b(1)).^2)./(b(1)*sqrt(2*pi))*b(3));
    beta=[std(l),mean(l),length(l)];
    x=[0:0.01:1]+0.01/2; y=hist(l,[0:0.01:1]);
    co=nlinfit(x,y,modelfun,beta);
    k=1; u=[0:0.01:1]; C=[C;co(:,k+1)];
    v=exp(-0.5*((u-co(:,k+1))./co(:,k)).^2)./(co(:,k)*sqrt(2*pi))*co(:,k+2);
    plot(u,v,'Color','r','LineWidth',2); hold on;
    text(co(:,k+1),1/(co(:,k)*sqrt(2*pi))*co(:,k+2), num2str(co(:,k+1)),'LineWidth',3,'BackgroundColor',[.7 .9 .7],'VerticalAlignment','baseline'); hold on;
    ylabel('Count'); xlabel('l-factor'); grid on;
else
    disp('Leakage correction is not possible');
    C=[C;d_leak];
end

%Final graph
A=A-C(1)*D;
E=A./(D+A); S=(D+A)./(D+A+R);

if strcmp('yes',custom)
    g_list=[];
    for i=[1:length(E)];
        if ~(any(i==d_only)) 
            g_list=[g_list;i];
        end
    end
    E=E(g_list); S=S(g_list);
end

f=figure('units','normalized','outerposition',[0.15 0.025 0.7 0.98],'Name','Corrected Graph');

ax1= subplot(2,2,1);
a=hist(E,bound);hist(E,bound);
axis([bound(1), bound(end),0,max(a)+50]);
ylabel('Count'); grid on;
h1 = findobj(gca,'Type','patch');
set(h1,'FaceColor','b','EdgeColor','k');

ax3= subplot(2,2,3);
plot(E, S,'.','Color','k'); 
axis([bound(1),bound(end),bound(1),bound(end)]);
zoom on; grid on; xlabel('E'); ylabel('S');

ax4= subplot(2,2,4);
[a,b]=hist(S,bound); barh(b,a,'r');
axis([0,max(a)+50,bound(1), bound(end)]);
xlabel('Count'); grid on;

linkaxes([ax1,ax3],'x');
linkaxes([ax3,ax4],'y');

set(ax3,'Position',[0.07 0.07 0.7 0.7]);
set(ax1,'Position',[.07 .8 .7 .18]);
set(ax4,'Position',[.8 .07 .15 .7]);

%save correction factor
% fname=['correction_batch.txt'];
% output=C;
% save(fname, 'output', '-ascii');

fname=['E value_batch.txt'];
output=E;
save(fname, 'output', '-ascii');

figure
hist(E,bound);
zoom on; grid on; xlabel('FRET'); ylabel('Count');
xlim([bound(1),bound(end)]);
fname=['E hist_batch.png'];
print(fname,'-dpng');