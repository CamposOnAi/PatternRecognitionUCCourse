function [newX] = standardization(x)
avg = mean(x);
stdDev = std(x);
[len,ndim] = size(x);

for i=1:ndim
   newX(:,i) = (x(:,i)-avg(i))./stdDev(i);
end
