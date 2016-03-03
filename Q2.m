%SVMStruct=svmtrain(data_train(1:100,1:2),data_train(1:100,3),'kernel_function','mlp', 'ShowPlot',true);
SVMModel = fitcsvm(data_train(1:100,1:2),data_train(1:100,3),'KernelFunction','rbf','Standardize',true,'ClassNames',{'1','2'});
sv = SVMModel.SupportVectors;
figure
gscatter(data_train(1:100,1),data_train(1:100,2),data_train(1:100,3))
hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
plot(data_train(SVMModel.IsSupportVector,1),data_train(SVMModel.IsSupportVector,2),'ko','MarkerSize',10)
supportVectors=data_train(SVMModel.IsSupportVector,1:2);
legend('versicolor','virginica','Support Vector')
hold off

figure
plot(data_train(1:100,1),data_train(1:100,2),'k.')
hold on
plot(supportVectors(:,1),supportVectors(:,2),'ro','MarkerSize',10)

h = 0.02; % Mesh grid step size
[X1,X2] = meshgrid(min(data_train(1:100,1)):h:max(data_train(1:100,1)),...
    min(data_train(1:100,2)):h:max(data_train(1:100,2)));
[~,score] = predict(SVMModel,[X1(:),X2(:)]);
scoreGrid = reshape(score,size(X1,1),size(X2,1));
contour(X1,X2,scoreGrid)

