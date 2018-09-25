function saveGen(config, stableEnvs, nClubsStableEnvs)
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
    data{11,1} = 'Processing';
    data(12,1:2) = {'Number of Generations',config.Processing.max_number_of_generations};
    data{1,4} = 'Color';
    for i = 1:config.Environment.number_of_agents
        data{1+i,4} = ['Agent ' num2str(i)];
    end
    xlswriteParams(filename, data,config.Environment.number_of_agents,...
        find(config.Model.color == 2))
    nClubsUnique = sort(unique(nClubsStableEnvs));
    for iSheet = 1:length(nClubsUnique)
        nClubs = nClubsUnique(iSheet);
        sheetName = ['nConnections = ' num2str(nClubs/2)];
        iEnvsNClubs = find(nClubsStableEnvs == nClubs);
        nEnvsInSheet = length(iEnvsNClubs);
        outputSheet = cell((nAgents+4)*nEnvsInSheet, nAgents+3);
        for iiEnv = 1:nEnvsInSheet
            iEnv = iEnvsNClubs(iiEnv);
            membMap = double(stableEnvs{iEnv});
            membMapCell = membMap2Cell(membMap);
%             membMapCell{1,size(membMapCell,2)+2} = tagMemMap(membMap);
            rowStart = (nAgents+4)*(iiEnv-1)+1;
            rowEnd = rowStart + nAgents;
            outputSheet(rowStart:rowEnd, 1:nAgents+1) = membMapCell;
        end % for iiEnv = 1:nEnvsInSheet
        xlswrite(filename, outputSheet, sheetName);
    end
end