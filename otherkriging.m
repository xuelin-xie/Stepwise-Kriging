clear;
clc;
setdemorandstream(pi);
global p W;
p=0.15;
Datao=xlsread('example1.xlsx','B2:T403');
Data=zscore(Datao);
for i=1:10
n=randsample(402,330,'false');%随机在1-402个数值之间抽取322个数，并放入n中
A=Data(n,:);%A为抽取322行后的矩阵
c=1:402;
c(n)=[];%去掉抽取的n行
B=Data(c,:);%B为抽取剩下的矩阵
S=A(:,1:18);
Y=A(:,19);
AX=B(:,1:18);
AY=B(:,19);

%% Kriging    
tic
krig1=buildKRG(S,Y);   % Kriging Modeling
toc1=toc;
time1(i)=sum(toc1);
%% Stepwise-Kriging
tic
[krig2,new_AX]=buildSKRGA(S,Y,AX,AY);   % Stepwise-Kriging Modeling
toc2=toc;
time2(i)=sum(toc2);
%% PCA-Kriging
tic
 [coeff] = pca(S);
  W=coeff(:,1:2);
krig3=buildKRG(S,Y);
toc3=toc;
time3(i)=sum(toc3);
%% KPLS1-Kriging
tic
s1=S'*Y*Y'*S;
     S1=zscore(s1);
  [V D] = eig(S1);D1=diag(D);
 [m,index]=max(D1);v=V(:,index); 
W = v/norm(v);
krig4=buildKRG(S,Y);
toc4=toc;
time4(i)=sum(toc4);
%% KPLS2-Kriging
tic
s1=S'*Y*Y'*S;[V D] = eig(s1);D1=diag(D);
 [m,index]=max(D1);v=V(:,index); W1 = v/norm(v);
t1=S*W1;p1=(S'*t1)/norm(t1);c1=(Y'*t1)/norm(t1);
S1=S-t1*p1';Y1=Y-c1*t1;
s1=S1'*Y1*Y1'*S1;
[V D] = eig(s1); D1=diag(D);
[m,index]=max(D1); v=V(:,index);  W2 = v/norm(v);
t2=S1*W2;p2=(S1'*t2)/norm(t2);W9=[W1,W2];P9=[p1,p2];W=W9*inv(P9'*W9);
krig5=buildKRG(S,Y);
toc5=toc;
time5(i)=sum(toc5);
%% KPLS3-Kriging
tic
S=zscore(S);
s1=S'*Y*Y'*S;[V D] = eig(s1);D1=diag(D);
[m,index]=max(D1);v=V(:,index); W1 = v/norm(v);
t1=S*W1;p1=(S'*t1)/norm(t1);c1=(Y'*t1)/norm(t1);
S1=S-t1*p1';Y1=Y-c1*t1;
s2=S1'*Y1*Y1'*S1;
[V D] = eig(s2);
D1=diag(D);
[m,index]=max(D1); v=V(:,index);  W2 = v/norm(v);
t2=S1*W2;p2=(S1'*t2)/norm(t2);c2=(Y1'*t2)/norm(t2);
S2=S1-t2*p2';Y2=Y1-c2*t2;
s1=S2'*Y2*Y2'*S2;
[V D] = eig(s1); D1=diag(D);
[m,index]=max(D1); v=V(:,index);  W3 = v/norm(v);t3=S*W3;p3=(S'*t3)/norm(t3);
W9=[W1,W2,W3];P9=[p1,p2,p3];W=W9*inv(P9'*W9);
krig6=buildKRG(S,Y);
toc6=toc;
time6(i)=sum(toc6);

%% The evaluation index of the Kriging model 
K= predictor(AX, krig1); % RMSE
R2(i)=1-sum((AY -K).^2) /sum((AY-mean(AY)).^2); 
RRmse1(i)=(sqrt(sum((AY-K).^2)/size(K,1))) /(sqrt(sum((AY-mean(AY)).^2)/(size(K,1)-1)));
RMAE1(i)=(max(abs(AY -K)))/(sqrt(sum((AY-mean(AY)).^2)/(size(K,1)-1))); % MAE

%% The evaluation index of the S-Kriging model
SK= predictor(new_AX, krig2);
SR2(i)=1-sum((AY -SK).^2) /sum((AY-mean(AY)).^2); 
RRmse2(i)=(sqrt(sum((AY-SK).^2)/size(SK,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(SK,1)-1))); % RMSE
RMAE2(i)=(max(abs(AY -SK)))/(sqrt(sum((AY-mean(AY)).^2)/(size(SK,1)-1))); % RMAE

%% The evaluation index of PCA-Kriging
PK= predictor(AX, krig3);
PR2(i)=1-sum((AY -PK).^2) /sum((AY-mean(AY)).^2); 
RRmse3(i)=(sqrt(sum((AY-PK).^2)/size(PK,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(PK,1)-1))); % RMSE
RMAE3(i)=(max(abs(AY -PK)))/(sqrt(sum((AY-mean(AY)).^2)/(size(PK,1)-1))); % RMAE

%% The evaluation index of KPLS1-Kriging
KP1K= predictor(AX, krig4);
KP1R2(i)=1-sum((AY -KP1K).^2) /sum((AY-mean(AY)).^2); 
RRmse4(i)=(sqrt(sum((AY-KP1K).^2)/size(KP1K,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP1K,1)-1))); % RMSE
RMAE4(i)=(max(abs(AY -KP1K)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP1K,1)-1))); % RMAE

%% The evaluation index of KPLS2-Kriging
KP2K= predictor(AX, krig5);
KP2R2(i)=1-sum((AY -KP2K).^2) /sum((AY-mean(AY)).^2); 
RRmse5(i)=(sqrt(sum((AY-KP2K).^2)/size(KP2K,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP2K,1)-1))); % RMSE
RMAE5(i)=(max(abs(AY -KP2K)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP2K,1)-1))); % RMAE

%% The evaluation index of KPLS3-Kriging
KP3K= predictor(AX, krig6);
KP3R2(i)=1-sum((AY -KP3K).^2) /sum((AY-mean(AY)).^2); 
RRmse6(i)=(sqrt(sum((AY-KP3K).^2)/size(KP3K,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP3K,1)-1))); % RMSE
RMAE6(i)=(max(abs(AY -KP3K)))/(sqrt(sum((AY-mean(AY)).^2)/(size(KP3K,1)-1))); % RMAE

end