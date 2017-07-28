function [gk] = Mahalanobis(mk,x,s_qua)

wk = inv(s_qua)*mk;
bias = mk';

gk = (wk'*x') -0.5* bias * inv(s_qua)*mk;

end