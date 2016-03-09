MODE='Caltech';
% Generate training and testing data

% Data Options:
%   1. Toy_Gaussian
%   2. Toy_Spiral
%   3. Toy_Circle
%   4. Caltech 101

showImg = 0; % Show training & testing images and their image feature vector (histogram representation)

PHOW_Sizes = [4 8 10]; % Multi-resolution, these values determine the scale of each layer.
PHOW_Step = 8; % The lower the denser. Select from {2,4,8,16}

switch MODE
        
    case 'Caltech' % Caltech dataset
        close all;
        imgSel = [15 15]; % randomly select 15 images each class without replacement. (For both training & testing)
        folderName = '../Caltech_101/101_ObjectCategories';
        classList = dir(folderName);
        classList = {classList(3:end).name}; % 10 classes
        
        disp('Loading training images...')
        % Load Images -> Description (Dense SIFT)
        cnt = 1;
        if showImg
            figure('Units','normalized','Position',[.05 .1 .4 .9]);
            suptitle('Training image samples');
        end
        for c = 1:length(classList)
            subFolderName = fullfile(folderName,classList{c});
            imgList = dir(fullfile(subFolderName,'*.jpg'));
            imgIdx{c} = randperm(length(imgList));
            imgIdx_tr = imgIdx{c}(1:imgSel(1));
            imgIdx_te = imgIdx{c}(imgSel(1)+1:sum(imgSel));
            
            for i = 1:length(imgIdx_tr)
                I = imread(fullfile(subFolderName,imgList(imgIdx_tr(i)).name));
                
                % Visualise
                if i < 6 && showImg
                    subaxis(length(classList),5,cnt,'SpacingVert',0,'MR',0);
                    imshow(I);
                    cnt = cnt+1;
                    drawnow;
                end
                
                if size(I,3) == 3
                    I = rgb2gray(I); % PHOW work on gray scale image
                end
                
                % For details of image description, see http://www.vlfeat.org/matlab/vl_phow.html
                [~, desc_tr{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step); %  extracts PHOW features (multi-scaled Dense SIFT)
            end
        end
        
        disp('Building visual codebook...')
        % Build visual vocabulary (codebook) for 'Bag-of-Words method'
        desc_sel = single(vl_colsubset(cat(2,desc_tr{:}), 10e4)); % Randomly select 100k SIFT descriptors for clustering
        
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % K-means clustering
        % write your own codes here
        K=5;
        
        [idx,Cmeans]=kmeans(desc_sel',K);
        %Now Cmeans is the K codewords.
        %idx describes how each of the 100k descriptors got classified into
        %the K codewords
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('Encoding Images...')
        % Vector Quantisation
        histogramsTrain=zeros(10,15,K);  % K bins for each image
        for i=1:10
            for j=1:15     %for each image
                 
                IDX = knnsearch(Cmeans,desc_tr{i,j}');   %do knn search

                 %Code below creates the histogram of a test image. IDX are its
                    %descriptor classifications


                
                for ii=1:length(IDX)   
                    for jj=1:K
                        if IDX(ii)==jj  %count how many descriptors per codeword (aka per cluster mean)
                            histogramsTrain(i,j,jj)=histogramsTrain(i,j,jj)+1;  %accumulate
                        end
                    end
                end
            end
        end
        
        histogramsTrain=reshape(histogramsTrain,150,5);
        labels=zeros(150,1);
        for i=1:10 %for each label
            for j=1:15 %for each sample
                labels()histogramsTrain(i,j,:)
              
        
        
        
        % write your own codes here
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        % data_train: [num_data x (dim+1)] Training vectors with class labels
        % data_train(:,end): class labels
        data_train = [];
        
       
        % Clear unused varibles to save memory
        %clearvars  desc_sel
end

switch MODE
    case 'Caltech'
        if showImg
        figure('Units','normalized','Position',[.05 .1 .4 .9]);
        suptitle('Testing image samples');
        end
        disp('Processing testing images...');
        cnt = 1;
        % Load Images -> Description (Dense SIFT)
        for c = 1:length(classList)
            subFolderName = fullfile(folderName,classList{c});
            imgList = dir(fullfile(subFolderName,'*.jpg'));
            imgIdx_te = imgIdx{c}(imgSel(1)+1:sum(imgSel));
            
            for i = 1:length(imgIdx_te)
                I = imread(fullfile(subFolderName,imgList(imgIdx_te(i)).name));
                
                % Visualise
                if i < 6 & showImg
                    subaxis(length(classList),5,cnt,'SpacingVert',0,'MR',0);
                    imshow(I);
                    cnt = cnt+1;
                    drawnow;
                end
                
                if size(I,3) == 3
                    I = rgb2gray(I);
                end
                [~, desc_te{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step);
            
            end
        end
    
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Vector Quantisation
        % write your own codes here
        
        histogramsTest=zeros(10,15,K);  % K bins for each image
        for i=1:10
            for j=1:15     %for each image
                 
                IDX = knnsearch(Cmeans,desc_tr{i,j}');   %do knn search

                 %Code below creates the histogram of a test image. IDX are its
                    %descriptor classifications


                
                for ii=1:length(IDX)   
                    for jj=1:K
                        if IDX(ii)==jj  %count how many descriptors per codeword (aka per cluster mean)
                            histogramsTest(i,j,jj)=histogramsTest(i,j,jj)+1;  %accumulate
                        end
                    end
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        
        
        % data_query: [num_data x (dim+1)] Testing vectors with class labels
        % data_query(:,end): class labels
        data_query = [];
        
        
        
    otherwise % Dense point for 2D toy data
        xrange = [-1.5 1.5];
        yrange = [-1.5 1.5];
        inc = 0.02;
        [x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2));
        data_query = [x(:) y(:) zeros(length(x)^2,1)];
end


