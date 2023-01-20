%% introduction
% % This demo is to compare copula inference results based on 720 samples and 360 samples
% % inference is used to generate more data of similar structure when 720 samples are considerred not enough
clearvars
addpath(genpath(pwd))
seed = 1;
rng(seed)
%% prepare data
% load necessary data, including load & gen values
load('save/data_all', 'data_gen', 'data_load', 'mpc');   % data_gen, data_load, mpc
% X: Input data to be inferred, dim: n_sample * (n_load + n_gen)
X = [data_load.value, data_gen.value];  
%% copula inference using 720 samples
disp('------   create input distribution model...   ------')
% Note: it may take a few minutes, you may load pre-inferred 'InputHat' from './save/Input_infer')
load_distribution = 1;  % 1 means load pre-inferred; 0 means to infer a new one
if load_distribution
    disp('Loading Input distribution...')
    load('save/Input_infer')
    disp('Loading Input distribution...done!')
else
    % % inference parameter setting
    marginal_type = 'ks';   % kernel density estimation
    copula_type = 'auto';
    family = 'auto';
    opt_infer = v2struct(marginal_type, copula_type, family);
    % % copula inference 
    % X: data to be inferred; opt_infer: parameter settings
    % InputHat: inferred distribution
    disp('Inferring input distribution...')
    [InputHat, ctime_infer] = get_input_infer(X, opt_infer);
    disp('Inferring input distribution...done!')
    % save('save/Input_infer', 'InputHat', 'opt_infer', 'ctime_infer')
end
% % generate sample based on inferred distribution
n_test = 1000;  % number of sample to be generated
disp('------   Generating samples...   ------')
X_test = uq_getSample(InputHat, n_test);
disp('Generating samples...done!')
%% copula inference using 360 samples
disp('------   create input distribution model...   ------')
% % Error: 360 samples may not be sufficient for copula type inference, 
% so the copul_type is set to be independent, this will no affect margianl inference
X_half = datasample(X, 360, 'Replace', false);
% Similarly, you may load pre-inferred 'InputHat_360' from './save/Input_infer_360')
load_distribution = 1;  % 1 means load pre-inferred; 0 means to infer a new one
if load_distribution
    disp('Loading Input distribution...')
    load('save/Input_infer_360')
    disp('Loading Input distribution...done!')
else
    % % inference parameter setting
    marginal_type = 'ks';   % kernel density estimation
    copula_type = 'Independent';    % 'Independent' means assume no correlation between inputs
    family = 'auto';
    opt_infer = v2struct(marginal_type, copula_type, family);
    % % copula inference 
    % X: data to be inferred; opt_infer: parameter settings
    % InputHat: inferred distribution; ctime_infer: CPU time
    disp('Inferring input distribution...')
    [InputHat_360, ctime_infer] = get_input_infer(X_half, opt_infer);
    disp('Inferring input distribution...done!')
    % save('save/Input_infer_360', 'InputHat_360', 'opt_infer', 'ctime_infer')
end
% % generate sample based on inferred distribution
disp('------   Generating samples...   ------')
X_test_360 = uq_getSample(InputHat_360, n_test);
disp('Generating samples...done!')
%% compare margianl inference: histogram of X and inferred X and inferred X_360
% % idx_hist: which dimension of X to be compared, totally 265
idx_hist = [1:40:265];
for i=1:length(idx_hist)
    figure; hold on;
    histogram(X(:,idx_hist(i)), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    histogram(X_test(:,idx_hist(i)), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    histogram(X_test_360(:,idx_hist(i)), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    legend('Original 720 samples', 'Inferred distribution 720 samples', 'Inferred distribution 360 samples')
    xlabel('P/Q (MW/MVAr)'); ylabel('Probability density');
    title(['Histogram of X and inferred X_{720} and X_{360} at dimension ', num2str(idx_hist(i))])
end
%% compare using Kullback–Leibler divergence
disp('------   Calculating KL divergence...   ------')
% % KL divergence is used to measure the distance between two distributions
% % for KL divergence value, the smaller, the closer (distribution more similar)
% % get probability of X and X_test and X_test_360
nbin = 100;
idx_kl = 1;
figure; hold on;
h = histogram(X(:,idx_kl), nbin, 'Normalization', 'probability', 'FaceAlpha', 0.8);
p_x = h.Values;
h1 = histogram(X_test(:,idx_kl), nbin, 'Normalization', 'probability', 'FaceAlpha', 0.8);
p_x_test = h1.Values;
h2 = histogram(X_test_360(:,i), nbin, 'Normalization', 'probability', 'FaceAlpha', 0.8);
p_x_test_360 = h2.Values;
close()
% % calculate kldiv
KL_1 = kldiv(p_x, p_x_test, 'sym');
KL_2 = kldiv(p_x, p_x_test_360, 'sym');
disp(['KL divergence between X and X_test is: ', num2str(mean(KL_1))])
disp(['KL divergence between X and X_test_360 is: ', num2str(mean(KL_2))])




