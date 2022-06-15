clc;
clear;
setdemorandstream(1);
%% p-value 
global p
p=0.1;

%% Empty matrix for storage
toc1=[]; toc2=[];
t1=[];t2=[];
RRmse1=[];RRmse2=[];
RMAE1=[];RMAE2=[];

%% 10 replicate experiments
for i=1:10
problem.f=@Bratley; % test function
[XL,XU]=Bratley_bound();  % get function bounds
bounds=[XL;XU];
problem.bounds=bounds;
dim=size(bounds,2); % Dimension
pointnum=(dim/2+5)*dim;      % The number of initial sampling points, when the function dimension is 15, set to 10*dim.

%% Initial sample points
S=LHD(XL,XU,pointnum);  % The value of the independent variable at the initial point
Y=callobj(problem.f,S); % The actual value of the function at the initial sampling point

%% Additional evaluation points
AX=LHD(XL,XU,5000);  % Independent variable values for 5000 evaluation points
AY=callobj(problem.f,AX); % Actual value of the function at the evaluation points

%% Kriging    
tic
krig1=buildKRG(S,Y);   % Kriging Modeling
toc1=toc;
t1(i)=sum(toc1);
%% Stepwise-Kriging
tic
[krig2,new_AX]=buildSKRGA(S,Y,AX,AY);   % Stepwise-Kriging Modeling
toc2=toc;
t2(i)=sum(toc2);

%% The evaluation index of the Kriging model 
K= predictor(AX, krig1); % RMSE
RRmse1(i)=(sqrt(sum((AY-K).^2)/size(K,1))) /(sqrt(sum((AY-mean(AY)).^2)/(size(K,1)-1)));
RMAE1(i)=(max(abs(AY -K)))/(sqrt(sum((AY-mean(AY)).^2)/(size(K,1)-1))); % MAE

%% The evaluation index of the S-Kriging model
SK= predictor(new_AX, krig2);
RRmse2(i)=(sqrt(sum((AY-SK).^2)/size(SK,1)))/(sqrt(sum((AY-mean(AY)).^2)/(size(SK,1)-1))); % RMSE
RMAE2(i)=(max(abs(AY -SK)))/(sqrt(sum((AY-mean(AY)).^2)/(size(SK,1)-1))); % RMAE
end 

%% CPU time
t1,t2
%% Evaluation indexes
RRmse1,RRmse2
RMAE1,RMAE2