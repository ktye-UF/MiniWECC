function varargout = construct_krig(dataset, param)
% % Input
% dataset: structure contains X and Y
% param: parameter settings
% % Output
% myKrig: trained model
% ctime_gp: CPU time
trend_type = param.trend_type;
if trend_type == "polynomial"
    trend_degree = param.trend_degree;
end
corr_fam = param.corr_fam;
if param.estimate
    estimate = param.estimate;
end
if param.opt
    opt = param.opt;
end
if param.noise_infer
    noise_infer = param.noise_infer;
end
%% krig
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'Kriging';
if param.estimate
    MetaOpts.EstimMethod = estimate;
end
if param.opt
    MetaOpts.Optim.Method = opt;
end
MetaOpts.Trend.Type = trend_type; % simple, ordinary, linear, quadratic, polynomial
if trend_type == "polynomial"
    MetaOpts.Trend.Degree = trend_degree;
end
MetaOpts.Corr.Family = corr_fam; % linear, exponential, gaussian, matern-3_2, matern-5_2
if param.noise_infer
    MetaOpts.Regression.SigmaNSQ = noise_infer;
end
MetaOpts.ExpDesign.X = dataset.X;
MetaOpts.ExpDesign.Y = dataset.Y;
% MetaOpts.Regression.SigmaNSQ = 'auto';
% MetaOpts.Corr.Type = 'separable';
% MetaOpts.Corr.Type = 'ellipsoidal';
tic
myKrig = uq_createModel(MetaOpts);
ctime_gp = toc;
%% output
varargout = {myKrig, ctime_gp};