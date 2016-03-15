%Q3 script using libSVM
addpath('../external/libsvm-3.18');
tic %to time it
[data_train, data_query]=getData('Toy_Spiral');
labels=data_train(:,end);



% One vs One


%training svms 
svmStructs=[];
svmPredictions=[];
prob=[];



classData={};
for i=1:length(unique(labels))
    thisClassData=data_train(data_train(:,3)==i,1:2);
    classData=[classData thisClassData];   
end


%cell array classData holds separately the train data for label 1,
%label 2 , label 3... label K, so we can then match them one to one.
svmStructs=[]
flag=1;
kernelType=2;  %type svmtrain in command line for info
bestC=10000;
bestGamma=0.2;
for i=1:length(unique(labels))
    labels1(1:length(classData{i}))=i;
    labels2(1:length(classData{i}))=1+mod(i+1,3);
    labels=[labels1 labels2]';
    tempTrainData=[classData{i} ; classData{1+mod(i+1,3)}];
    
    
   % if flag==1
        [bestC, bestGamma]=gridSearch(tempTrainData,-5,15,-15,3);
       % flag=0;
    %end
    cmd=[' -c ',num2str(bestC), ' -g ', num2str(bestGamma), ' -b 1 -t ',num2str(kernelType),' -q'];
    altCmd=[' -c 500 -g 1 -b 1 -t 2 -q'];
    SVMStruct = svmtrain(labels,tempTrainData,cmd);
    svmStructs=[svmStructs SVMStruct];
    
    [predicted_label, accuracy, prob_estimates]=svmpredict(data_query(:,end), data_query(:,1:end-1), SVMStruct, '-b 1 q');

    
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
    fig1=gcf;
    
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
hold off;
fig2=gcf;
%WRITE RESULTS TO TXT FILE
toc
fileID = fopen('Q2Results.txt','a');
fprintf(fileID,'Q2 1v1\n');
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
nameStr=['1v1_' ,num2str(bestC), '_',num2str(bestGamma),'_',num2str(kernelType)];
nameStr1=[nameStr '_interim.png'];
saveas(fig1,nameStr1);

nameStr2=[nameStr '_final.png'];
saveas(fig2,nameStr2);



