function CSR(config, membMap)
% Running the CSR test without using the GUI
% config - configuration variable (using the demoConfig function)
% membMap - a symmetric 0-1 connection matrix.
    [stability, resultMessage2] = AnalyzeConfig(config,...
        membMap,getColorMat(config));
    resultMessage1 = ['The environment is '];
    if stability
        resultMessage = [resultMessage1 'STABLE'];
    else
        resultMessage = [resultMessage1 'UNSTABLE ' ,...
            resultMessage2{:}];
    end
    % save the results
    saveCSR(config,membMap,resultMessage)
end