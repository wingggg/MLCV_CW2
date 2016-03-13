function [ bestc, bestg ] = gridSearch( data, logcBound1,logcBound2, loggBound1, loggBound2 )
%GridSearch Search for best parameter C
%   use crossvalidation


%Search for best parameter C 
%taken from http://www.csie.ntu.edu.tw/~cjlin/libsvm/faq.html#f803

gs=[]  %to hold list of g values explored so we can plot them
cs=[]  %same for c
bestcv = 0;
for log2c = logcBound1:logcBound2, %values suggested by guide from Hsu-Chang-Lin
  for log2g = loggBound1:loggBound2,
    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = svmtrain(data(:,end), data(:,1:end-1), cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g; 
    end
    fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv); 
    gs=[gs bestg];
    cs=[cs bestc];
  end
end


end

