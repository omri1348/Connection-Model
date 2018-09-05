function [stability, reasonStr] = getStabilityYesNo(config, membMap, weightMat,colorMat)
% Testing the stability of the environment described with the membMap,
% config and colorMat
    % defining variables
    stability = true;
    reasonStr = cell(1);
    cost = config.Model.club_membership_cost;
    nAgents = size(membMap,1);
    perms = nchoosek(1:nAgents,2);
    order = randperm(size(perms,1));
    % going over all agents pairs
    for index = order
        pair = perms(index,:);
        tmp = membMap;
        % remove connection
        if tmp(pair(1),pair(2)) == 1
            tmp(pair(1),pair(2)) = 0;
            tmp(pair(2),pair(1)) = 0;
            weightMat2 = getWeightMat(config, tmp,colorMat);
            for i = 1:length(pair)
                netGainAgent = sum(weightMat2(pair(i),:)) -...
                    sum(weightMat(pair(i),:)) + cost;
                if netGainAgent > eps
                    stability = false;
                    reasonStr = {['Agent No. ' num2str(pair(i))...
                        ' would benefit from breaking the connection with agent no. '...
                        num2str(pair(3-i)) '.']};
                    return;
                end
            end
        else % add connection
            tmp(pair(1),pair(2)) = 1;
            tmp(pair(2),pair(1)) = 1;
            weightMat2 = getWeightMat(config, tmp,colorMat);
            for i = 1:length(pair)
                netGainAgent = sum(weightMat2(pair(i),:)) -...
                    sum(weightMat(pair(i),:)) - cost;
                if netGainAgent <= eps
                    break
                elseif i == 2
                    stability = false;
                    reasonStr = {['Agents No. ', num2str(pair(i)), ' and No.',...
                        num2str(pair(3-i)),' would benefit from creating a connection']};
                    return;
                end % if netGainAgent <= 0
            end
        end
    end
            
end