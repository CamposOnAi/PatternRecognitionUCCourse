function [trainSet,testSet,trainTarget,testTarget ] = trainValidateTest(reducedData,target,percTrain,percTest, valRatio)
%TRAINVALIDATETEST Summary of this function goes here
%   Detailed explanation goes here

numClasses = length(unique(target));
% Get class with most instances
for i=1: numClasses
    index = find(target == i-1);
    len = length(index);
 
    sizeClasses(i) = len;
    classI{i} = index;
end %End while
minIndexClass = find(min(sizeClasses)==sizeClasses);
% In case there are multiple minimum chose first
minIndexClass = minIndexClass(1); % This is the maximum number of instances to choose

maxInstances = sizeClasses(minIndexClass);
%TODO: Change this in next assignment
[trainingInd,~,testInd] = dividerand(maxInstances,percTrain,valRatio,percTest); 

% Chose max instances from class with least amount
% Chose same number of instances from other classes
trainSet = [];
testSet = [];
trainTarget = [];
testTarget = [];
for i=1: numClasses
    tempData = reducedData(classI{i},:);
    tempTarget = target(classI{i},:);
    
    trainSet = vertcat(trainSet,tempData(trainingInd,:));    
    testSet = vertcat(testSet,tempData(testInd,:));
    trainTarget = vertcat(trainTarget,tempTarget(trainingInd,:));
    testTarget = vertcat(testTarget,tempTarget(testInd,:));
end

end

