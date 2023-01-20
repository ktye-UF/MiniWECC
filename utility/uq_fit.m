function InputHat = uq_fit(Y, marginal_type, copula_type, families)
iOpts.Inference.Data = Y;
for i=1:size(Y,2)
    iOpts.Marginals(i).Type = marginal_type;
end

iOpts.Copula.Type = copula_type;    % 'Pair', 'Copula'
% iOpts.Copula.Inference.CVineStructure = [1,2,3];
iOpts.Copula.Inference.PCfamilies = families;   % 'Clayton', 'Clayton', 'Clayton'
iOpts.Copula.Inference.pcfam = families;

InputHat = uq_createInput(iOpts);
end