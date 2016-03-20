clearvars;
img=imread('tiger.jpg');

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel



K=5; % the K factor for K clustering
tic;
N=size(img,1)*size(img,2);
r=zeros(N,K);  %initialise r matrix of binary indicators
d=reshape(img,N,3); %data matrix. Each data point is a pixel.
d=double(d); %cast from uint8 to double
means=ceil(rand(K,3)*255); %the k-means points initialisations. We choose them randomly.        



    J=Inf;    %initialise J to max positive
    %do iterations   
    iterations=0;   
    tempJ=0;
    Js=[];
    while J>0  %while J >0
        [J,means,idx]=iteration(N,K,d,means);  %perform an iteration
        J                                  %show J
        iterations=iterations+1;           %count iteration
        iterations
        if tempJ==J %if two consecutive J's are equal, we assume we reached a minimum
            break;
        end
        tempJ=J; 
    %     if iterations>60
    %         break;
    %     end
        Js=[Js,J];    %collect all J's to plot later
    %     if mod(iterations,10)==0
    %         figure;   % overlay cluster means with actual points
    %         scatter3(means(:,1),means(:,2),means(:,3),[],double([means(:,1),means(:,2),means(:,3)])/255,'X'); %cluster means
    %         hold on;
    %         scatter3(red(:),green(:),blue(:),[],idx(:),'.')
    %     end
    end
    iterations  %show iterations number
    figure;
    plot(1:length(Js),Js,'bO:');    %plot J's over iterations
    xlabel('Iteration number') % x-axis label
    ylabel('J') % y-axis label

    JPlot=gcf; 
    
    figure;
    semilogy(1:length(Js),Js,'bO:');    %plot J's over iterations
    xlabel('Iteration number') % x-axis label
    ylabel('log(J)') % y-axis label

    JLogPlot=gcf;

    figure;
    scatter3(red(:),green(:),blue(:),[],idx(:),'.') %points colored according to which cluster they belong to 
    xlabel('red') % x-axis label
    ylabel('green') % y-axis label
    zlabel('blue') %z axis
    hold on;
    scatter3(means(:,1),means(:,2),means(:,3),[],'black','X'); %cluster means
    scatterPlot=gcf;

    %WRITE RESULTS

    toc
    fileID = fopen('Q1Results.txt','a');
    fprintf(fileID,'Q1 \n');
    fprintf(fileID,'K used: %d \n',K);
    fprintf(fileID,'Total number of iterations : %d \n',iterations);
    fprintf(fileID,'Iteration number |  J \n');
    for i=1:length(Js)

        fprintf(fileID,'%d |  %.2f \n',i,Js(i));
    end
    fprintf(fileID,'Time duration: %f seconds\n',toc);
    fprintf(fileID,'===============================================\n');
    fclose(fileID);

    %SAVE FIGURES AS PNG
    nameStr=['K' ,num2str(K), '_it',num2str(iterations)];
    nameStr1=[nameStr '_Jplot.png'];
    saveas(JPlot,nameStr1);

    nameStr2=[nameStr '_scatter.png'];
    saveas(scatterPlot,nameStr2);
    
    nameStr3=[nameStr '_JlogPlot.png'];
    saveas(JLogPlot,nameStr3);




