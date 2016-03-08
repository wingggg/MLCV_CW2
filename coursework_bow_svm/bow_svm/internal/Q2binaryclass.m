%script of Q2.

clearvars;
[data_train, data_test] = getData('Toy_Spiral');

%changed for binary-class
X = data_train(1:100,1:2);
Y = data_train(1:100,3);

figure
gscatter(X(:,1),X(:,2),Y); % scatter plot of the data points. Color them according to their class
h = gca;
lims = [h.XLim h.YLim]; % Extract the x and y axis limits
title('{\bf Scatter Diagram of toy measurements}');
xlabel('X dimension (no unit)');
ylabel('Y dimension (no unit)');

%changed for binary-class
SVMModels = cell(2,1);
classes = unique(Y);
rng(1); % For reproducibility

for j = 1:numel(classes);
    indx = (Y==classes(j)); % Create binary classes for each classifier
    SVMModels{j} = fitcsvm(X,indx,'ClassNames',[false true],'Standardize',true,...
        'KernelFunction','rbf','BoxConstraint',1);
end

d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
N = size(xGrid,1);
Scores = zeros(N,numel(classes));

for j = 1:numel(classes);
    [~,score] = predict(SVMModels{j},xGrid);
    Scores(:,j) = score(:,2); % Second column contains positive-class scores
end

[~,maxScore] = max(Scores,[],2);

figure
%changed for binary-class
h(1:2) = gscatter(xGrid(:,1),xGrid(:,2),maxScore,...
    [1 0.5 0.5; 0.5 1 0.5]);
hold on
h(4:6) = gscatter(X(:,1),X(:,2),Y);
title('{\bf Scatter Diagram of toy measurements}');
xlabel('X dimension (no unit)');
ylabel('Y dimension (no unit)');
legend(h,{'class 1 region','class 2 region','class 3 region',...
    'observed class 1','observed class 2','observed class 3'},...
    'Location','Northwest');
axis tight
hold off

