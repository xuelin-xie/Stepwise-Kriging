function [] = PLS_1()
tic;
clear;clc;
global W ;
[XL,XU]=SUR_bound(); %获取函数的边界
bounds=[XL;XU];
problem.bounds=bounds;problem.f=@SUR;% 
%assignin('base','bound',bounds);
 dim=size(bounds,2);%维度
 pointnum=10;%2*(dim+1);    %初始采样点的个数
 S=LHD(XL,XU,pointnum);
 Y(:,1)=callobj(problem.f,S); %初始采样点的函数估值
%% 
for i=1:90
     s1=S'*Y*Y'*S;
     S1=zscore(s1);
  [V D] = eig(S1);D1=diag(D);
 [m,index]=max(D1);v=V(:,index); 
W = v/norm(v);
dmodel=buildKRG(S,Y);
assignin('base','dmodel',dmodel);
[m n] = size(dmodel.S);
% 利用GA算法优化MSE
x1=LHD(XL,XU,1);
%  options=optimoptions(@fmincon,'Algorithm','sqp');
% [x1,fval] = ga(@MSE,dim,[],[],[],[],XL,XU,[],[]);%优化MSE得到点SQP-fmincon
% fmincon是局部优化函数，给定初始点，找到离初始点最近的极小值点
y1=callobj(problem.f,x1);
S=[S;x1];Y=[Y;y1]; 
end
toc;
rmse=0;
%% 留一交叉验证方法
for i=1:size(Y,1)
    S2=S;Y2=Y;
    xi=S2(i,:);yi=Y2(i);
    S2(i,:)=[];
    Y2(i)=[];
    mse = leaveOne(xi,yi,S2,Y2);
    rmse=rmse+mse;    
end
RMSE=sqrt(rmse)/size(Y,1);
end


