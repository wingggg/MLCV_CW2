
[data_train, data_query]=getData('Caltech');
model = svmtrain(data_train(:,end), data_train(:,1:end-1));