function membMapCell = membMap2Cell(membMap)
    [nAgents, ~] = size(membMap);
    membMapCell = cell(nAgents+1,nAgents+1);
    for iAgent = 1:nAgents
        membMapCell(iAgent+1,1) = {['Agent ' num2str(iAgent)]};
        membMapCell(1,iAgent+1) = {['Agent ' num2str(iAgent)]};
    end % for iAgent = 1:nAgents
    membMapCell(2:end,2:end) = num2cell(membMap);
    %     cell2Store = [cell2Store ; cell(3,nClubs+1) ; membMapCell];
end