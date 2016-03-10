%Q3 script using libSVM
addpath('../external/libsvm-3.18');
[data_train, data_query]=getData('Toy_Spiral');
labels=data_train(:,end);

%graph the things
X=data_train(:,1:2);
Y=data_train(:,3);

figure
gscatter(X(:,1),X(:,2),Y); % scatter plot of the data points. Color them according to their class
h = gca;
lims = [h.XLim h.YLim]; % Extract the x and y axis limits
title('{\bf Scatter Diagram of toy measurements}');
xlabel('X dimension (no unit)');
ylabel('Y dimension (no unit)');


%we can only use svmtrain with to classes at a time. 
% We will first try one vs many.



%A) One vs Many


%training svms 
svmStructs=[];
svmPredictions=[];
prob=[];
data_trainTemp=data_train;
data_queryTemp=data_query;
for i=1:length(unique(labels)) %for each class
    
    for j=1:length(data_train)  %for each data sample
        
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
    
    SVMStruct = svmtrain(data_trainTemp(:,end), data_trainTemp(:,1:end-1),'-c 1 -g 0.2 -b 1'); %run svm for current pair of classes
    svmStructs=[svmStructs SVMStruct]; %store in struct of svm results 
    
    [predicted_label, accuracy, prob_estimates]=svmpredict(data_queryTemp(:,end), data_queryTemp(:,1:end-1), SVMStruct, '-b 1');
%     [predicted_label, accuracy,prob_estimates]=svmpredict(data_queryTemp(:,end), [(1:150)', data_queryTemp(:,1:end-1)*data_trainTemp(:,1:end-1)'], SVMStruct);     SVMPredictStruct=[predicted_label, accuracy, prob_estimates];
%     svmPredictions=[svmPredictions SVMPredictStruct];

    prob=[prob prob_estimates(:,SVMStruct.Label==1)]; %append the column of probabilities that describe how much each data point is being classified as the tested class (i in loop).

%     probEstimates = [probEstimates prob_estimates];
end

indices=zeros(length(prob),1);  %init the indices matrix
for i=1:length(prob)
    [~,indices(i)]=max(prob(i,:)); %find indices of maximum probs   %predicted class = indices(i)
end



% for i=1:3
%     prob(:,i)=probEstimates(i)prob_estimates(:,svmStructs(1,i).Label==1);
% end

%%Code to assign class to 

   
%testing the svms

%prediction



% B) One vs One 
