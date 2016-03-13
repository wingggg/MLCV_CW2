%Q3 script using libSVM
addpath('../external/libsvm-3.18');
[data_train, data_query]=getData('Toy_Spiral');
labels=data_train(:,end);



% One vs One


%training svms 
svmStructs=[];
svmPredictions=[];
prob=[];


%Search for best parameter C 
%taken from http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f803


bestcv = 0;
for log2c = -5:15, %values suggested by guide from Hsu-Chang-Lin
  for log2g = -15:3,
    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(data_train(:,end), data_train(:,1:end-1), cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g; 

    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv); 
    
  end
end


%===========================

classData={};
for i=1:length(unique(labels))
    thisClassData=data_train(data_train(:,3)==i,1:2);
    classData=[classData thisClassData];   
end


%cell array classData holds separately the train data for label 1,
%label 2 , label 3... label K, so we can then match them one to one.
svmStructs=[]
for i=1:length(unique(labels))
    labels1(1:length(classData{i}))=i;
    labels2(1:length(classData{i}))=1+mod(i+1,3);
    labels=[labels1 labels2]';
    tempTrainData=[classData{i} ; classData{1+mod(i+1,3)}];
    cmd=[' -c ',num2str(bestc), ' -g ', num2str(bestg), ' -b 1 -t 2 '];
    altCmd=[' -c 500 -g 1 -b 1 -t 2 '];
    SVMStruct = svmtrain(labels,tempTrainData,altCmd);
    svmStructs=[svmStructs SVMStruct];
    
    [predicted_label, accuracy, prob_estimates]=svmpredict(data_query(:,end), data_query(:,1:end-1), SVMStruct, '-b 1');
    
    prob=[prob prob_estimates(:,SVMStruct.Label==i)]; %append the column of probabilities that describe how much each data point is being classified as the tested class (i in loop).

    
    subplot(2,2,i);
    plot_toydata(data_train);
    hold on; % to superimpose the 1vs Rest results
    gscatter(data_query(:,1),data_query(:,2),predicted_label);
    str = sprintf('query data classification between class %g and class %g ',i,1+mod(i+1,3));
    title(str);
    xlabel('X dimension (no unit)');
    ylabel('Y dimension (no unit)');
    hold off;
    
    
end

indices=zeros(length(prob),1);  %init the indices matrix
for i=1:length(prob)
    [~,indices(i)]=max(prob(i,:)); %find indices of maximum probs   %predicted class = indices(i)
end
multiClassLabels=indices;

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

