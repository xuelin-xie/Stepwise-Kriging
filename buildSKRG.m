function Skrgmodel = buildSKRG(S,Y)
% new_S is the new independent variable (or new feature) initial points after feature selection
new_S=[];
%  Stepwise feature selection
[B,SE,PVAL,INMODEL,STATS,NEXTSTEP,HISTORY]=stepwisefit(S,Y);  %Stepwise feature selection
S1=[PVAL'; S]; %Added p-value variable for filtering
k=1;
for m=1:size(S1,2)
    if any(S1(1,m)<0.1)
        new_S(:,k)=[S1(:,m)];
        k=k+1;
    end
end

if isempty(new_S)==1;
    disp('Stepwise regression methods are currently not applicable');
    new_S=S;
    k=dim+1;
else
    new_S(1,:)=[];  %remove the added p-value variable
end

%  Build a Stepwise-Kriging based on dace
[~,dim]=size(new_S);
%Relevant conditions for Kriging
theta = 10; 
lob = 1e-1;
upb = 100;   
theta = repmat(theta, 1, dim) ;
lob = repmat(lob, 1, dim);
upb =  repmat(upb, 1, dim);
Skrgmodel =dacefit(new_S,Y,'regpoly2','corrgauss', theta, lob, upb);
return