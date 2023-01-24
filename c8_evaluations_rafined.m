clc;
clear;

disp("Start c8_evaluations_rafined");

m_ImportPath = "../out/7_evaluations/";
m_ExportPath = "../out/8_rafined_evaluations/";

data_set_collection = ["Yelp"];
% data_set_collection = ["MLM", "DoubanBooks", "Yelp", "Dianping"];
sigmamax_collection = [0 1 2 3 4]; % sigmamax = [0 1 2 3 4];
betamax_collection = [0 5 10 25 50];
algorithm_collection = ["HPF", "IA", "IBPR", "MMMF", "MP", "NEUMF", "SKM", "VAECF", "WBPR", "WMF"];
% distribution_collection = ["N", "U"];
distribution_collection = ["N"];
repeat_collection = 5;

m_export_cell = cell((size(sigmamax_collection,2) * size(betamax_collection,2) * size(algorithm_collection,2) * size(distribution_collection,2)),21);

opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [2, Inf];
opts.Delimiter = ";";
opts.VariableNames = ["date", "counter", "filename", "dataset", "sigma", "beta", "dist", "randomize", "algorithm", "GAPp", "GAPr", "DeltaGAP_IM", "DeltaGAP_MA", "NCDG", "Precision", "Recall", "F1", "APLT", "Novelty", "LTC", "Entropy"];
opts.VariableTypes = ["datetime", "double", "string", "categorical", "double", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "filename", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["filename", "dataset", "dist", "algorithm"], "EmptyFieldRule", "auto");


i = 1;
for dataSetCounter=1:size(data_set_collection,2)
    active_dataSet = data_set_collection(dataSetCounter);

    filePath = strcat(m_ImportPath, active_dataSet,".csv");
    m_DataSetFull = readtable(strcat(m_ImportPath, active_dataSet,".csv"), opts);
    m_DataSetFull_temp = m_DataSetFull;
    m_export_row_count = 1;
    
    for sigmamaxCounter=1:size(sigmamax_collection,2)
        active_sigmamax = sigmamax_collection(sigmamaxCounter);
        for betamaxCounter=1:size(betamax_collection,2)
            active_betamax = betamax_collection(betamaxCounter);
            for algorithmCounter=1:size(algorithm_collection,2)
                active_algorithm = algorithm_collection(algorithmCounter);
                for distributionCounter=1:size(distribution_collection,2)
                    active_distribution = distribution_collection(distributionCounter);

                    if ((active_sigmamax == 0 && active_betamax == 0 && active_distribution == "N") || (active_sigmamax == 2 && active_betamax == 5 && active_distribution == "N") || (active_sigmamax == 3 && active_betamax == 10 && active_distribution == "N") || (active_sigmamax == 4 && active_betamax == 25 && active_distribution == "N"))

                        m_DataSet_SubSet_as_DT = m_DataSetFull_temp(m_DataSetFull_temp.sigma == active_sigmamax & m_DataSetFull_temp.beta == active_betamax & m_DataSetFull_temp.algorithm == active_algorithm & m_DataSetFull_temp.dist == active_distribution,:);
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
                            disp(strcat(string(i), " ", active_dataSet, "_", string(active_sigmamax), "_",  string(active_betamax), "_",  active_algorithm, "_",  active_distribution, "_",  string(active_randomize)));
                        
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
                        
                        % disp("date" + ";" + "counter" + ";" + "filename" + ";" + "dataset" + ";" + "sigma" + ";" + "beta" + ";"  + "dist" + ";" + "randomize" + ";" + "algorithm" + ";" + "GAPp" + ";" + "GAPr" + ";" + "DeltaGAP_IM" + ";" + "DeltaGAP_MA" + ";" + "NCDG" + ";" + "Precision" + ";" + "Recall" + ";" + "F1" + ";" + "APLT" + ";" + "Novelty" + ";" + "LTC" + ";" + "Entropy");
                        m_export_cell{m_export_row_count,1} = m_DataSet_SubSet_as_Cell{repeatCounter,1};
                        m_export_cell{m_export_row_count,2} = m_DataSet_SubSet_as_Cell{repeatCounter,2};
                        m_export_cell{m_export_row_count,3} = m_DataSet_SubSet_as_Cell{repeatCounter,3};
                        m_export_cell{m_export_row_count,4} = m_DataSet_SubSet_as_Cell{repeatCounter,4};
                        m_export_cell{m_export_row_count,5} = m_DataSet_SubSet_as_Cell{repeatCounter,5};
                        m_export_cell{m_export_row_count,6} = m_DataSet_SubSet_as_Cell{repeatCounter,6};
                        m_export_cell{m_export_row_count,7} = m_DataSet_SubSet_as_Cell{repeatCounter,7};
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
    
                        m_export_row_count = m_export_row_count + 1;
                    end
                end
            end
        end
    end

    % buraya kaydet
    m_table_header = {'date', 'counter', 'filename', 'dataset', 'sigma', 'beta', 'dist', 'randomize', 'algorithm', 'GAPp', 'GAPr', 'DeltaGAP_IM', 'DeltaGAP_MA', 'NCDG', 'Precision', 'Recall', 'F1', 'APLT', 'Novelty', 'LTC', 'Entropy'};
    m_results_table = cell2table(m_export_cell,'VariableNames', m_table_header);
    m_results_table_path = strcat(m_ExportPath, active_dataSet,".csv");
    writetable(m_results_table, m_results_table_path,'Delimiter',';');
end


clear opts
disp("Finish c8_evaluations_rafined")