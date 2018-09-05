function genetic(config)
% The function runs the genetic algorithm on a config variable (must include
% config.Processing.max_number_of_generations)
    tic
    % setting variables
    maxNumGenerations = config.Processing.max_number_of_generations;
    nAgents = double(config.Environment.number_of_agents);
    maxNumOfSteps = nAgents^2;
    stableEnvs = cell(1);
    stableG = cell(1,2);
    nClubsStableEnvs = [];
    nStableEnvs = 0; % number of stable environments found.
    gen = 0;
    colorMat = getColorMat(config);
    % Create new environment randomally
    membMap = randomMap(nAgents);
    % Creating progress bar
    f = waitbar(gen/maxNumGenerations,'Processing');
    while gen < maxNumGenerations
        waitbar(gen/maxNumGenerations,f,['Processing...',num2str(maxNumGenerations-gen),...
            ' Generations Left'])
        [stability, reasonStr] = AnalyzeConfig(config, membMap,colorMat);
        gen = gen+1;
        search4Membmap = true;
        step = 1;
        while search4Membmap
            if ~stability && step < maxNumOfSteps
                % set the map according to the current deviation 
                membMap = setDeviation(reasonStr,membMap);
                step = step + 1;              
                [stability, reasonStr] = AnalyzeConfig(config, membMap,colorMat);
            else
                if stability
                    % checking for isomorphism
					[stableEnvs,nClubsStableEnvs,nStableEnvs,stableG] = ...
                        updateStable(stableEnvs,nClubsStableEnvs,...
                        nStableEnvs,stableG,membMap,config);
                end    
                % Create new environment randomally:
                membMap = randomMap(nAgents);
                search4Membmap = false;
            end
        end           
    end
    close(f)
    % save results 
    saveGen(config, stableEnvs, nClubsStableEnvs);
    save('gen_stable_envs.mat','stableEnvs')
    toc
end