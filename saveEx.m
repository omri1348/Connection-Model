function saveEx(config,stableEnvs)
    [file,path] = uiputfile('.xlsx');
    filename = [path,file];
    nAgents = config.Environment.number_of_agents;
    data = cell(max(14,size(nAgents,1)+2),5);
    data{1,1} = 'Model';
    data(2,1:2) = {'Partnership Cost',config.Model.club_membership_cost};
    data(3,1:2) = {'Delta',config.Model.delta};
    data(4:6,1:2) = {'w^h_h',config.Model.w(1);...
        'w^h_l',config.Model.w(2);'w^l_l',config.Model.w(3)};
    data{8,1} = 'Environment';
    data(9,1:2) = {'Number of Agents',config.Environment.number_of_agents};
    exWriteParams(filename, data)
    % write the environments
    for i = 1:length(stableEnvs)
        exWriteEnvs(filename,stableEnvs{i},i,nAgents);
    end

end