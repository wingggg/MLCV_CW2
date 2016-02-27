clearvars;
img=imread('tiger.jpg');

red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
% red=reshape(red,size(red,1)*size(red,2),1);
% green=reshape(green,size(green,1)*size(green,2),1);
% blue=reshape(blue,size(blue,1)*size(blue,2),1);
scatter3(red(:),green(:),blue(:),[],double([red(:),green(:),blue(:)])/255,'.');
xlabel('red') % x-axis label
ylabel('green') % y-axis label
zlabel('blue') %z axis


K=10; % the K factor for K clustering
N=size(img,1)*size(img,2);  

r=zeros(N,K);  %initialise r matrix of binary indicators
d=reshape(img,N,3); %data matrix. Each data point is a pixel.
d=double(d); %cast from uint8 to double

idx=kmeans(d,K); %perform kmeans clustering using matlab builtin function.


occurences = zeros(K,1);  %to calc population of each cluster
for i = 1:length(idx)
   occurences(idx(i))=occurences(idx(i))+1;
end




idx=reshape(idx,300,500); %reshape cluster labels to use in scatter function

colormap jet; % set nice colormap with distinct colors
scatter3(red(:),green(:),blue(:),[],idx(:),'.') %scatter all points in 3d, color them according to their cluster. Uses the current colormap


means=ceil(rand(K,3)*255); %the k-means points. We choose them randomly.
squaredNorms=zeros(K,1);
for n=1:N
    for i=1:K
        squaredNorms(i)=norm(d(n)-means(i))^2;
        [minimum,index]=min(squaredNorms);
        if i==index
            r(n,i)=1;
            break;
        end
        
    end
end



