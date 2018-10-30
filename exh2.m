function exh2(config,color)
    tic
    nAgents = double(config.Environment.number_of_agents);
    stableEnvs = cell(1,nAgents+1);
    base_c = ones(1,nAgents);
    base_m = zeros(nAgents,nAgents);
    load([num2str(nAgents),'\new data ',num2str(nAgents),'.mat'])
    counter = 0;
    f = waitbar(counter/(length(data)*floor(nAgents/2)),'Processing');
    for i = find(color)
        if i == 1 || i == nAgents+1
            counter = counter+1;
            waitbar(counter/(length(find(color))),f,'Processing')
            for k = 1:length(data)
            tmp_m = data{k};
                for j = 1:size(tmp_m,1)
                    map = base_m;
                    map(tmp_m(j,:)) = 1;
                    map = map + map';
                    config.Model.color = base_c;
                    index = 1;
                    if i == nAgents+1
                        config.Model.color = 3-base_c;
                        index = nAgents + 1;
                    end
                    [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
                    if stability
                        if isempty(stableEnvs{index})
                            stableEnvs{index} = cell(1);
                            stableEnvs{index}(1,1:2) = {map,config.Model.color};
                        else
                            stableEnvs{index}(size(stableEnvs{index},1)+1,1:2) =...
                                {map,config.Model.color};
                        end
                    end
                end
            end
        else
            if i-1 > floor(nAgents/2)
                load([num2str(nAgents),'\color_set ',num2str(nAgents-i+1),'.mat']);
            else
                load([num2str(nAgents),'\color_set ',num2str(i-1),'.mat']);
            end
            index = i;
            for k = 1:length(data)
                counter = counter+1;
                waitbar(counter/(length(find(color))),f,'Processing')
                tmp_m = data{k};
                tmp_c = color_set{k};
                for j = 1:size(tmp_m,1)
                    map_color = tmp_c{j};
                    map = base_m;
                    map(tmp_m(j,:)) = 1;
                    map = map + map';
                    for g = 1:size(map_color,1)
                        config.Model.color = base_c;
                        config.Model.color(map_color(g,:)) = 2;
                        if i - 1 > floor(nAgents/2)
                            config.Model.color = 3- config.Model.color;
                        end
                        % checking stability
                        [stability, ~] = AnalyzeConfig(config, map,getColorMat(config));
                        if stability
                            if isempty(stableEnvs{index})
                                stableEnvs{index} = cell(1);
                                stableEnvs{index}(1,1:2) = {map,config.Model.color};
                            else
                                stableEnvs{index}(size(stableEnvs{index},1)+1,1:2) =...
                                    {map,config.Model.color};
                            end
                        end
                    end
                end
            end
        end
    end     
    saveEx2(config,stableEnvs,color)
    close(f)
    toc
end