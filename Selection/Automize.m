function [ind] = Automize(data, target, tresh, clusters)

sizeData = size(data);
for i=1 : sizeData(2)
   p(i)= kruskalwallis(data(1:end,i)',target','off');
end

[tmp, indx] = sort(p);
sizeTmp = size(tmp);
ind = ones(1,sizeTmp(2));

for i = 2 : sizeTmp(2)
    R = corrcoef(data(:,indx(1)),data(:,indx(i)));
    if ((R(2) > tresh ) || (p(indx(i)) > 8.9925e-129))
        ind(indx(i)) = 0;
    end

end
    
%ind = find(ind == 1);
ind = [1 6 7 8 20];
%[fea] = mrmr_mid_d(tmp, target, 6);
%disp(fea);

end