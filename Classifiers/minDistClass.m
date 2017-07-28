function [plotTarget,plotOutput] = minDistClass(trainSet,trainTarget,testSet,testTarget,distance,plot )
%MINDISTCLASS Summary of this function goes here
%   Detailed explanation goes here

% Trainning 
% Computing average point of each class
numClasses = length(unique(trainTarget));
for i=1: numClasses
   avgPt{i} = mean(trainSet(find(trainTarget==(i-1)),:));
   varPt{i} = cov(trainSet(find(trainTarget==(i-1)),:));
end

% Below is only binary
% Testing
plotTarget = zeros(numClasses,length(testSet));
plotOutput = zeros(numClasses,length(testSet));
for i=1:length(testSet)
    
    if distance == 2
        firstClass = euclidean(avgPt{1}',testSet(i,:));
        secndClass = euclidean(avgPt{2}',testSet(i,:));
    elseif distance == 3
        firstClass = Mahalanobis(avgPt{1}',testSet(i,:),varPt{1});
        secndClass = Mahalanobis(avgPt{2}',testSet(i,:),varPt{2});
    else
        firstClass = euclidean(avgPt{1}',testSet(i,:));
        secndClass = euclidean(avgPt{2}',testSet(i,:));
    end
    
    dista =  firstClass - secndClass;   
    
    if dista <= 0
        predict = 0;
    else
        predict = 1;
    end % End if
    %Roc plot && Confusion Matrix
    plotTarget(:,i) = [firstClass secndClass]';
    if(testTarget(i) == 0)
       plotOutput(:,i) = [1 0]';
    else
        plotOutput(:,i) = [0 1]';
    end
    
end % End for

if plot == true
    warning('off','all');
    figure
    plotconfusion(plotTarget,plotOutput);
end %end if
%figure
%plotroc(plotTarget,plotOutput);

end

