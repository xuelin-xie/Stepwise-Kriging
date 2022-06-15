function [] = PCA()
clear;clc;tic;global W;
[XL,XU]=Michalewicz80_bound(); %获取函数的边界
bounds=[XL;XU];
problem.bounds=bounds;problem.f=@Michalewicz80;% 
%assignin('base','bound',bounds);
 dim=size(bounds,2);%维度
 pointnum=20;%2*(dim+1);    %初始采样点的个数
 S=LHD(XL,XU,pointnum);Y(:,1)=callobj(problem.f,S); %初始采样点的函数估值
%  S=S'*Y*Y'*S;
%  S1=zscore(S);
%  [coeff,score,latent,tsquare] = pca(S1);
%  latent';
% k=(100*latent/sum(latent))';
% S2=S1*coeff(:,1:4);W=coeff(:,1:1);
%% 
for i=1:180
%     S1=zscore(S);
%     s1=S1'*S1;
%     [V D] = eig(s1);D1=diag(D);
%    [m,index]=sort(D1,'descend');v1=V(:,index); 
%    W=v1(:,1:2);
 [coeff] = pca(S );
  W=coeff(:,1:2);
dmodel=buildKRG(S,Y);
% dmodel=aresbuild(S, Y);
assignin('base','dmodel',dmodel);
[m n] = size(S);
% 利用GA算法优化MSE
%  options=optimoptions(@fmincon,'Algorithm','sqp');
x1=LHD(XL,XU,1);
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

