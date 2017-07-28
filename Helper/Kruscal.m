function [p]  = Kruscal (Data,target)

sizeData = size(Data);

for i=1 : sizeData(2)
    %C = vertcat(Data(1:end,i)',target');
    p(i) = kruskalwallis(Data(1:end,i)',target','off');
end
    
end