clearvars;
img=imread('tiger.jpg');

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel



K=10; % the K factor for K clustering
N=size(img,1)*size(img,2);  

r=zeros(N,K);  %initialise r matrix of binary indicators
d=reshape(img,N,3); %data matrix. Each data point is a pixel.
d=double(d); %cast from uint8 to double
means=ceil(rand(K,3)*255); %the k-means points initialisations. We choose them randomly.


%calc J 
J=Inf;
%do iterations
iterations=0;
tempJ=0;
while J>10
    [J,means]=iteration(N,K,d,means);
    J
    iterations=iterations+1;
    if tempJ==J
        break;
    end
    tempJ=J;
    figure;
    scatter3(means(:,1),means(:,2),means(:,3),[],double([means(:,1),means(:,2),means(:,3)])/255,'X');
    hold on;
    scatter3(red(:),green(:),blue(:),[],double([red(:),green(:),blue(:)])/255,'.');
end
iterations



