function membMap = setDeviation(reasonStr,membMap)
    % membMap2 is the new environment that may be used in the next generation.
    if ~iscell(reasonStr)
        reasonStr = {reasonStr};
    end    
    reasonStr = reasonStr{1}; % Extract reasonStr string from cell.
    numsInStr = str2num(regexprep(reasonStr,'[a-zA-Z\.]','')); % Extract the numbers from reasonStr.
    if contains(reasonStr, 'breaking') % The reason is that an agent would benefit from joining an existing club.
        membMap(numsInStr(1),numsInStr(2)) = 0; 
        membMap(numsInStr(2),numsInStr(1)) = 0;
    elseif contains(reasonStr, 'creating') % Te reason is that an agent would benefit from leaving an existing club.
        membMap(numsInStr(1),numsInStr(2)) = 1; 
        membMap(numsInStr(2),numsInStr(1)) = 1;
    end