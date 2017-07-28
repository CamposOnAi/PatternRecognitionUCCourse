function [perct] = testAcc(tbl,dataTarget,targetTarget,fig)

[label,~,Cost] = predict(tbl,dataTarget);

totalData = size(dataTarget);
tmp = size(find(label == targetTarget));

perct = tmp(1)/totalData(1);

if fig == true
    [X,Y] = perfcurve(targetTarget,Cost(:,1),'1');
    figure;
    plot(X,Y)
    xlabel('False positive rate'); ylabel('True positive rate')
    title('ROC for classification by naïve Bayes')

    figure;
    plotconfusion(targetTarget',label');
end