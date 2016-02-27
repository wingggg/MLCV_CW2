clearvars;
img=imread('tiger.jpg');

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel



K=4; % the K factor for K clustering
N=size(img,1)*size(img,2);  

r=zeros(N,K);  %initialise r matrix of binary indicators
d=reshape(img,N,3); %data matrix. Each data point is a pixel.
d=double(d); %cast from uint8 to double
means=ceil(rand(K,3)*255); %the k-means points initialisations. We choose them randomly.



J=Inf;    %initialise J to max positive
%do iterations   
iterations=0;   
tempJ=0;
while J>0  %while J 
    [J,means,idx]=iteration(N,K,d,means);  %perform an iteration
    J                                  %show J
    iterations=iterations+1;           %count iteration
    if tempJ==J %if two consecutive J's are equal, we assume we reached a minimum
        break;
    end
    tempJ=J;      
    Js=J;    %collect all J's to plot later
    figure;   % overlay cluster means with actual points
    scatter3(means(:,1),means(:,2),means(:,3),[],double([means(:,1),means(:,2),means(:,3)])/255,'X'); %cluster means
    hold on;
    scatter3(red(:),green(:),blue(:),[],double([red(:),green(:),blue(:)])/255,'.');   %image points with their real color
end
iterations  %show iterations number
figure;
plot(iterations,Js,'bo');    %plot J's over iterations

scatter3(red(:),green(:),blue(:),[],idx(:),'.') %points colored according to which cluster they belong to 
hold on;
scatter3(means(:,1),means(:,2),means(:,3),[],double([means(:,1),means(:,2),means(:,3)])/255,'X'); %cluster means


