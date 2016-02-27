function [ J,meansOut ] = iteration(N,K,d,means )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%Step 1
squaredNorms=zeros(K,1);  %initialise a vector of squared norm values to zeros

r=zeros(N,K);  %initialise r matrix of binary indicators

for n=1:N                %for all datapoints
    for i=1:K           %for all clusters
        squaredNorms(i)=norm(d(n)-means(i))^2;    %calc distances from all datapoints to cluster's mean
        
    end
    [minimum,index]=min(squaredNorms); 
    r(n,index)=1; 
    
end
% r now holds 1 hot notation of which pixel goes to which cluster 

%Step 2
meansOut=means;
for i=1:K
    
    numerator=0;
    denominator=0;
    for n=1:N
        numerator=numerator+r(n,i)*d(n);
        denominator=denominator+r(n,i);
    end
    meansOut(i)=numerator/denominator;
    
end

%calc J 
J=calcJ(N,K,d,r,means);




end

