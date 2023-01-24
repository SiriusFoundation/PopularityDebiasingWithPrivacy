clc;
clear;

% disp("Start create_7_evaluations");

m_raw_dataset_root_path = "../out/2_uir/";
m_ImportPath = "../out/6_predictions/";
m_ExportPath = "../out/7_evaluations/";
data_set_collection = ["Yelp"];
% data_set_collection = ["MLM", "DoubanBooks", "Yelp", "Dianping"];

% read format - prediction files with index
opts_with_index = delimitedTextImportOptions("NumVariables", 4);
opts_with_index.DataLines = [2, Inf];
opts_with_index.Delimiter = ",";
opts_with_index.VariableNames = ["Var1", "user_id", "item_id", "prediction"];
opts_with_index.SelectedVariableNames = ["user_id", "item_id", "prediction"];
opts_with_index.VariableTypes = ["string", "double", "double", "double"];
opts_with_index.ExtraColumnsRule = "ignore";
opts_with_index.EmptyLineRule = "read";
opts_with_index = setvaropts(opts_with_index, "Var1", "WhitespaceRule", "preserve");
opts_with_index = setvaropts(opts_with_index, "Var1", "EmptyFieldRule", "auto");

% read format - prediction files without index
% IA item average ve MP most popular
opts_without_index = delimitedTextImportOptions("NumVariables", 3);
opts_without_index.DataLines = [1, Inf];
opts_without_index.Delimiter = ",";
opts_without_index.VariableNames = ["user_id", "item_id", "prediction"];
opts_without_index.VariableTypes = ["double", "double", "double"];
opts_without_index.ExtraColumnsRule = "ignore";
opts_without_index.EmptyLineRule = "read";

disp("date" + ";" + "counter" + ";" + "filename" + ";" + "dataset" + ";" + "sigma" + ";" + "beta" + ";"  + "dist" + ";" + "randomize" + ";" + "algorithm" + ";" + "GAPp" + ";" + "GAPr" + ";" + "DeltaGAP_IM" + ";" + "DeltaGAP_MA" + ";" + "NCDG" + ";" + "Precision" + ";" + "Recall" + ";" + "F1" + ";" + "APLT" + ";" + "Novelty" + ";" + "LTC" + ";" + "Entropy");
for dataSetCounter=1:size(data_set_collection,2)
    active_collection = data_set_collection(dataSetCounter);
    tempDirPath = m_ImportPath + active_collection + "/*.csv";
    m_fileList = dir(tempDirPath);
    
    % raw datasets for compare metrics
    raw_dataset_path = m_raw_dataset_root_path + active_collection + '.mat';
    raw_dataset = load(raw_dataset_path);
    raw_temp_dataSet = struct2cell(raw_dataset);
    raw_dataset = raw_temp_dataSet{1};

    % create data table to save all data 
    m_export_cell = cell(size(m_fileList,1),21);
    % m_export_avg_cell = cell((size(m_fileList,1) / 5),21);

    for m_file_counter=1:size(m_fileList,1)
        activeFilename = m_fileList(m_file_counter).name;
        currentPath = m_ImportPath + active_collection + "/" + activeFilename;

        %if and(m_file_counter >=1, m_file_counter <=2)
        if true
            % eger item average veya most popular ise soldaki seq kolonu yok, o
            % nedenle farklı formata okuyoruz.
            m_if_fileName = convertCharsToStrings(activeFilename) ;
            if or(m_if_fileName.contains("_MP"), m_if_fileName.contains("_IA")) 
                m_predictions = readtable(currentPath, opts_without_index);
                m_predictions = table2array(m_predictions);
            else
                m_predictions = readtable(currentPath, opts_with_index);
                m_predictions = table2array(m_predictions);
            end
    
            % calculate metrics
            [m_Avg, m_results] = Metrics(raw_dataset, m_predictions);
    
            activeFilename_with_no_extension = string(extractBetween(activeFilename,1,strlength(activeFilename) - 4));
            m_param_list = split(activeFilename_with_no_extension,"_");
            m_param_dataset = active_collection;
            m_param_sigmamax = string(extractBetween(m_param_list(2), 2, strlength(m_param_list(2))));
            m_param_betamax = string(extractBetween(m_param_list(3), 2, strlength(m_param_list(3))));
            m_param_distribution = string(m_param_list(4));
            m_param_randomize_run = string(m_param_list(5));
            m_param_algorithm = string(m_param_list(6));
    
            % mapping parameter and metrics to save disk
            m_export_cell{m_file_counter,1} = datetime("now");
            m_export_cell{m_file_counter,2} = m_file_counter;
            m_export_cell{m_file_counter,3} = activeFilename_with_no_extension;
            m_export_cell{m_file_counter,4} = m_param_dataset;
            m_export_cell{m_file_counter,5} = m_param_sigmamax;
            m_export_cell{m_file_counter,6} = m_param_betamax;
            m_export_cell{m_file_counter,7} = m_param_distribution;
            m_export_cell{m_file_counter,8} = m_param_randomize_run;
            m_export_cell{m_file_counter,9} = m_param_algorithm;
            
            m_export_cell{m_file_counter,10} = m_Avg(1);
            m_export_cell{m_file_counter,11} = m_Avg(2);
            m_export_cell{m_file_counter,12} = m_Avg(3);
            m_export_cell{m_file_counter,13} = m_Avg(4);
            m_export_cell{m_file_counter,14} = m_Avg(5);
            m_export_cell{m_file_counter,15} = m_Avg(6);
            m_export_cell{m_file_counter,16} = m_Avg(7);
            m_export_cell{m_file_counter,17} = m_Avg(8);
            m_export_cell{m_file_counter,18} = m_Avg(9);
            m_export_cell{m_file_counter,19} = m_Avg(10);
            m_export_cell{m_file_counter,20} = m_Avg(11);
            m_export_cell{m_file_counter,21} = m_Avg(12);
            
            m_result_output = strcat(datestr(datetime("now"))) + ";" + m_file_counter + ";" + activeFilename_with_no_extension + ";" + m_param_dataset + ";" + m_param_sigmamax + ";" + m_param_betamax + ";" + m_param_distribution + ";" + m_param_randomize_run + ";" + m_param_algorithm + ";" + m_Avg(1) + ";" + m_Avg(2) + ";" + m_Avg(3) + ";" + m_Avg(4) + ";" + m_Avg(5) + ";" + m_Avg(6) + ";" + m_Avg(7) + ";" + m_Avg(8) + ";" + m_Avg(9) + ";" + m_Avg(10) + ";" + m_Avg(11) + ";" + m_Avg(12);
            m_saveFilePath = strcat("../out/7_evaluations/", active_collection, "/", activeFilename_with_no_extension, ".mat");
            save(m_saveFilePath, 'm_results', '-v7.3');
    
            disp(m_result_output);

            % if m_file_counter == 5
            %     disp("done")
            % end

        end
    end

    m_table_header = {'date', 'counter', 'filename', 'dataset', 'sigma', 'beta', 'dist', 'randomize', 'algorithm', 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'};
    m_results_table = cell2table(m_export_cell,'VariableNames', m_table_header);
    m_results_table_path = strcat("../out/7_evaluations/", active_collection, "_all_", datestr(datetime("now"),'yyyy-dd-mm'),".csv");
    writetable(m_results_table, m_results_table_path,'Delimiter',';');

end

disp("Finish create_7_evaluations")