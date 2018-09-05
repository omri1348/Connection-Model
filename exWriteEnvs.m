function exWriteEnvs(filename,stableEnvs,i,nAgents)
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
   
    hSheet.Name = [num2str(i),' Color Environments'];
    start = 1;
    value = xlsColNum2Str(nAgents+1);
    for k = 1:size(stableEnvs,1)
        range2Write = ['A',num2str(start),':',value{1},...
            num2str(start+nAgents)];
        hSheet.Range(range2Write).Value = membMap2Cell(stableEnvs{k,1});
        hRange = hSheet.Range(['A',num2str(start+1),':A',num2str(start+nAgents)]);
        hRange.Interior.Color = 15773696;
        index = find(stableEnvs{k,2} == 2);
        color_range = ['A',num2str(index(1)+start)];
        for l = 2:length(index)
            color_range = [color_range,',A',num2str(index(l)+start)];
        end
        hRange = hSheet.Range(color_range);
        hRange.Interior.Colorindex = 3; % red
        start = start+nAgents+2;
    end

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
