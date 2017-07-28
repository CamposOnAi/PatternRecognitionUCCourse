function [data,features,target] = readDataset(path)
    [data,txt,~] = xlsread(path);
    target = data(:,end);
    data = data(:,2:end-1);
    txt = txt(:,2:end-1);
    features = txt(2,:);
end