%Q3 script using libSVM
clearvars;
%addpath('../external/libsvm-3.18');
[data_train, data_query]=getData('Caltech');
labels=data_train(:,end); %extract labels from training data

%we can only use svmtrain with two classes at a time. 
% We will first try one vs many.

%One vs Many
%------------------------
%Initialise structs
svmStructs=[];    
svmPredictions=[];
prob=[];

%we use the temp variables to
data_trainTemp=data_train;
data_queryTemp=data_query;
%===========================
%Code below is to do consequent one vs rest svm trainings
for i=1:length(unique(labels)) %for each class
    for j=1:size(data_train,1)  %for each data sample
        if data_train(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0 for train data
            data_trainTemp(j,end)=1;   
        else
            data_trainTemp(j,end)=0;
        end
    end
    for j=1:size(data_query,1)   
        if data_query(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0 for query data
            data_queryTemp(j,end)=1;   
        else
            data_queryTemp(j,end)=0;
        end
    end
   
    
    bestGamma=0.2;
    bestC=10000;
    
    % [bestC, bestGamma]=gridSearch(data_trainTemp,-5,15,-15,3); %run a gridSearch with crossValidation to find the best C and gamma params
    cmd=[' -c ',num2str(bestC), ' -g ', num2str(bestGamma), ' -b 1 -t 2 -q ']; %build the arguments string for svmtrain
    SVMStruct = svmtrain(data_trainTemp(:,end), data_trainTemp(:,1:end-1),cmd); %run svm for current pair of classes
    svmStructs=[svmStructs SVMStruct]; %store results in struct of svm results 
    
    %run prediction for query data
    [predicted_label, accuracy, prob_estimates]=svmpredict(data_queryTemp(:,end), data_queryTemp(:,1:end-1), SVMStruct, '-b 1 -q'); %predict the accuracy of the current svm
    

%     [predicted_label, accuracy,prob_estimates]=svmpredict(data_queryTemp(:,end), [(1:150)', data_queryTemp(:,1:end-1)*data_trainTemp(:,1:end-1)'], SVMStruct);     SVMPredictStruct=[predicted_label, accuracy, prob_estimates];
%     svmPredictions=[svmPredictions SVMPredictStruct];

    prob=[prob prob_estimates(:,SVMStruct.Label==1)]; %append the column of probabilities that describe how much each data point is being classified as the tested class (i in loop).

    
   
%     probEstimates = [probEstimates prob_estimates];
end


%combine the one vs Rest classifications to a single multiclass list of
%labels
indices=zeros(length(prob),1);  %init the indices matrix
for i=1:length(prob)
    [~,indices(i)]=max(prob(i,:)); %find indices of maximum probs   %predicted class = indices(i)
end
multiClassLabels=indices; %now multiClassLabels holds the labels our trained svm's gave to the data


%We calculate the accuracy of our results below
accuracy=zeros(length(predicted_label),1);
for i=1:length(predicted_label)
    accuracy(i)=(multiClassLabels(i)==data_query(i,end)); %sum all the instances on which our prediction matches the test data actual label
end
percentageAccuracy=sum(accuracy)/length(predicted_label); %find the percentage of correct predictions

%Confusion matrix code below  (?) 




