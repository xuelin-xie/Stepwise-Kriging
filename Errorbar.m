figure(1)
Data=xlsread('compare.xlsx','time','B2:K7');
M=[0.6+1/15, 0.6+3/15, 0.6+5/15, 0.6+7/15, 0.6+9/15, 0.6+11/15];
Mean=mean(Data');
Std=std(Data');
L=Std;
U=Std;
bar([Mean;Mean]);
hold on
errorbar(M,Mean,L,U,'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1)
hold off
xlabel('Methods');
ylabel('Time');
legend({'K','SK','PCA-K','PLS1-K','PLS2-K','PLS3-K'},'FontSize',10);
set(gca,'xtick',[],'FontSize',16);
clear xlim
xlim(gca,[0.55 1.45]);
ylim(gca,[0 2.7]);
title('Time of Engineering example');

figure(2)
Data=xlsread('compare.xlsx','r2','B2:K7');
M=[0.6+1/15, 0.6+3/15, 0.6+5/15, 0.6+7/15, 0.6+9/15, 0.6+11/15];
Mean=mean(Data');
Std=std(Data');
L=Std;
U=Std;
bar([Mean;Mean]);
hold on
errorbar(M,Mean,L,U,'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1)
hold off
xlabel('Methods');
ylabel('R2');
legend({'K','SK','PCA-K','PLS1-K','PLS2-K','PLS3-K'},'FontSize',10);
set(gca,'xtick',[],'FontSize',16);
clear xlim
xlim(gca,[0.55 1.45]);
ylim(gca,[0 1]);
title('R2 of Engineering example');

figure(3)
Data=xlsread('compare.xlsx','rrmse','B2:K7');
M=[0.6+1/15, 0.6+3/15, 0.6+5/15, 0.6+7/15, 0.6+9/15, 0.6+11/15];
Mean=mean(Data');
Std=std(Data');
L=Std;
U=Std;
bar([Mean;Mean]);
hold on
errorbar(M,Mean,L,U,'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1)
hold off
xlabel('Methods');
ylabel('RRMSE');
legend({'K','SK','PCA-K','PLS1-K','PLS2-K','PLS3-K'},'FontSize',10);
set(gca,'xtick',[],'FontSize',16);
clear xlim
xlim(gca,[0.55 1.45]);
ylim(gca,[0 1.3]);
title('RRMSE of Engineering example');

figure(4)
Data=xlsread('compare.xlsx','rmae','B2:K7');
M=[0.6+1/15, 0.6+3/15, 0.6+5/15, 0.6+7/15, 0.6+9/15, 0.6+11/15];
Mean=mean(Data');
Std=std(Data');
L=Std;
U=Std;
bar([Mean;Mean]);
hold on
errorbar(M,Mean,L,U,'LineStyle', 'none', 'Color', 'k', 'LineWidth', 1)
hold off
xlabel('Methods');
ylabel('RMAE');
legend({'K','SK','PCA-K','PLS1-K','PLS2-K','PLS3-K'},'FontSize',10);
set(gca,'xtick',[],'FontSize',16);
clear xlim
xlim(gca,[0.55 1.45]);
ylim(gca,[0 5.5]);
title('RMAE of Engineering example');