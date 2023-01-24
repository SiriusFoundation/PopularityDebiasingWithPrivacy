clc;
clear;

disp(strcat(datestr(datetime("now")), " ", "Start c12_debiasing_performance"));

% path
m_current_dataset = "DoubanBooks";
m_current_dataset_prefix = "DB"; %"ML";
m_current_algorithm = "HPF";

m_ImportPath = "../out/11_debiasing/" + m_current_dataset + "/";
m_ImportRAWDatasetPath = "../out/2_uir/" + m_current_dataset + ".mat";
m_ExportPath = "../out/12_debiasing_performance/" + m_current_dataset + "/";

m_current_raw_dataset = load(m_ImportRAWDatasetPath);
raw_temp_dataSet = struct2cell(m_current_raw_dataset);
m_current_raw_dataset = raw_temp_dataSet{1};

tempDirPath = m_ImportPath + "*" + m_current_algorithm + "*.mat";
m_fileList_temp = struct2cell(dir(tempDirPath));
m_total_file = size(m_fileList_temp,2);

m_export_cell = cell(m_total_file,21);
m_export_row_count = 1;

for m_file_counter=1:m_total_file
    m_current_file = string(m_fileList_temp(1, m_file_counter));

    m_current_TopN_List = load(m_ImportPath + m_current_file);
    m_current_temp_TopN_List = struct2cell(m_current_TopN_List);
    m_current_TopN_List = m_current_temp_TopN_List{1};
    
    % filename split
    splitted_variables = split(m_current_file,"_");
    splitted_variables_debias = split(splitted_variables(8,1),".");
    splitted_variables_sigma = replace(splitted_variables(2,1),"S","");
    splitted_variables_beta = replace(splitted_variables(3,1),"B","");

    [m_results_avg, m_results_detailed] = debiasing_metrics(m_current_raw_dataset, m_current_TopN_List); 

    m_export_cell{m_export_row_count,1} = datestr(datetime("now")); % date
    m_export_cell{m_export_row_count,2} = m_file_counter; % counter
    m_export_cell{m_export_row_count,3} = m_current_file; % filename
    m_export_cell{m_export_row_count,4} = m_current_dataset; % dataset
    m_export_cell{m_export_row_count,5} = splitted_variables_sigma; % sigma
    m_export_cell{m_export_row_count,6} = splitted_variables_beta; % beta
    m_export_cell{m_export_row_count,7} = splitted_variables(5,1); % randomize
    m_export_cell{m_export_row_count,8} = splitted_variables(6,1); % algorithm
    m_export_cell{m_export_row_count,9} = splitted_variables_debias(1,1); % debiasing
    m_export_cell{m_export_row_count,10} = m_results_avg(1,1); %sum_GAPp;
    m_export_cell{m_export_row_count,11} = m_results_avg(1,2); %sum_GAPr;
    m_export_cell{m_export_row_count,12} = m_results_avg(1,3); %sum_DeltaGAP_IM;
    m_export_cell{m_export_row_count,13} = m_results_avg(1,4); %sum_DeltaGAP_MA;
    m_export_cell{m_export_row_count,14} = m_results_avg(1,5); %sum_NCDG;
    m_export_cell{m_export_row_count,15} = m_results_avg(1,6); %sum_Precision;
    m_export_cell{m_export_row_count,16} = m_results_avg(1,7); %sum_Recall;
    m_export_cell{m_export_row_count,17} = m_results_avg(1,8); %sum_F1;
    m_export_cell{m_export_row_count,18} = m_results_avg(1,9); %sum_APLT;
    m_export_cell{m_export_row_count,19} = m_results_avg(1,10); %sum_Novelty;
    m_export_cell{m_export_row_count,20} = m_results_avg(1,11); %sum_LTC;
    m_export_cell{m_export_row_count,21} = m_results_avg(1,12); %sum_Entropy;
    
    disp(m_current_file + " " + m_export_row_count + "/" + m_total_file);

    m_export_row_count = m_export_row_count + 1;
end

m_table_header = {'Date', 'Counter', 'Filename', 'Dataset', 'Sigma', 'Beta', 'Randomize', 'Algorithm', 'Debiasing', 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'};
m_results_table = cell2table(m_export_cell,'VariableNames', m_table_header);
m_results_table_path = strcat(m_ExportPath, "debiasing_perf_", m_current_dataset, "_", m_current_algorithm,".csv");
writetable(m_results_table, m_results_table_path,'Delimiter',';');



disp(strcat(datestr(datetime("now")), " ", "Finish c12_debiasing_performance"));