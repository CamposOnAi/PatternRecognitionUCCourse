%Based on:
%   Copyright by Quan Wang, 2011/05/10
%   Please cite: Quan Wang. Kernel Principal Component Analysis and its 
%   Applications in Face Recognition and Active Shape Models. 
%   arXiv:1207.3538 [cs.CV], 2012. 
function [eigValue,eigVector] = eigenAnalysis(X)
    Sx=cov(X);
    [V,D]=eig(Sx);
    eigValue=diag(D);
    [eigValue,IX]=sort(eigValue,'descend');
    eigVector=V(:,IX);
end