function[perct]=nayveBayes(dataTrain,targetTrain, dataTarget,targetTarget,fig)

tbl = fitcnb(dataTrain,targetTrain);

partitionedModel = crossval(tbl,'KFold', 5);
L = kfoldLoss(partitionedModel);
% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

% Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);


perct = testAcc(tbl,dataTarget,targetTarget,fig);