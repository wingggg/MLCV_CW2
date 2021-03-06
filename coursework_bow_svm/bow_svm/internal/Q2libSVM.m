%Q3 script using libSVM
clearvars
%addpath('../external/libsvm-3.18');
tic
[data_train, data_query]=getData('Toy_Spiral');
labels=data_train(:,end);

%we can only use svmtrain with two classes at a time. 
% We will first try one vs many.

%A) One vs Many
%training svms 
svmStructs=[];
svmPredictions=[];
prob=[];
data_trainTemp=data_train;
data_queryTemp=data_query;





%===========================
bestGamma=8;
bestC=0.0001;
kernelType=2;
figure;
for i=1:length(unique(labels)) %for each class
    
    for j=1:length(data_train)  %for each data sample
        
        if data_train(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0 for train data
            data_trainTemp(j,end)=1;   
        else
            data_trainTemp(j,end)=0;
        end
    end
    for j=1:length(data_query)   
        if data_query(j,end)==i     %make a temp matrix with class i being 1 and all other classes being 0 for query data
            data_queryTemp(j,end)=1;   
        else
            data_queryTemp(j,end)=0;
        end
    end
    
    %svm goes here
    

    
    [bestC, bestGamma]=gridSearch(data_trainTemp,-5,15,-15,3);
    cmd=[' -c ',num2str(bestC), ' -g ', num2str(bestGamma), ' -b 1 -t 2 ']; %build the arguments tsring for svm train
    SVMStruct = svmtrain(data_trainTemp(:,end), data_trainTemp(:,1:end-1),cmd); %run svm for current pair of classes
    svmStructs=[svmStructs SVMStruct]; %store in struct of svm results 
    
    %run prediction for query data
    [predicted_label, accuracy, prob_estimates]=svmpredict(data_queryTemp(:,end), data_queryTemp(:,1:end-1), SVMStruct, '-b 1');
    
    %draw plots of training data and 1vs Rest classifications
    
    
    subplot(2,2,i);
    plot_toydata(data_train);
    hold on; % to superimpose the 1vs Rest results
    gscatter(data_query(:,1),data_query(:,2),predicted_label);
    %str = sprintf('query data classification between class %g and class %g ',i,1+mod(i+1,3));
    %title(str);
    xlabel('X dimension (no unit)');
    ylabel('Y dimension (no unit)');
    hold off;
    fig1=gcf;
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
multiClassLabels=indices;

%=======Graph for all 3 classes


X=data_train(:,1:2);
Y=data_train(:,3);
figure
gscatter(X(:,1),X(:,2),Y); % scatter plot of the data points. Color them according to their class
h = gca;
lims = [h.XLim h.YLim]; % Extract the x and y axis limits
title('{\bf Scatter Diagram of toy measurements}');
xlabel('X dimension (no unit)');
ylabel('Y dimension (no unit)');
hold on;
gscatter(data_query(:,1),data_query(:,2),multiClassLabels); %plot classified query data on top, colored according to class
hold off;
fig2=gcf;


%WRITE RESULTS

toc
fileID = fopen('Q2Results.txt','a');
fprintf(fileID,'Q2 1vRest\n');
fprintf(fileID,'C used: %f \n',bestC);
fprintf(fileID,'Gamma used: %f \n',bestGamma);
switch kernelType
    case 0
        fprintf(fileID,'Kernel used: linear \n');
    case 1
        fprintf(fileID,'Kernel used: polynomial \n');
    case 2
        fprintf(fileID,'Kernel used: rbf \n');
    case 3
        fprintf(fileID,'Kernel used: sigmoid \n');
    case 4
        fprintf(fileID,'Kernel used: precomputed kernel \n');
end
fprintf(fileID,'Time duration: %f seconds\n',toc);
fprintf(fileID,'===============================================\n');
fclose(fileID);

%SAVE FIGURES AS PNG
nameStr=['1vRest_' ,num2str(bestC), '_',num2str(bestGamma),'_',num2str(kernelType)];
nameStr1=[nameStr '_interim.png'];
saveas(fig1,nameStr1);

nameStr2=[nameStr '_final.png'];
saveas(fig2,nameStr2);




