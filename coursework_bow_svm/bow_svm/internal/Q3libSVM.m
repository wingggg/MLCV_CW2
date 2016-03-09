%Q3 script using libSVM
addpath('../external/libsvm-3.18');
[data_train, data_query]=getData('Caltech');
labels=data_train(:,end);

%we can only use svmtrain with to classes at a time. 
% We will first try one vs many.



%A) One vs Many


%training svms 
svmStructs=[];
svmPredictions=[];
data_trainTemp=data_train;
data_queryTemp=data_query;
for i=1:10 %for each class
    
    for j=1:150  %for each data sample
        
        if data_train(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0
            data_trainTemp(j,end)=1;   
        else
            data_trainTemp(j,end)=0;
        end
        
        if data_query(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0
            data_queryTemp(j,end)=1;   
        else
            data_queryTemp(j,end)=0;
        end
    end
    
    %svm goes here
    
    SVMStruct = svmtrain(data_trainTemp(:,end), data_trainTemp(:,1:end-1)); %run svm for current pair of classes
    svmStructs=[svmStructs SVMStruct]; %store in struct of svm results 
    
    [predicted_label, accuracy,prob_estimates]=svmpredict(data_queryTemp(:,end), data_queryTemp(:,1:end-1), SVMStruct);
    
%     [predicted_label, accuracy,prob_estimates]=svmpredict(data_queryTemp(:,end), [(1:150)', data_queryTemp(:,1:end-1)*data_trainTemp(:,1:end-1)'], SVMStruct);
%     SVMPredictStruct=[predicted_label, accuracy, prob_estimates];
%     svmPredictions=[svmPredictions SVMPredictStruct];
end
   
%testing the svms

%prediction



% B) One vs One 
