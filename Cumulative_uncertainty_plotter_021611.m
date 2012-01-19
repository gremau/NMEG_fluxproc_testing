close all
clear all

% sitecode key
afnames(1,:) = 'US-Seg'; % 1-GLand
afnames(2,:) = 'US-Ses'; % 2-SLand
afnames(3,:) = 'US-Wjs'; % 3-JSav
afnames(4,:)='US-Mpj'; % 4-PJ
afnames(5,:)='US-Vcp'; % 5-PPine
afnames(6,:)='US-Vcm'; % 6-MCon
afnames(7,:)='US-FR2'; % 7-TX_savanna

colour(1,:)=[0.9 0.5 0.0];
colour(2,:)=[0.6 0.2 0];
colour(3,:)=[0.25 1.0 0.0];
colour(4,:)=[0.0 0.5 0.0];
colour(5,:)=[0.5 0.5 1.0];
colour(6,:)=[0.0 0.0 0.6];

sitecode = 6;

filename = strcat(afnames(sitecode,:),'_2007_gapfilled.txt');
MCon_07 = dlmread(filename,'',5,0);
filename = strcat(afnames(sitecode,:),'_2008_gapfilled.txt');
MCon_08 = dlmread(filename,'',5,0);
filename = strcat(afnames(sitecode,:),'_2009_gapfilled.txt');
MCon_09 = dlmread(filename,'',5,0);
filename = strcat(afnames(sitecode,:),'_2010_gapfilled.txt');
MCon_10 = dlmread(filename,'',5,0);



MCon_07(MCon_07==-9999)=nan; MCon_08(MCon_08==-9999)=nan; MCon_09(MCon_09==-9999)=nan;MCon_10(MCon_10==-9999)=nan;

cum_nee(:,1)=MCon_07(1:17416,11);
cum_nee(:,2)=MCon_08(1:17416,11);
cum_nee(:,3)=MCon_09(1:17416,11);
cum_nee(:,4)=MCon_10(1:17416,11);


cum_nee=cum_nee.*0.0216;

cum_nee(isnan(cum_nee))=0;

% ensem_07=(randn(13800,1000));
% test = MCon_07(1:13800,11);
% tester=repmat(test,1,1000);
% tester2=tester.*0.15;
% ensem_07=(ensem_07.*tester2)+tester;
% ensem_07=ensem_07.*0.0216;
% 
% for j = 1:1000
%     cum_ens_07(:,j)=cumsum(cum_ens_07(:,j));
% end

cum_nee(:,4)=cumsum(cum_nee(:,1));
cum_nee(:,5)=cumsum(cum_nee(:,2));
cum_nee(:,6)=cumsum(cum_nee(:,3));
cum_nee(:,7)=cumsum(cum_nee(:,4));

month_ticks = ['Jan';
'Feb';
'Mar';
'Apr';
'May';
'Jun';
'Jul';
'Aug';
'Sep';
'Oct';
'Nov';];

xtck=linspace(1,14400,11);

figure;
aa=gcf;
plot(cum_nee(:,4),'r'); hold on
plot(cum_nee(:,5),'b'); hold on
plot(cum_nee(:,6),'g'); hold on
plot(cum_nee(:,7),'g'); hold on
ylabel('Cumulative NEE (g C m^-^2)');
xlim([1 14400]); set(gca,'XTick',xtck,'xticklabel',month_ticks)

ndays=363;

for i =1:ndays
   daily_values(i,1)=sum(MCon_07(MCon_07(:,2)==i,11).*0.0216);
   daily_values(i,2)=sum(MCon_08(MCon_08(:,2)==i,11).*0.0216); 
   daily_values(i,3)=sum(MCon_09(MCon_09(:,2)==i,11).*0.0216); 
   daily_values(i,4)=sum(MCon_10(MCon_10(:,2)==i,11).*0.0216); 
end

daily_values(isnan(daily_values))=0;

figure;
plot(daily_values(:,1),'ro'); hold on
plot(daily_values(:,2),'bo'); hold on
plot(daily_values(:,3),'go'); hold on
plot(daily_values(:,4),'go'); hold on

daily_noise_1=randn(ndays,1000);
daily_noise_2=randn(ndays,1000);
daily_noise_3=randn(ndays,1000);
daily_noise_4=randn(ndays,1000);

daily_noise_1=daily_noise_1.*0.5;
daily_noise_2=daily_noise_2.*0.5;
daily_noise_3=daily_noise_3.*0.5;
daily_noise_4=daily_noise_4.*0.5;

adder=repmat(daily_values(:,1),1,1000);
daily_noise_1=daily_noise_1+adder;
adder=repmat(daily_values(:,2),1,1000);
daily_noise_2=daily_noise_2+adder;
adder=repmat(daily_values(:,3),1,1000);
daily_noise_3=daily_noise_3+adder;
adder=repmat(daily_values(:,4),1,1000);
daily_noise_4=daily_noise_4+adder;


cum_dn_1=cumsum(daily_noise_1);
cum_dn_2=cumsum(daily_noise_2);
cum_dn_3=cumsum(daily_noise_3);
cum_dn_4=cumsum(daily_noise_4);

figure;
plot(cum_dn_1,'r'); hold on
plot(cumsum(daily_values(:,1)),'ko')
plot(cum_dn_2,'b'); hold on
plot(cumsum(daily_values(:,2)),'ks')
plot(cum_dn_3,'g'); hold on
plot(cumsum(daily_values(:,3)),'k*')
plot(cum_dn_4,'g'); hold on
plot(cumsum(daily_values(:,4)),'k*')

out_07=prctile(cum_dn_1',[2.5 50 97.5]);
out_08=prctile(cum_dn_2',[2.5 50 97.5]);
out_09=prctile(cum_dn_3',[2.5 50 97.5]);
out_10=prctile(cum_dn_4',[2.5 50 97.5]);

figure;
plot(out_07(2,:),'r','linewidth',3); hold on % for legend
plot(out_07(2,:),'b','linewidth',3); hold on % for legend
plot(out_07(2,:),'g','linewidth',3); hold on % for legend
plot(out_07(2,:),'k','linewidth',3); hold on % for legend
plot(out_07(1,:),'r','linewidth',1); hold on
plot(out_07(3,:),'r','linewidth',1); hold on
plot(out_08(1,:),'b','linewidth',1); hold on
plot(out_08(3,:),'b','linewidth',1); hold on
plot(out_09(1,:),'g','linewidth',1); hold on
plot(out_09(3,:),'g','linewidth',1); hold on
plot(out_10(1,:),'k','linewidth',1); hold on
plot(out_10(3,:),'k','linewidth',1); hold on
plot(out_07(2,:),'r','linewidth',3); hold on
plot(out_08(2,:),'b','linewidth',3); hold on
plot(out_09(2,:),'g','linewidth',3); hold on
plot(out_10(2,:),'g','linewidth',3); hold on


legend('2007','2008','2009'); hold on
ylabel('Cumulative NEE with 95% CI (g C m^-^2)');
xtck=linspace(0,335,12);
month_ticks = ['Jan';
'Feb';
'Mar';
'Apr';
'May';
'Jun';
'Jul';
'Aug';
'Sep';
'Oct';
'Nov';
'Dec'];
set(gca,'XTick',xtck,'xticklabel',month_ticks)















    