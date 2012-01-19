function monthly_bar_chart_v4(NEE,GPP,RE,PPT,TA,RAD,EVA)
TA(TA==0)=nan;

% NEE(5,43:48)=nan;
% GPP(5,43:48)=nan;
% RE(5,43:48)=nan;
% PPT(5,43:48)=nan;
% TA(5,43:48)=nan;
% RAD(5,43:48)=nan;
% EVA(5,43:48)=nan;

% NEE(6,42:48)=nan;
% GPP(6,42:48)=nan;
% RE(6,42:48)=nan;
% PPT(6,42:48)=nan;
% TA(6,42:48)=nan;
% RAD(6,42:48)=nan;
% EVA(6,42:48)=nan;

RAD=(RAD.*1000000)./(60*60*8*30); %MJ month-1 to Wm-2



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PPine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot Fig 1, PPine Mar 07 - Sept 10

colour=[0.5 0.5 1.0];

sc = 5;

figure;
ppine_fig = gcf;

subplot(4,1,1)
bar1 = bar(NEE(sc,:),'FaceColor',colour,'EdgeColor',colour,...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-150 100],'k'); hold on
plot([24.5 24.5],[-150 100],'k'); hold on
plot([36.5 36.5],[-150 100],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-150 100]);
ylabel('NEE (g C m^-^2)','fontsize',12); %legend('2007','2008');
title('Ponderosa','fontsize',14)

subplot(4,1,2)
bar3 = bar(GPP(sc,:).*-1,'FaceColor','g','EdgeColor','g',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel',[],'ylim',[-250 200]);

subplot(4,1,2)
bar3 = bar(RE(sc,:),'FaceColor','r','EdgeColor','r',...
    'LineWidth',2,...
    'BarWidth',0.6);
plot([12.5 12.5],[-500 500],'k'); hold on
plot([24.5 24.5],[-500 500],'k'); hold on
plot([36.5 36.5],[-500 500],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-250 200]);
ylabel('GPP & Re (g C m^-^2)','fontsize',12);

subplot(4,1,3)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=RAD(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ylim',[0 250],'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[0 1000],'ytick',[0 200 400 600 800 1000],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Rg (W m^-^2)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(EVA(5,:),'FaceColor','none','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel','','ylim',[0 365])
ylabel('ET (mm)','color','k','fontsize',12);

subplot(4,1,4)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=TA(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[-20 30],'ytick',[-20 -10 0 10 20 30],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Air temp (^oC)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(PPT(sc,:),'FaceColor','b','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel',...
    'Mar 07| |Sept 07| |Mar 08| |Sept 08| |Mar 09| |Sept 09| |Mar 10| |Sept 10','ylim',[0 250]);
%   'Mar 07|June 07|Sept 07|Dec 07|Mar 08|June 08|Sept 08|Dec 08|Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
xlabel('Month','fontsize',12); ylabel('Precipitation (mm)','color','k','fontsize',12);

%%

orient landscape
print -dpdf 'Ponderosa.pdf'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mixed conifer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot Fig 2, MCon Mar 07 - Sept 10

sc = 6;

colour=[0.0 0.0 0.6];

figure;
mc_fig = gcf;

subplot(4,1,1)
bar1 = bar(NEE(sc,:),'FaceColor',colour,'EdgeColor',colour,...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-150 100],'k'); hold on
plot([24.5 24.5],[-150 100],'k'); hold on
plot([36.5 36.5],[-150 100],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-100 50]);
ylabel('NEE (g C m^-^2)','fontsize',12); %legend('2007','2008');
title('Mixed','fontsize',14)

subplot(4,1,2)
bar3 = bar(GPP(sc,:).*-1,'FaceColor','g','EdgeColor','g',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel',[],'ylim',[-150 100]);

subplot(4,1,2)
bar3 = bar(RE(sc,:),'FaceColor','r','EdgeColor','r',...
    'LineWidth',2,...
    'BarWidth',0.6);
plot([12.5 12.5],[-500 500],'k'); hold on
plot([24.5 24.5],[-500 500],'k'); hold on
plot([36.5 36.5],[-500 500],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-150 100]);
ylabel('GPP & Re (g C m^-^2)','fontsize',12);

subplot(4,1,3)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=RAD(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ylim',[0 250],'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[0 1000],'ytick',[0 200 400 600 800 1000],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Rg (W m^-^2)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(EVA(sc,:),'FaceColor','none','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel','','ylim',[0 365])
ylabel('ET (mm)','color','k','fontsize',12);

subplot(4,1,4)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=TA(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[0 49],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[-20 30],'ytick',[-20 -10 0 10 20 30],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Air temp (^oC)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(PPT(sc,:),'FaceColor','b','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[0 49],'XTickLabel',...
    'Mar 07| |Sept 07| |Mar 08| |Sept 08| |Mar 09| |Sept 09| |Mar 10| |Sept 10','ylim',[0 365]);
%   'Mar 07|June 07|Sept 07|Dec 07|Mar 08|June 08|Sept 08|Dec 08|Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
xlabel('Month','fontsize',12); ylabel('Precipitation (mm)','color','k','fontsize',12);

%%

orient landscape
print -dpdf 'Mixed.pdf'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PPine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot figure 3, PPine Mar 09 - June 10

colour=[0.5 0.5 1.0];

sc = 5;

figure;
ppine_fig = gcf;

subplot(4,1,1)
bar1 = bar(NEE(sc,:),'FaceColor',colour,'EdgeColor',colour,...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-150 100],'k'); hold on
plot([24.5 24.5],[-150 100],'k'); hold on
plot([36.5 36.5],[-150 100],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-150 100]);
ylabel('NEE (g C m^-^2)','fontsize',12); %legend('2007','2008');
title('Ponderosa','fontsize',14)

