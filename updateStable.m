function [stableEnvs,nClubsStableEnvs,nStableEnvs,stableG] = ...
    updateStable(stableEnvs,nClubsStableEnvs,nStableEnvs,stableG,membMap,config)
% Testing for isomorphism.
    options = find(nClubsStableEnvs == sum(sum(membMap,2)));
    base = cell(size(membMap,1),1);
    base(:) = {'blue'};
    base(config.Model.color == 2) = {'red'};
    iso = false;
    g_deg = sort(sum(membMap,2));
    g = graph(membMap);
    g.Nodes.Color = base;
    for i = options
        if all(g_deg == stableG{i,1})
            try
                % graph isomorphy test for color nodes graph
                if(isisomorphic(stableG{i,2},g,'NodeVariables','Color'))
                    iso = true;
                    break
                end
            catch
            end
        end
    end
    if ~iso
        nStableEnvs = nStableEnvs + 1;
        stableEnvs{nStableEnvs} = membMap;
        nClubsStableEnvs(nStableEnvs) = sum(sum(membMap,2));
        stableG(nStableEnvs,1:2) = {g_deg,g};
    end
end