clc;
clear;

disp(strcat(datestr(datetime("now")), " ", "Start c11_debiasing"));

% path
m_current_dataset = "Yelp";
m_current_dataset_prefix = "YL";
m_current_algorithm ="HPF";

m_ImportPath = "../out/6_predictions/" + m_current_dataset;
m_ImportRAWDatasetPath = "../out/2_uir/" + m_current_dataset + ".mat";
m_ExportPath = "../out/11_debiasing/";

calculationFlag = true;

opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "user_id", "item_id", "prediction"];
opts.SelectedVariableNames = ["user_id", "item_id", "prediction"];
opts.VariableTypes = ["string", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");

m_current_raw_dataset = load(m_ImportRAWDatasetPath);
raw_temp_dataSet = struct2cell(m_current_raw_dataset);
m_current_raw_dataset = raw_temp_dataSet{1};
disp(strcat(datestr(datetime("now")), " ", m_current_dataset, " Raw Dataset Readed"));

tempDirPath = m_ImportPath + "/" + "*" + m_current_algorithm + "*.csv";
m_fileList_temp = struct2cell(dir(tempDirPath));
m_total_file = size(m_fileList_temp,2);

for m_file_counter=1:m_total_file
    
    m_current_file = string(m_fileList_temp(1,m_file_counter));
    % disp(m_current_file);

    if true %(m_file_counter >= 6 && m_file_counter <= 20)
        m_ImportFilePath = m_ImportPath + "/" + m_current_file;
        m_current_predictions = readtable(m_ImportFilePath, opts);
        m_current_predictions = table2array(m_current_predictions);
        disp(strcat(datestr(datetime("now")), " ", m_current_file, " ","Readed", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
    
        [TopN_Var, TopN_Mul, TopN_Aug] = debiasing_VaR_ERPs(m_current_raw_dataset, m_current_predictions);
        
        disp(strcat(datestr(datetime("now")), " ", "TopN_Var", " ","Calculated", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
        disp(strcat(datestr(datetime("now")), " ", "TopN_Mul", " ","Calculated", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
        disp(strcat(datestr(datetime("now")), " ", "TopN_Aug", " ","Calculated", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
        
        [TopN_xQuad] = debiasing_xQuad(m_current_raw_dataset, m_current_predictions);
        disp(strcat(datestr(datetime("now")), " ", "TopN_xQuad", " ","Calculated", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));

        % exporting
        % TopN_Var
        m_save_path = m_ExportPath + m_current_dataset + "/" + replace(m_current_file,".csv","") + "_" + "TopN_Var" + ".mat";
        save(m_save_path, 'TopN_Var', '-v7.3');
        disp(strcat(datestr(datetime("now")), " ", "TopN_Var", " ","Exported", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
    
        % TopN_Mul
        m_save_path = m_ExportPath + m_current_dataset + "/" + replace(m_current_file,".csv","") + "_" + "TopN_Mul" + ".mat";
        save(m_save_path, 'TopN_Mul', '-v7.3');
        disp(strcat(datestr(datetime("now")), " ", "TopN_Mul", " ","Exported", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
    
        % TopN_Aug
        m_save_path = m_ExportPath + m_current_dataset + "/" + replace(m_current_file,".csv","") + "_" + "TopN_Aug" + ".mat";
        save(m_save_path, 'TopN_Aug', '-v7.3');
        disp(strcat(datestr(datetime("now")), " ", "TopN_Aug", " ","Exported", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));
    
        % TopN_xQuad
        m_save_path = m_ExportPath + m_current_dataset + "/" + replace(m_current_file,".csv","") + "_" + "TopN_xQd" + ".mat";
        save(m_save_path, 'TopN_xQuad', '-v7.3');
        disp(strcat(datestr(datetime("now")), " ", "TopN_xQuad", " ","Exported", " (", num2str(m_file_counter), "/", num2str(m_total_file), ")"));    
    
    end
end



clear opts
disp(strcat(datestr(datetime("now")), " ", "Finish c11_debiasing"));