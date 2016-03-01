function [ J ] = calcJ( N,K,d,r,means )
%calcJ calculates error J according to lecture notes
%   Detailed explanation goes here
J=0;
for n=1:N
    for i=1:K
        J=J+r(n,i)*norm(d(n,:)-means(i,:))^2;  % summation for J 
    end
end

end

