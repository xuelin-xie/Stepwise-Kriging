function krgmodel = buildKRG(S,Y)
%  Build a surrogate function based on Kriging Functions
[~,dim]=size(S);
theta = 10; 
lob = 1e-1;
upb = 100;   
theta = repmat(theta, 1, dim) ;
lob = repmat(lob, 1, dim);
upb =  repmat(upb, 1, dim);
% krgmodel =dacefit(S, Y, @regpoly0, @corrgauss, theta, lob, upb);
krgmodel =dacefit(S,Y,'regpoly2','corrgauss', theta, lob, upb);
return
