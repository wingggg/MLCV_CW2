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
    figure;   % overlay cluster means with actual points
    scatter3(means(:,1),means(:,2),means(:,3),[],double([means(:,1),means(:,2),means(:,3)])/255,'X'); %cluster means
    hold on;
    scatter3(red(:),green(:),blue(:),[],idx(:),'.')
end
iterations  %show iterations number
figure;
plot(1:length(Js),Js,'bo');    %plot J's over iterations
xlabel('Iterations') % x-axis label
ylabel('J') % y-axis label

figure;
scatter3(red(:),green(:),blue(:),[],idx(:),'.') %points colored according to which cluster they belong to 
xlabel('red') % x-axis label
ylabel('green') % y-axis label
zlabel('blue') %z axis
hold on;
scatter3(means(:,1),means(:,2),means(:,3),[],'black','X'); %cluster means