subplot(4,1,2)
bar3 = bar(GPP(sc,:).*-1,'FaceColor','g','EdgeColor','g',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel',[],'ylim',[-250 200]);

subplot(4,1,2)
bar3 = bar(RE(sc,:),'FaceColor','r','EdgeColor','r',...
    'LineWidth',2,...
    'BarWidth',0.6);
plot([12.5 12.5],[-500 500],'k'); hold on
plot([24.5 24.5],[-500 500],'k'); hold on
plot([36.5 36.5],[-500 500],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-250 200]);
ylabel('GPP & Re (g C m^-^2)','fontsize',12);

subplot(4,1,3)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=RAD(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ylim',[0 250],'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[0 1000],'ytick',[0 200 400 600 800 1000],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Rg (W m^-^2)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(EVA(sc,:),'FaceColor','none','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel','','ylim',[0 365])
ylabel('ET (mm)','color','k','fontsize',12);

subplot(4,1,4)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=TA(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[-20 30],'ytick',[-20 -10 0 10 20 30],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Air temp (^oC)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(PPT(sc,:),'FaceColor','b','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel',...
    'Mar 07| |Sept 07| |Mar 08| |Sept 08| |Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
%    'Mar 07|June 07|Sept 07|Dec 07|Mar 08|June 08|Sept 08|Dec 08|Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
xlabel('Month','fontsize',12); ylabel('Precipitation (mm)','color','k','fontsize',12);

%%

orient landscape
print -dpdf 'Ponderosa_2.pdf'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mixed conifer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot figure 4, MCon Mar 09 - June 10

sc = 6;

colour=[0.0 0.0 0.6];

% NEE(6,43:48)=nan;
% GPP(6,43:48)=nan;
% RE(6,43:48)=nan;
% PPT(6,42:48)=nan;
% TA(6,[42:48])=nan;
% RAD(6,[42:48])=nan;
% EVA(6,42:48)=nan;


figure;
mc_fig = gcf;

subplot(4,1,1)
bar1 = bar(NEE(sc,:),'FaceColor',colour,'EdgeColor',colour,...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-150 100],'k'); hold on
plot([24.5 24.5],[-150 100],'k'); hold on
plot([36.5 36.5],[-150 100],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-100 50]);
ylabel('NEE (g C m^-^2)','fontsize',12); %legend('2007','2008');
title('Mixed','fontsize',14)

subplot(4,1,2)
bar3 = bar(GPP(sc,:).*-1,'FaceColor','g','EdgeColor','g',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel',[],'ylim',[-150 100]);

subplot(4,1,2)
bar3 = bar(RE(sc,:),'FaceColor','r','EdgeColor','r',...
    'LineWidth',2,...
    'BarWidth',0.6);
plot([12.5 12.5],[-500 500],'k'); hold on
plot([24.5 24.5],[-500 500],'k'); hold on
plot([36.5 36.5],[-500 500],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel',[],'ylim',[-150 100]);
ylabel('GPP & Re (g C m^-^2)','fontsize',12);

subplot(4,1,3)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=RAD(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ylim',[0 250],'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[0 1000],'ytick',[0 200 400 600 800 1000],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Rg (W m^-^2)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(EVA(sc,:),'FaceColor','none','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel','','ylim',[0 250])
ylabel('ET (mm)','color','k','fontsize',12);

subplot(4,1,4)
x1=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
y1=x1.*NaN;
y2=TA(sc,:);
[AX,H1,H2] = plotyy(x1,y1,x1,y2); hold on
set(AX(1),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','',...
    'ytick',[0 50 100 150 200 250],'ycolor','k');
set(AX(2),'fontweight','bold','fontsize',10,'xlim',[24.5 48],...
    'XTick',[3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48],'XTickLabel','','ylim',[-20 30],'ytick',[-20 -10 0 10 20 30],...
    'ycolor','k')
set(get(AX(2),'Ylabel'),'fontweight','bold','fontsize',10,'String','Air temp (^oC)','fontsize',12) 
set(H2,'color','k','linestyle','-','linewidth',2,'marker','s','markersize',4,'markerfacecolor','k')

bar3 = bar(PPT(sc,:),'FaceColor','b','EdgeColor','b',...
    'LineWidth',2,...
    'BarWidth',0.6); hold on
plot([12.5 12.5],[-500 5000],'k'); hold on
plot([24.5 24.5],[-500 5000],'k'); hold on
plot([36.5 36.5],[-500 5000],'k'); hold on
set(gca,'fontweight','bold','fontsize',10,'xlim',[24.5 48],'XTickLabel',...
    'Mar 07| |Sept 07| |Mar 08| |Sept 08| |Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
%    'Mar 07|June 07|Sept 07|Dec 07|Mar 08|June 08|Sept 08|Dec 08|Mar 09|June 09|Sept 09|Dec 09|Mar 10|June 10|Sept 10|Dec 10','ylim',[0 365]);
xlabel('Month','fontsize',12); ylabel('Precipitation (mm)','color','k','fontsize',12);

%%

orient landscape
print -dpdf 'Mixed_2.pdf'