exposure_time = 0.1;

dt1s = [];
dt2s = [];

num_traces = length(ebf.analysis(2).viterbi);
for i = 1:num_traces
    v_series = ebf.analysis(2).viterbi(i).state;
    dt1 = 0; dt2 = 0;
    for j = 1:length(v_series)
        if v_series(j) == 1 
            if dt2 == 0 %beginning
                dt1 = dt1+1;
            else
                dt2s = [dt2s,dt2*exposure_time]; %add dt2 to list
                dt2 = 0; %reset dt2
                dt1 = dt1+1; %count dt1
            end
        else
            if dt1 == 0 %beginning
                dt2 = dt2+1;
            else
                dt1s = [dt1s,dt1*exposure_time]; %add dt1 to list
                dt1 = 0; %reset dt1
                dt2 = dt2+1; %count dt2
            end
        end
    end
end

dt1s=dt1s';
dt2s=dt2s';

% dth1 = histc(dt1s,0:0.3:20);
dth1 = histc(dt1s,0:1:20);
timestep2=0.15:0.3:20.15;
% dth2 = histc(dt2s,0:0.2:30);
dth2 = histc(dt2s,0:1:30);
timestep=0.1:0.2:30.1;

figure('Position',[680 42 1045 954]);
%dwell time fit for pop 2 (expected high)
[f12,gof12]=fit(timestep',dth2,'exp1');
subplot(6,2,[1 3]);
plot(f12,timestep',dth2);
ylabel('count');title('single exp: high FRET');
xlimhighf = xlim; ylimhighf = ylim;
sh_rsq = num2str(gof12.rsquare);sh_a=num2str(f12.a);sh_b=num2str(f12.b);
sh_text = {['Rsquare = ' sh_rsq],['a = ' sh_a],['b = ' sh_b]};
text((xlimhighf(2)-1),ylimhighf(2)/2,sh_text,'HorizontalAlignment','right');

subplot(6,2,5);
plot(f12,timestep',dth2,'residuals');
xlabel('time');ylabel('residuals'); legend('off');
temp=axis;temp(3)=-10;temp(4)=10; %adjust max y-axis
   axis(temp);

[f22,gof22]=fit(timestep',dth2,'exp2');
subplot(6,2,[7 9]);
plot(f22,timestep',dth2);
ylabel('count');title('double exp: high FRET');
dh_rsq = num2str(gof22.rsquare);dh_a=num2str(f22.a);dh_b=num2str(f22.b);
dh_c=num2str(f22.c);dh_d=num2str(f22.d);
dh_text = {['Rsquare = ' dh_rsq],['a = ' dh_a],['b = ' dh_b],['c = ' dh_c],['d = ' dh_d]};
text((xlimhighf(2)-1),ylimhighf(2)/2,dh_text,'HorizontalAlignment','right');

subplot(6,2,11);
plot(f22,timestep',dth2,'residuals');
xlabel('time');ylabel('residuals');legend('off');
temp=axis;temp(3)=-10;temp(4)=10; %adjust max y-axis
   axis(temp);
   
%dwell time fit for pop 1 (expected low)
[f11,gof11]=fit(timestep2',dth1,'exp1');
subplot(6,2,[2 4]);
plot(f11,timestep2',dth1);
ylabel('count');title('single exp: low FRET');
xlimlowf = xlim; ylimlowf = ylim;
sl_rsq = num2str(gof11.rsquare);sl_a=num2str(f11.a);sl_b=num2str(f11.b);
sl_text = {['Rsquare = ' sl_rsq],['a = ' sl_a],['b = ' sl_b]};
text((xlimlowf(2)-1),ylimlowf(2)/2,sl_text,'HorizontalAlignment','right');

subplot(6,2,6);
plot(f11,timestep2',dth1,'residuals');
xlabel('time');ylabel('residuals');legend('off');
temp=axis;temp(3)=-10;temp(4)=10; %adjust max y-axis
   axis(temp);


[f21,gof21]=fit(timestep2',dth1,'exp2');
subplot(6,2,[8 10]);
plot(f21,timestep2',dth1);
ylabel('count');title('double exp: low FRET');
dl_rsq = num2str(gof21.rsquare);dl_a=num2str(f21.a);dl_b=num2str(f21.b);
dl_c=num2str(f21.c);dl_d=num2str(f21.d);
dl_text = {['Rsquare = ' dl_rsq],['a = ' dl_a],['b = ' dl_b],['c = ' dl_c],['d = ' dl_d]};
text((xlimlowf(2)-1),ylimlowf(2)/2,dl_text,'HorizontalAlignment','right');

subplot(6,2,12);
plot(f21,timestep2',dth1,'residuals');
xlabel('time');ylabel('residuals');legend('off');
temp=axis;temp(3)=-10;temp(4)=10; %adjust max y-axis
   axis(temp);
   
figure;
scatter(timestep',dth2); hold on;
scatter(timestep2',dth1,'r');hold off;

low_and_high_dt = [mean(dt1s) mean(dt2s)]
