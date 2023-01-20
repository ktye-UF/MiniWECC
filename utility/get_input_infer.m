function varargout = get_input_infer(X, opt_infer)
% % Input
% X: n_sample * m_dimension, data to be inferred
% opt_infer: parameter settings
% % Output
% Input_infer: inferred distribution
% ctime_infer: CPU time
%%
% unpack
v2struct(opt_infer)
% infer
tic
Input_infer = uq_fit(X, marginal_type, copula_type, family);
ctime_infer = toc;
% output
varargout = {Input_infer, ctime_infer};