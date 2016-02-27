% Written by Mang Shao and Tae-Kyun Kim, June 20, 2014.
% Updated by T-K Kim, Feb 07, 2016
%
% The codes are made for educational purpose only.
% 
% Some important functions:
%     
% internal functions:
% 
%     getData.m  - Generate training and testing data
% 
% external functions and libraries:
%     
%     VLFeat    - A large open source library implements popular computer vision algorithms. BSD License.
%                 http://www.vlfeat.org/index.html
%     
%     LIBSVM    - A library for support vector machines. BSD License
%                 http://www.csie.ntu.edu.tw/~cjlin/libsvm/
% 
%     mgd.m     - Generates a Multivariate Gaussian Distribution. BSD License
%                 Written by Timothy Felty
%                 http://www.mathworks.co.uk/matlabcentral/fileexchange/5984-multivariate-gaussian-distribution
% 
%     subaxis.m - Modified 'subplot' function. No BSD License
%     parseArgs.m   Written by Aslak Grinsted
%                 http://www.mathworks.co.uk/matlabcentral/fileexchange/3696-subaxis-subplot
% 
%     suptitle.m- Create a "master title" at the top of a figure with several subplots
%                 Written by Drea Thomas
% 
%     Caltech_101 image categorisation dataset
%                 L. Fei-Fei, R. Fergus and P. Perona. Learning generative visual models
%                 from few training examples: an incremental Bayesian approach tested on
%                 101 object categories. IEEE. CVPR 2004, Workshop on Generative-Model
%                 Based Vision. 2004
%                 http://www.vision.caltech.edu/Image_Datasets/Caltech101/
% ---------------------------------------------------------------------------
% 
% Under BSD Licence


% Initialisation
init;


% Select and load dataset
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}


%%%%%%%%%%%%%
% check the training data
    % data_train(:,1:2) : [num_data x dim] Training 2D vectors
    % data_train(:,3) : [num_data x 1] Label of training data, {1,2,3}
    
plot_toydata(data_train);

%%%%%%%%%%%%%
% check the testing data
    % data_test(:,1:2) : [num_data x dim] Testing 2D vectors, 2D points in the
    % uniform dense grid within the range of [-1.5, 1.5]
    % data_train(:,3) : N/A
    
scatter(data_test(:,1),data_test(:,2),'.b');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for the Caltech101 dataset for image categorisation

% Select and load dataset
%
% Caltech101 dataset: we use 10 classes, 15 images per class, randomly selected, for training, 
    % and 15 other images per class, for testing. 
%
% Feature descriptors: they are multi-scaled dense SIFT features, and their dimension is 128 
    % (for details of the descriptor, if needed, see http://www.vlfeat.org/matlab/vl_phow.html). 
    % We randomly select 100k descriptors for K-means clustering for building the visual vocabulary (due to memory issue).
%
% data_train: [num_data x (dim+1)] Training vectors with class labels
% data_train(:,end): class labels
% data_query: [num_data x (dim+1)] Testing vectors with class labels
% data_query(:,end): class labels

% Set 'showImg = 0' in getData.m if you want to stop displaying training and testing images. 
% Complete getData.m by writing your own lines of code to obtain the visual vocabulary and the bag-of-words histograms for both training and testing data. 
[data_train, data_test] = getData('Caltech');


