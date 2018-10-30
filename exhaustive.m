function exhaustive(config)
% The function runs the exhaustive algorithm (works for 5 to 9 agents)
    tic
    nAgents = double(config.Environment.number_of_agents);
    stableEnvs = cell(1,nAgents+1);
    base_c = ones(1,nAgents);
    base_m = zeros(nAgents,nAgents);
    load([num2str(nAgents),'\new data ',num2str(nAgents),'.mat'])
    counter = 0;
    f = waitbar(counter/(length(data)*floor(nAgents/2)),'Processing');
    % going all over the color sizes
    % all high type and low
    for k = 1:length(data)
        tmp_m = data{k};
        for j = 1:size(tmp_m,1)
            map = base_m;
            map(tmp_m(j,:)) = 1;
            map = map + map';
            config.Model.color = base_c;
            [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
            if stability
                if isempty(stableEnvs{1})
                    stableEnvs{1} = cell(1);
                    stableEnvs{1}(1,1:2) = {map,config.Model.color};
                else
                    stableEnvs{1}(size(stableEnvs{1},1)+1,1:2) =...
                        {map,config.Model.color};
                end
            end
            config.Model.color = 3-config.Model.color;
            [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
            if stability
                if isempty(stableEnvs{nAgents+1})
                    stableEnvs{nAgents+1} = cell(1);
                    stableEnvs{nAgents+1}(1,1:2) = {map,config.Model.color};
                else
                    stableEnvs{nAgents+1}(size(stableEnvs{nAgents+1},1)+1,1:2) =...
                        {map,config.Model.color};
                end
            end
        end
    end
    for i = 1:floor(nAgents/2)
        load([num2str(nAgents),'\color_set ',num2str(i),'.mat'])
        % going over the environment sizes
        for k = 1:length(data)
            counter = counter+1;
            waitbar(counter/(length(data)*floor(nAgents/2)),f,'Processing')
            tmp_m = data{k};
            tmp_c = color_set{k};
            % going over the all the environments of a given size
            for j = 1:size(tmp_m,1)
                map_color = tmp_c{j};
                map = base_m;
                map(tmp_m(j,:)) = 1;
                map = map + map';
                % iterating over the unique coloring of the current
                % environment
                for g = 1:size(map_color,1)
                    config.Model.color = base_c;
                    config.Model.color(map_color(g,:)) = 2;
                    % checking stability
                    [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
                    if stability
                        if isempty(stableEnvs{i+1})
                            stableEnvs{i+1} = cell(1);
                            stableEnvs{i+1}(1,1:2) = {map,config.Model.color};
                        else
                            stableEnvs{i+1}(size(stableEnvs{i+1},1)+1,1:2) =...
                                {map,config.Model.color};
                        end
                    end
                    if i ~= nAgents-i
                        config.Model.color = 3-config.Model.color;
                        [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
                        if stability
                            if isempty(stableEnvs{nAgents-i+1})
                                stableEnvs{nAgents-i+1} = cell(1);
                                stableEnvs{nAgents-i+1}(1,1:2) = {map,config.Model.color};
                            else
                                stableEnvs{nAgents-i+1}(size(stableEnvs{nAgents-i+1},1)+1,1:2) =...
                                    {map,config.Model.color};
                            end
                        end
                    end
                end
            end
        end
    end
    % save results
    saveEx(config,stableEnvs)
    close(f)
    save('Ex_stable_envs.mat','stableEnvs')
    toc
end