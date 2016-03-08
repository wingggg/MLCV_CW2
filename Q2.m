%SVMStruct=svmtrain(data_train(1:100,1:2),data_train(1:100,3),'kernel_function','mlp', 'ShowPlot',true);
SVMModel = fitcsvm(data_train(1:100,1:2),data_train(1:100,3),'KernelFunction','rbf','Standardize',true,'ClassNames',{'1','2'});
sv = SVMModel.SupportVectors;
figure
gscatter(data_train(1:100,1),data_train(1:100,2),data_train(1:100,3))
hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
plot(data_train(SVMModel.IsSupportVector,1),data_train(SVMModel.IsSupportVector,2),'ko','MarkerSize',10)
supportVectors=data_train(SVMModel.IsSupportVector,1:2);
legend('1','2','Support Vector')
hold off

figure
plot(data_train(1:100,1),data_train(1:100,2),'k.')
hold on
plot(supportVectors(:,1),supportVectors(:,2),'ro','MarkerSize',10)



