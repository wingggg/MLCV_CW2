function [ bestC, bestGamma ] = gridSearch2( data, logcBound1,logcBound2, loggBound1, loggBound2 )
folds = 5;

[C,gamma] = meshgrid(logcBound1:2:logcBound2, loggBound1:2:loggBound2);
labels=data(:,end);
%# grid search, and cross-validation
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(labels, data(:,1:end-1), ...
                    sprintf('-c %f -g %f -v %d -q', 2^C(i), 2^gamma(i), folds));
end
%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);
%# contour plot of paramter selection

contour(C, gamma, reshape(cv_acc,size(C))), colorbar
hold on
plot(C(idx), gamma(idx), 'rx')
text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

%# now you can train you model using best_C and best_gamma
bestC = 2^C(idx);
bestGamma = 2^gamma(idx);