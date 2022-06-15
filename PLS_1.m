function [] = PLS_1()
tic;
clear;clc;
global W ;
[XL,XU]=SUR_bound(); %��ȡ�����ı߽�
bounds=[XL;XU];
problem.bounds=bounds;problem.f=@SUR;% 
%assignin('base','bound',bounds);
 dim=size(bounds,2);%ά��
 pointnum=10;%2*(dim+1);    %��ʼ������ĸ���
 S=LHD(XL,XU,pointnum);
 Y(:,1)=callobj(problem.f,S); %��ʼ������ĺ�����ֵ
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
% ����GA�㷨�Ż�MSE
x1=LHD(XL,XU,1);
%  options=optimoptions(@fmincon,'Algorithm','sqp');
% [x1,fval] = ga(@MSE,dim,[],[],[],[],XL,XU,[],[]);%�Ż�MSE�õ���SQP-fmincon
% fmincon�Ǿֲ��Ż�������������ʼ�㣬�ҵ����ʼ������ļ�Сֵ��
y1=callobj(problem.f,x1);
S=[S;x1];Y=[Y;y1]; 
end
toc;
rmse=0;
%% ��һ������֤����
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


