function [ J,meansOut,idx ] = iteration(N,K,d,means )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Step 1
squaredNorms=zeros(K,1);  %initialise a vector of squared norm values to zeros

r=zeros(N,K);  %initialise r matrix of binary indicators

for n=1:N                %for all datapoints
    for i=1:K           %for all clusters
        squaredNorms(i)=norm(d(n,:)-means(i,:))^2;    %calc distances from all datapoints to cluster's mean
        
    end
    [minimum,index]=min(squaredNorms); 
    r(n,index)=1; 
    
end
% r now holds 1 hot notation of which pixel goes to which cluster 


idx=zeros(N,1);
for i=1:N
    for j=1:K
        if r(i,j)==1
            idx(i)=j;
        end
    end
end
idx=reshape(idx,300,500);       %this is 


%Step 2
meansOut=means;    %set value of output means
for i=1:K           
    
    numerator=zeros(1,3);
    denominator=ones(1,3);
    for n=1:N
        numerator=numerator+r(n,i)*d(n,:);
        denominator=denominator+r(n,i);
    end
    meansOut(i,:)=numerator./denominator;               %means of each cluster
    
end

%calc J 
J=calcJ(N,K,d,r,meansOut);




end

