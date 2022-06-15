function [] = PLS_3()
tic;
clear;clc;global W ;
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
    S=zscore(S);
s1=S'*Y*Y'*S;[V D] = eig(s1);D1=diag(D);
[m,index]=max(D1);v=V(:,index); W1 = v/norm(v)
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


