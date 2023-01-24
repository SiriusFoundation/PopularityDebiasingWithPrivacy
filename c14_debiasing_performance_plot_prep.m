clc;
clear;

disp("Start c14_debiasing_performance_plot_prep");

active_dataSet = "Yelp";

m_ImportPath = "../out/13_debiasing_performance_avg/";
m_ExportPath = "../out/14_debiasing_performance_plot_prep/" + active_dataSet + "/";

m_algorithm_vector = ["HPF"];
m_algorithm_vector_ordered = ["HPF"];

m_debiasing_vector = ["Aug","Mul","xQd"];
m_debiasing_vector_ordered = ["Aug","Mul","xQd"];

m_profile_vector = ["non_privacy", "fiery_fundamentalist", "pretty_pragmatist", "marginally_concerned"];
m_profile_vector_ordered = ["non_privacy", "marginally_concerned", "pretty_pragmatist", "fiery_fundamentalist"];


% profiles added
fiery_fundamentalist_sigma = 4;
fiery_fundamentalist_beta = 25;
pretty_pragmatist_sigma = 3; 
pretty_pragmatist_beta = 10;
marginally_concerned_sigma = 2;
marginally_concerned_beta = 5;
non_privacy_sigma = 0;
non_privacy_beta = 0;

opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [2, Inf];
opts.Delimiter = ";";
opts.VariableNames = ["Date", "Counter", "Filename", "Dataset", "Sigma", "Beta", "Randomize", "Algorithm", "Debiasing", "GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"];
opts.VariableTypes = ["datetime", "double", "string", "categorical", "double", "double", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "Filename", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Filename", "Dataset", "Algorithm", "Debiasing"], "EmptyFieldRule", "auto");

m_DataSetFull = readtable(strcat(m_ImportPath, active_dataSet,"/", "debiasing_perf_avg_", active_dataSet,"_", m_algorithm_vector(1), ".csv"), opts);
m_DataSet_SubSet_as_DT = m_DataSetFull;

% removed unnecessary columns
m_DataSet_SubSet_as_DT = removevars(m_DataSet_SubSet_as_DT,{'Date','Counter', 'Dataset','Randomize'});

% filename column renamed with profilename column
m_DataSet_SubSet_as_DT.Properties.VariableNames = ["Profile", "Sigma", "Beta", "Algorithm", "Debiasing", "GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"];

% converted to cell for loop
m_DataSet_SubSet_as_Cell = table2cell(m_DataSet_SubSet_as_DT);


% profile name columnd updated with sigma and beta
for dataset_Counter=1:size(m_DataSet_SubSet_as_Cell,1)
    if (m_DataSet_SubSet_as_Cell{dataset_Counter,2} == fiery_fundamentalist_sigma & m_DataSet_SubSet_as_Cell{dataset_Counter,3} == fiery_fundamentalist_beta)
        m_DataSet_SubSet_as_Cell{dataset_Counter,1} = 'fiery_fundamentalist';
    elseif (m_DataSet_SubSet_as_Cell{dataset_Counter,2} == pretty_pragmatist_sigma & m_DataSet_SubSet_as_Cell{dataset_Counter,3} == pretty_pragmatist_beta)
        m_DataSet_SubSet_as_Cell{dataset_Counter,1} = 'pretty_pragmatist';
    elseif (m_DataSet_SubSet_as_Cell{dataset_Counter,2} == marginally_concerned_sigma & m_DataSet_SubSet_as_Cell{dataset_Counter,3} == marginally_concerned_beta)
        m_DataSet_SubSet_as_Cell{dataset_Counter,1} = 'marginally_concerned';
    elseif (m_DataSet_SubSet_as_Cell{dataset_Counter,2} == non_privacy_sigma & m_DataSet_SubSet_as_Cell{dataset_Counter,3} == non_privacy_beta)
        m_DataSet_SubSet_as_Cell{dataset_Counter,1} = 'non_privacy';
    end
end

% results table created and some columns removed
m_results_table = cell2table(m_DataSet_SubSet_as_Cell);
m_results_table.Properties.VariableNames = ["Profile", "Sigma", "Beta", "Algorithm", "Debiasing", "GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"];
m_results_table = removevars(m_results_table,{'Sigma','Beta', 'Algorithm'});



% results
% 10 -- >4 yap
% m_algorithm_vector_ordered ==> m_debiasing_vector_ordered


% ------------------------ metrics -------------------------

% GAPp 
m_results_table_GAPp = m_results_table;
m_results_table_GAPp = removevars(m_results_table_GAPp,{'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_GAPp = table2cell(m_results_table_GAPp);
m_results_vector_GAPp = zeros(4,4,'double');

for m_results_table_GAPp_counter=1:size(m_results_table_GAPp,1)
    m_active_profile = m_results_table_GAPp{m_results_table_GAPp_counter,1};
    m_active_algorithm = string(m_results_table_GAPp{m_results_table_GAPp_counter,2});
    m_active_value = m_results_table_GAPp{m_results_table_GAPp_counter,3};
    m_results_vector_GAPp(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_GAPp = [m_profile_vector_ordered; num2cell(m_results_vector_GAPp)];
writematrix(m_results_vector_GAPp, strcat(m_ExportPath, "01_GAPp.csv"), 'Delimiter', ';');

% GAPr 
m_results_table_GAPr = m_results_table;
m_results_table_GAPr = removevars(m_results_table_GAPr,{'GAPp', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_GAPr = table2cell(m_results_table_GAPr);
m_results_vector_GAPr = zeros(4,4,'double');


for m_results_table_GAPr_counter=1:size(m_results_table_GAPr,1)
    m_active_profile = m_results_table_GAPr{m_results_table_GAPr_counter,1};
    m_active_algorithm = string(m_results_table_GAPr{m_results_table_GAPr_counter,2});
    m_active_value = m_results_table_GAPr{m_results_table_GAPr_counter,3};
    m_results_vector_GAPr(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_GAPr = [m_profile_vector_ordered; num2cell(m_results_vector_GAPr)];
writematrix(m_results_vector_GAPr, strcat(m_ExportPath, "02_GAPr.csv"), 'Delimiter', ';');



% GAPr - percentage - MERT
% GAPr 
m_results_table_GAPr_percentage = m_results_table;
m_results_table_GAPr_percentage = removevars(m_results_table_GAPr_percentage,{'GAPp', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_GAPr_percentage = table2cell(m_results_table_GAPr_percentage);
m_results_vector_GAPr_percentage = zeros(4,4,'double');


for m_results_table_GAPr_percentage_counter=1:size(m_results_table_GAPr_percentage,1)
    m_active_profile = m_results_table_GAPr_percentage{m_results_table_GAPr_percentage_counter,1};
    m_active_algorithm = string(m_results_table_GAPr_percentage{m_results_table_GAPr_percentage_counter,2});
    m_active_value = m_results_table_GAPr_percentage{m_results_table_GAPr_percentage_counter,3};
    m_results_vector_GAPr_percentage(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_GAPr_percentage = [m_profile_vector_ordered; num2cell(m_results_vector_GAPr_percentage)];

for m_results_table_GAPr_percentage_counter=2:size(m_results_vector_GAPr_percentage,1)
    m_np_value = m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 1);
    m_mc_value = m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 2);
    m_pp_value = m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 3);
    m_ff_value = m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 4);

    
    new_mc = (str2num(m_np_value) - str2num(m_mc_value)) / str2num(m_mc_value) * 100;
    new_pp = (str2num(m_np_value) - str2num(m_pp_value)) / str2num(m_pp_value) * 100;
    new_ff = (str2num(m_np_value) - str2num(m_ff_value)) / str2num(m_ff_value) * 100;
    m_np_value = (str2num(m_np_value) - str2num(m_np_value)) / str2num(m_mc_value) * 100;

    m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 1) = m_np_value; 
    m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 2) = new_mc;
    m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 3) = new_pp;
    m_results_vector_GAPr_percentage(m_results_table_GAPr_percentage_counter, 4) = new_ff;
end

writematrix(m_results_vector_GAPr_percentage, strcat(m_ExportPath, "02_GAPr_percentage.csv"), 'Delimiter', ';');


% DeltaGAP_IM 
m_results_table_DeltaGAP_IM = m_results_table;
m_results_table_DeltaGAP_IM = removevars(m_results_table_DeltaGAP_IM,{'GAPp', 'GAPr',        'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_DeltaGAP_IM = table2cell(m_results_table_DeltaGAP_IM);
m_results_vector_DeltaGAP_IM = zeros(4,4,'double');

for m_results_table_DeltaGAP_IM_counter=1:size(m_results_table_DeltaGAP_IM,1)
    m_active_profile = m_results_table_DeltaGAP_IM{m_results_table_DeltaGAP_IM_counter,1};
    m_active_algorithm = string(m_results_table_DeltaGAP_IM{m_results_table_DeltaGAP_IM_counter,2});
    m_active_value = m_results_table_DeltaGAP_IM{m_results_table_DeltaGAP_IM_counter,3};
    m_results_vector_DeltaGAP_IM(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_DeltaGAP_IM = [m_profile_vector_ordered; num2cell(m_results_vector_DeltaGAP_IM)];
writematrix(m_results_vector_DeltaGAP_IM, strcat(m_ExportPath, "03_DeltaGAP_IM.csv"), 'Delimiter', ';');


% DeltaGAP_MA 
m_results_table_DeltaGAP_MA = m_results_table;
m_results_table_DeltaGAP_MA = removevars(m_results_table_DeltaGAP_MA,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_DeltaGAP_MA = table2cell(m_results_table_DeltaGAP_MA);
m_results_vector_DeltaGAP_MA = zeros(4,4,'double');

for m_results_table_DeltaGAP_MA_counter=1:size(m_results_table_DeltaGAP_MA,1)
    m_active_profile = m_results_table_DeltaGAP_MA{m_results_table_DeltaGAP_MA_counter,1};
    m_active_algorithm = string(m_results_table_DeltaGAP_MA{m_results_table_DeltaGAP_MA_counter,2});
    m_active_value = m_results_table_DeltaGAP_MA{m_results_table_DeltaGAP_MA_counter,3};
    m_results_vector_DeltaGAP_MA(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_DeltaGAP_MA = [m_profile_vector_ordered; num2cell(m_results_vector_DeltaGAP_MA)];
writematrix(m_results_vector_DeltaGAP_MA, strcat(m_ExportPath, "04_DeltaGAP_MA.csv"), 'Delimiter', ';');


% NCDG - % 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'
% 'profile', 'algorithm', 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'

m_results_table_NDCG = m_results_table;
m_results_table_NDCG = removevars(m_results_table_NDCG,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_NDCG = table2cell(m_results_table_NDCG);
m_results_vector_NDCG = zeros(4,4,'double');

for m_results_table_NDCG_counter=1:size(m_results_table_NDCG,1)
    m_active_profile = m_results_table_NDCG{m_results_table_NDCG_counter,1};
    m_active_algorithm = string(m_results_table_NDCG{m_results_table_NDCG_counter,2});
    m_active_value = m_results_table_NDCG{m_results_table_NDCG_counter,3};
    m_results_vector_NDCG(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_NDCG = [m_profile_vector_ordered; num2cell(m_results_vector_NDCG)];
writematrix(m_results_vector_NDCG, strcat(m_ExportPath, "05_NDCG.csv"), 'Delimiter', ';');



% Precision 
m_results_table_Precision = m_results_table;
m_results_table_Precision = removevars(m_results_table_Precision,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_Precision = table2cell(m_results_table_Precision);
m_results_vector_Precision = zeros(4,4,'double');

for m_results_table_Precision_counter=1:size(m_results_table_Precision,1)
    m_active_profile = m_results_table_Precision{m_results_table_Precision_counter,1};
    m_active_algorithm = string(m_results_table_Precision{m_results_table_Precision_counter,2});
    m_active_value = m_results_table_Precision{m_results_table_Precision_counter,3};
    m_results_vector_Precision(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_Precision = [m_profile_vector_ordered; num2cell(m_results_vector_Precision)];
writematrix(m_results_vector_Precision, strcat(m_ExportPath, "06_Precision.csv"), 'Delimiter', ';');


% Recall 
m_results_table_Recall = m_results_table;
m_results_table_Recall = removevars(m_results_table_Recall,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_Recall = table2cell(m_results_table_Recall);
m_results_vector_Recall = zeros(4,4,'double');

for m_results_table_Recall_counter=1:size(m_results_table_Recall,1)
    m_active_profile = m_results_table_Recall{m_results_table_Recall_counter,1};
    m_active_algorithm = string(m_results_table_Recall{m_results_table_Recall_counter,2});
    m_active_value = m_results_table_Recall{m_results_table_Recall_counter,3};
    m_results_vector_Recall(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_Recall = [m_profile_vector_ordered; num2cell(m_results_vector_Recall)];
writematrix(m_results_vector_Recall, strcat(m_ExportPath, "07_Recall.csv"), 'Delimiter', ';');


% F1 
m_results_table_F1 = m_results_table;
m_results_table_F1 = removevars(m_results_table_F1,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'APLT', 'Novelty', 'LTC', 'Entropy'});
m_results_table_F1 = table2cell(m_results_table_F1);
m_results_vector_F1 = zeros(4,4,'double');

for m_results_table_F1_counter=1:size(m_results_table_F1,1)
    m_active_profile = m_results_table_F1{m_results_table_F1_counter,1};
    m_active_algorithm = string(m_results_table_F1{m_results_table_F1_counter,2});
    m_active_value = m_results_table_F1{m_results_table_F1_counter,3};
    m_results_vector_F1(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_F1 = [m_profile_vector_ordered; num2cell(m_results_vector_F1)];
writematrix(m_results_vector_F1, strcat(m_ExportPath, "08_F1.csv"), 'Delimiter', ';');


% APLT 
m_results_table_APLT = m_results_table;
m_results_table_APLT = removevars(m_results_table_APLT,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'Novelty', 'LTC', 'Entropy'});
m_results_table_APLT = table2cell(m_results_table_APLT);
m_results_vector_APLT = zeros(4,4,'double');

for m_results_table_APLT_counter=1:size(m_results_table_APLT,1)
    m_active_profile = m_results_table_APLT{m_results_table_APLT_counter,1};
    m_active_algorithm = string(m_results_table_APLT{m_results_table_APLT_counter,2});
    m_active_value = m_results_table_APLT{m_results_table_APLT_counter,3};
    m_results_vector_APLT(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_APLT = [m_profile_vector_ordered; num2cell(m_results_vector_APLT)];
writematrix(m_results_vector_APLT, strcat(m_ExportPath, "09_APLT.csv"), 'Delimiter', ';');



% Novelty 
m_results_table_Novelty = m_results_table;
m_results_table_Novelty = removevars(m_results_table_Novelty,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'LTC', 'Entropy'});
m_results_table_Novelty = table2cell(m_results_table_Novelty);
m_results_vector_Novelty = zeros(4,4,'double');

for m_results_table_Novelty_counter=1:size(m_results_table_Novelty,1)
    m_active_profile = m_results_table_Novelty{m_results_table_Novelty_counter,1};
    m_active_algorithm = string(m_results_table_Novelty{m_results_table_Novelty_counter,2});
    m_active_value = m_results_table_Novelty{m_results_table_Novelty_counter,3};
    m_results_vector_Novelty(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_Novelty = [m_profile_vector_ordered; num2cell(m_results_vector_Novelty)];
writematrix(m_results_vector_Novelty, strcat(m_ExportPath, "10_Novelty.csv"), 'Delimiter', ';');



% LTC 
m_results_table_LTC = m_results_table;
m_results_table_LTC = removevars(m_results_table_LTC,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'Entropy'});
m_results_table_LTC = table2cell(m_results_table_LTC);
m_results_vector_LTC = zeros(4,4,'double');

for m_results_table_LTC_counter=1:size(m_results_table_LTC,1)
    m_active_profile = m_results_table_LTC{m_results_table_LTC_counter,1};
    m_active_algorithm = string(m_results_table_LTC{m_results_table_LTC_counter,2});
    m_active_value = m_results_table_LTC{m_results_table_LTC_counter,3};
    m_results_vector_LTC(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_LTC = [m_profile_vector_ordered; num2cell(m_results_vector_LTC)];
writematrix(m_results_vector_LTC, strcat(m_ExportPath, "11_LTC.csv"), 'Delimiter', ';');


% Entropy 
m_results_table_Entropy = m_results_table;
m_results_table_Entropy = removevars(m_results_table_Entropy,{'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC'});
m_results_table_Entropy = table2cell(m_results_table_Entropy);
m_results_vector_Entropy = zeros(4,4,'double');

for m_results_table_Entropy_counter=1:size(m_results_table_Entropy,1)
    m_active_profile = m_results_table_Entropy{m_results_table_Entropy_counter,1};
    m_active_algorithm = string(m_results_table_Entropy{m_results_table_Entropy_counter,2});
    m_active_value = m_results_table_Entropy{m_results_table_Entropy_counter,3};
    m_results_vector_Entropy(find(m_debiasing_vector_ordered == m_active_algorithm), find(m_profile_vector_ordered == m_active_profile)) = m_active_value;
end

m_results_vector_Entropy = [m_profile_vector_ordered; num2cell(m_results_vector_Entropy)];
writematrix(m_results_vector_Entropy, strcat(m_ExportPath, "12_Entropy.csv"), 'Delimiter', ';');




clear opts;
disp("Finish c14_debiasing_performance_plot_prep");