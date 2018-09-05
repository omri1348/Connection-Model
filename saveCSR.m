function saveCSR(config,membMap,msg)
% The function output the results of the CSR procedure to a .xlsx file
    [file,path] = uiputfile('.xlsx');
    filename = [path,file];
    data = cell(max(20,size(membMap,1)+7),4+size(membMap,1));
    data{1,1} = 'Model';
    data(2,1:2) = {'Membership Cost',config.Model.club_membership_cost};
    data(3,1:2) = {'Delta',config.Model.delta};
    data(4:6,1:2) = {'w_1',config.Model.w(1);...
        'w_2',config.Model.w(2);'w_3',config.Model.w(3)};
    data{8,1} = 'Environment';
    data(9,1:2) = {'number of Agents',config.Environment.number_of_agents};
    color = find(config.Model.color == 2);
    for i = 1:config.Environment.number_of_agents
        data{1+i,4} = ['Agent ' num2str(i)];
        data{1,4+i} = ['Agent ' num2str(i)];
    end
    data(2:1+config.Environment.number_of_agents,5:4+config.Environment.number_of_agents)=...
        num2cell(membMap);
    data{3+config.Environment.number_of_agents,4} = msg;
    nAgents = config.Environment.number_of_agents;
    nClubs = config.Environment.number_of_agents;
    sheetId = 'Results';
    
    hExcel = actxserver('excel.application');
    %% Store the data in Excel:
    try
        % If a file by this name already exists:
        hWorkbook = hExcel.Workbooks.Open(filename);
        newFile = false;
    catch
        % If no file by this name exists:
        hWorkbook = hExcel.Workbooks.Add();
        newFile = true;
    end
    
    try
        % If this sheet already exists:
        hSheets = hWorkbook.WorkSheets;
        if ischar(sheetId)
            sheetNames = {};
            for idx = 1 : hSheets.Count
                sheetNames{end+1} = hSheets.Item(idx).name; %#ok<AGROW>
            end
            iSheet = find(strcmpi(sheetId,sheetNames));
        end
        hSheet = hSheets.Item(iSheet);
    catch
        hSheet = hSheets.Add([], hSheets.Item(hSheets.Count));
        if ischar(sheetId)
            hSheet.name = sheetId;
        end
    end
    
    %%
    temp = xlsColNum2Str(4+nClubs);
    rangeMembmapTitles = ['D1:D' num2str(nAgents+1) ',' 'D1:' temp{1} '1'];
    
    range2Write = ['A1:' char(xlsColNum2Str(size(data,2))) num2str(size(data,1))];
    hSheet.Range(range2Write).Value = data;
    %% Design customization:
    % Borders:
%     hRange = hSheet.Range('D1:D10,D1:O1,A1:B9,B1,A11:B14,B11,A16:B20,B15');
    hRange = hSheet.Range([rangeMembmapTitles ',A1:B9']);
    hRange.Borders.Item('xlEdgeLeft').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlEdgeLeft').Weight = 2; %xlThin
    hRange.Borders.Item('xlEdgeTop').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlEdgeTop').Weight = 2; %xlThin
    hRange.Borders.Item('xlEdgeBottom').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlEdgeBottom').Weight = 2; %xlThin
    hRange.Borders.Item('xlEdgeRight').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlEdgeRight').Weight = 2; %xlThin
    hRange.Borders.Item('xlInsideVertical').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlInsideVertical').Weight = 2; %xlThin
    hRange.Borders.Item('xlInsideHorizontal').LineStyle = 1; % xlContinuous
    hRange.Borders.Item('xlInsideHorizontal').Weight = 2; %xlThin
    % Color Gray:
%     hRange = hSheet.Range('D1:O1,D1:D10,A2:A9,A12:A15,A18:A20');
    hRange = hSheet.Range([rangeMembmapTitles ',A2:A9']);
    hRange.Interior.Pattern = 1; %xlSolid
    hRange.Interior.Color = 12566463; % Gray

    % Color Blue:
    hRange = hSheet.Range('A1,A8');
    hRange.Font.Bold = true;
    hRange.Interior.Color = 15773696; % light blue
    % Auto fit first 2 columns
    hRange.Columns.Item('A:B').EntireColumn.AutoFit;
    %     catch
    %     end
    first = ['D' num2str(1+color(1))];
    for i = 2:length(color)
        first = [first,',D' ,num2str(1+color(i))];
    end
    
    hRange = hSheet.Range(first);
    hRange.Interior.Colorindex = 3; % red
    %% Save:
    if newFile
        hWorkbook.SaveAs(filename, 51); % 51 = xlOpenXMLWorkbook
    else
        hWorkbook.Save;
    end % if newFile
    %     hWorkbook.Save;
    hWorkbook.Close;
    hExcel.Quit;
end