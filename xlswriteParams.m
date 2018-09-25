function xlswriteParams(filename, params,nAgents,color)
    % This function saves the parameters of the exhaustive scan 
    
    %% Open Excel application:
    hExcel = actxserver('excel.application');
    %% Store the data in Excel:
    try
        hWorkbook = hExcel.Workbooks.Open(filename);
        newFile = false;
    catch
        hWorkbook = hExcel.Workbooks.Add();
        newFile = true;
    end
    
    try
        hSheets = hWorkbook.WorkSheets;
        hSheet = hSheets.Item(sheetnum);
    catch
        hSheet = hSheets.Add([], hSheets.Item(hSheets.Count));
    end
   
    hSheet.Name = 'Parameters';
    range2Write = ['A1:' char(xlsColNum2Str(size(params,2))) num2str(size(params,1))];
    hSheet.Range(range2Write).Value = params;
    %% Design customization:
    % Borders:
    hRange = hSheet.Range(['A1:B12,D1:D',num2str(1+nAgents)]);
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
    hRange = hSheet.Range('A2:A12,D1');
    hRange.Interior.Pattern = 1; %xlSolid
    hRange.Interior.Color = 12566463; % Gray
    % Color Blue:
    hRange = hSheet.Range(['A1,A4,A8,A11,D2:D',num2str(1+nAgents)]);
    hRange.Font.Bold = true;
    hRange.Interior.Color = 15773696; % light blue
    % Auto fit first 2 columns
    hRange.Columns.Item('A:B').EntireColumn.AutoFit;
    
    first = ['A6,D' num2str(1+color(1))];
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
