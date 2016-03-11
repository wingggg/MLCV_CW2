%Q3 script using libSVM
addpath('../external/libsvm-3.18');
[data_train, data_query]=getData('Toy_Spiral');
labels=data_train(:,end);



% One vs One


%training svms 
svmStructs=[];
svmPredictions=[];
prob=[];
data_trainTemp=data_train;
data_queryTemp=data_query;

%Search for best parameter C 
%taken from http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f803

gs=[]  %to hold list of g values explored so we can plot them
cs=[]  %same for c
bestcv = 0;
for log2c = -5:15, %values suggested by guide from Hsu-Chang-Lin
  for log2g = -15:3,
    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(data_train(:,end), data_train(:,1:end-1), cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g; 
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv); 
    gs=[gs bestg];
    cs=[cs bestc];
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






