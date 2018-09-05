function weightMat = getWeightMat(config, membMap,colorMat)
% Constructing the weighted connections matrix. 
    % building the distances matrix 
    distMat = distances(graph(membMap));
    weightMat = (config.Model.delta.^ distMat) - eye(size(membMap,1));
    % multiplying the weighted mtrix with the intrinsic value matrix.
    weightMat = weightMat .* colorMat;  
end