clc;
clear;

disp(strcat(datestr(datetime("now")), " ", "Start c13_debiasing_performance_avg"));

% path
m_current_dataset = "MLM";
m_current_algorithm = "HPF";
repeat_collection = 5;


m_ImportPath = "../out/12_debiasing_performance/" + m_current_dataset + "/";
m_ExportPath = "../out/13_debiasing_performance_avg/" + m_current_dataset + "/";

opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [2, Inf];
opts.Delimiter = ";";
opts.VariableNames = ["Date", "Counter", "Filename", "Dataset", "Sigma", "Beta", "Randomize", "Algorithm", "Debiasing", "GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"];
opts.VariableTypes = ["datetime", "double", "string", "categorical", "double", "double", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "Filename", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Filename", "Dataset", "Algorithm", "Debiasing"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"], "ThousandsSeparator", ",");


tempDirPath = m_ImportPath + "*" + m_current_algorithm + "*.csv";
m_fileList_temp = struct2cell(dir(tempDirPath));
m_current_file = string(m_fileList_temp(1,1));
m_read_path = m_ImportPath + m_current_file;

active_table = readtable(m_read_path, opts);
m_DataSetFull_temp = active_table;

m_export_cell_height = size(active_table,1) / repeat_collection;
m_export_cell = cell(m_export_cell_height, 21);
m_export_row_count = 1;

sigmamax_collection = ["0","2","3","4"];
betamax_collection = ["0","5","10","25"];
debiassing_collection = ["Aug","Mul","xQd"];
algorithm_collection = ["HPF"];

