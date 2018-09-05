function [stability, reasonStr] = AnalyzeConfig(config, membMap,colorMat)
    % Constructing the weighted connections matrix. 
    weightMat = getWeightMat(config, membMap,colorMat);
    % Testing the stability of the environment.
    [stability, reasonStr] = getStabilityYesNo(config, membMap, weightMat,colorMat);
end % function