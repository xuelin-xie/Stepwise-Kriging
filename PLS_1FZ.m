function [] = PLS_1()
tic;
clear;clc;
global W ;
S = xlsread('FZ','A1:L10');Y = xlsread('FZ','N1:N10');
t=[];tStart = tic;R=[];
S2=S'*Y*Y'*S;
% S2=zscore(s2);
  [V D] = eig(S2);D1=diag(D);
 [m,index]=max(D1);v=V(:,index); 
W = v/norm(v);
dmodel=buildKRG(S,Y);
tEnd = toc(tStart);t=[tEnd];rmse=0;
for i=1:size(Y,1)
    S3=S;Y3=Y;
    xi=S3(i,:);yi=Y3(i);
    S3(i,:)=[];
    Y3(i)=[];
    mse = leaveOne(xi,yi,S3,Y3);
    rmse=rmse+mse;    
end
RMSE=sqrt(rmse)/size(Y,1);
R=[R;RMSE]
t1=tEnd;
S1 = xlsread('FZ','A11:L20');Y1 = xlsread('FZ','N11:N20');
for i=1:10
    a=S1(i,:);b=Y1(i,:);
    S=[S;a];Y=[Y;b];
    tStart = tic;
    S2=S'*Y*Y'*S;
%     S2=zscore(s2);
   [V D] = eig(S2);D1=diag(D);
   [m,index]=max(D1);v=V(:,index); 
   W = v/norm(v);
   dmodel=buildKRG(S,Y);
tEnd = toc(tStart);t1=tEnd+t1;
t=[t;t1]
%% 留一交叉验证方法
for i=1:size(Y,1)
    S3=S;Y3=Y;
    xi=S3(i,:);yi=Y3(i);
    S3(i,:)=[];
    Y3(i)=[];
    mse = leaveOne(xi,yi,S3,Y3);
    rmse=rmse+mse;    
end
RMSE=sqrt(rmse)/size(Y,1);
R=[R;RMSE]
end