for sigmamaxCounter=1:size(sigmamax_collection,2)
    active_sigmamax = sigmamax_collection(sigmamaxCounter);
    active_sigmamax = double(active_sigmamax);

    for betamaxCounter=1:size(betamax_collection,2)
        active_betamax = betamax_collection(betamaxCounter);
        active_betamax = double(active_betamax);

        for algorithmCounter=1:size(algorithm_collection,2)
            active_algorithm = algorithm_collection(algorithmCounter);

            for debiassingCounter=1:size(debiassing_collection,2)
                active_debiassing = debiassing_collection(debiassingCounter);

                if ((active_sigmamax == 0 && active_betamax == 0) || (active_sigmamax == 2 && active_betamax == 5) || (active_sigmamax == 3 && active_betamax == 10) || (active_sigmamax == 4 && active_betamax == 25))
                    disp(active_sigmamax + "_" + active_betamax + "_" + active_algorithm + "_" + active_debiassing + "_" + m_export_row_count);
                       

                    %active_sigmamax = string(active_sigmamax);
                    %active_betamax = string(active_betamax);

                    m_DataSet_SubSet_as_DT = m_DataSetFull_temp(m_DataSetFull_temp.Sigma == active_sigmamax & m_DataSetFull_temp.Beta == active_betamax & m_DataSetFull_temp.Algorithm == active_algorithm & m_DataSetFull_temp.Debiasing == active_debiassing,:);
                    m_DataSet_SubSet_as_Cell = table2cell(m_DataSet_SubSet_as_DT);
                    
                    sum_GAPp = 0;
                    sum_GAPr = 0;
                    sum_DeltaGAP_IM = 0;
                    sum_DeltaGAP_MA = 0;
                    sum_NCDG = 0;
                    sum_Precision = 0;
                    sum_Recall = 0;
                    sum_F1 = 0;
                    sum_APLT = 0;
                    sum_Novelty = 0;
                    sum_LTC = 0;
                    sum_Entropy = 0;
                                        
                    for repeatCounter=1:repeat_collection
                        active_randomize = repeatCounter;
                        % disp(strcat(string(i), " ", m_current_dataset, "_", string(active_sigmamax), "_",  string(active_betamax), "_",  active_algorithm, "_",  active_debiassing, "_",  string(active_randomize)));
                    
                        sum_GAPp = sum_GAPp + m_DataSet_SubSet_as_Cell{repeatCounter,10};
                        sum_GAPr = sum_GAPr + m_DataSet_SubSet_as_Cell{repeatCounter,11};
                        sum_DeltaGAP_IM = sum_DeltaGAP_IM + m_DataSet_SubSet_as_Cell{repeatCounter,12};
                        sum_DeltaGAP_MA = sum_DeltaGAP_MA + m_DataSet_SubSet_as_Cell{repeatCounter,13};
                        sum_NCDG = sum_NCDG + m_DataSet_SubSet_as_Cell{repeatCounter,14};
                        sum_Precision = sum_Precision + m_DataSet_SubSet_as_Cell{repeatCounter,15};
                        sum_Recall = sum_Recall + m_DataSet_SubSet_as_Cell{repeatCounter,16};
                        sum_F1 = sum_F1 + m_DataSet_SubSet_as_Cell{repeatCounter,17};
                        sum_APLT = sum_APLT + m_DataSet_SubSet_as_Cell{repeatCounter,18};
                        sum_Novelty = sum_Novelty + m_DataSet_SubSet_as_Cell{repeatCounter,19};
                        sum_LTC = sum_LTC + m_DataSet_SubSet_as_Cell{repeatCounter,20};
                        sum_Entropy = sum_Entropy + m_DataSet_SubSet_as_Cell{repeatCounter,21};

                        i = i + 1;
                    end

                    sum_GAPp = sum_GAPp / 5;
                    sum_GAPr = sum_GAPr / 5;
                    sum_DeltaGAP_IM = sum_DeltaGAP_IM / 5;
                    sum_DeltaGAP_MA = sum_DeltaGAP_MA / 5;
                    sum_NCDG = sum_NCDG / 5;
                    sum_Precision = sum_Precision / 5;
                    sum_Recall = sum_Recall / 5;
                    sum_F1 = sum_F1 / 5;
                    sum_APLT = sum_APLT / 5;
                    sum_Novelty = sum_Novelty / 5;
                    sum_LTC = sum_LTC / 5;
                    sum_Entropy = sum_Entropy / 5;

                    m_export_cell{m_export_row_count,1} = m_DataSet_SubSet_as_Cell{repeatCounter,1};
                    m_export_cell{m_export_row_count,2} = m_DataSet_SubSet_as_Cell{repeatCounter,2};
                    m_export_cell{m_export_row_count,3} = m_DataSet_SubSet_as_Cell{repeatCounter,3};
                    m_export_cell{m_export_row_count,4} = m_DataSet_SubSet_as_Cell{repeatCounter,4};
                    m_export_cell{m_export_row_count,5} = m_DataSet_SubSet_as_Cell{repeatCounter,5};
                    m_export_cell{m_export_row_count,6} = m_DataSet_SubSet_as_Cell{repeatCounter,6};
                    m_export_cell{m_export_row_count,7} = 0;
                    m_export_cell{m_export_row_count,8} = m_DataSet_SubSet_as_Cell{repeatCounter,8};
                    m_export_cell{m_export_row_count,9} = m_DataSet_SubSet_as_Cell{repeatCounter,9};
                    m_export_cell{m_export_row_count,10} = sum_GAPp;
                    m_export_cell{m_export_row_count,11} = sum_GAPr;
                    m_export_cell{m_export_row_count,12} = sum_DeltaGAP_IM;
                    m_export_cell{m_export_row_count,13} = sum_DeltaGAP_MA;
                    m_export_cell{m_export_row_count,14} = sum_NCDG;
                    m_export_cell{m_export_row_count,15} = sum_Precision;
                    m_export_cell{m_export_row_count,16} = sum_Recall;
                    m_export_cell{m_export_row_count,17} = sum_F1;
                    m_export_cell{m_export_row_count,18} = sum_APLT;
                    m_export_cell{m_export_row_count,19} = sum_Novelty;
                    m_export_cell{m_export_row_count,20} = sum_LTC;
                    m_export_cell{m_export_row_count,21} = sum_Entropy;

                    sum_GAPp = 0;
                    sum_GAPr = 0;
                    sum_DeltaGAP_IM = 0;
                    sum_DeltaGAP_MA = 0;
                    sum_NCDG = 0;
                    sum_Precision = 0;
                    sum_Recall = 0;
                    sum_F1 = 0;
                    sum_APLT = 0;
                    sum_Novelty = 0;
                    sum_LTC = 0;
                    sum_Entropy = 0;

                    m_export_row_count = m_export_row_count + 1;
                end
           end
        end
    end
end

% save here
m_table_header = {'Date', 'Counter', 'Filename', 'Dataset', 'Sigma', 'Beta', 'Randomize', 'Algorithm', 'Debiasing', 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'};
m_results_table = cell2table(m_export_cell,'VariableNames', m_table_header);
m_results_table_path = strcat(m_ExportPath, "debiasing_perf_avg_", m_current_dataset, "_", m_current_algorithm,".csv");
writetable(m_results_table, m_results_table_path,'Delimiter',';');

clear opts
disp(strcat(datestr(datetime("now")), " ", "Finish c13_debiasing_performance_avg"));