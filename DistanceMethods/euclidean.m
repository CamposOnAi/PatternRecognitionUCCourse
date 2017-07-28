%function [gk] = euclidean(mk1,x1,mk2,x2)
function [gk] = euclidean(mk,x)

wk = mk';
bias =mk'*mk;% norm(mk)*norm(mk);

gk = (wk*x') -0.5* bias;

%gx1 = x1*mk1 - (1/2)*(mk1'*mk1);
%gx2 = x2*mk2 - (1/2)*(mk2'*mk2);

%gk = gx1-gx2;

%gk = (mk - x)' * (mk - x);

end