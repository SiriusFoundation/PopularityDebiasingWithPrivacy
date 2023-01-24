% version
% create_3_disguise.m
% v8.2_29.09.2022
% notes:
% to control
% mean(nonzeros(m_disguise_norm(1,:)))
% mean(nonzeros(m_disguise_unif(1,:)))


clc;
clear;

disp("Start create_3_disguise");

% parameters
data_set_collection = ["MLM", "DoubanBooks", "Yelp"];
% data_set_collection = ["MLM", "DoubanBooks", "Yelp", "Dianping"];
sigmamax = [0 1 2 3 4];
betamax = [0 5 10 25 50];
repeat = 5;

% one example or all
% to progressbar
total_calculation = size(data_set_collection,2) * size(sigmamax,2) * size(betamax,2) * repeat;
calculation_counter = 1;

% all loop
for dataSetCounter=1:size(data_set_collection,2)
    % sigma
    for i=1:size(sigmamax,2)
        % beta
        for j=1:size(betamax,2)
            % repeat
            for k=1:repeat
                % code block
                    sigma = sigmamax(i);
                    beta = betamax(j);
                    randomized = k;
                    data_set_name = data_set_collection(dataSetCounter);
                    
                    switch data_set_name
                        case 'MLM'
                            DataSet_UIR = load('../out/2_uir/MLM.mat');
                            file_prefix ='ML'; 
                        case 'DoubanBooks'
                            DataSet_UIR = load('../out/2_uir/DoubanBooks.mat');
                            file_prefix ='DB'; 
                        case 'Yelp'
                            DataSet_UIR = load('../out/2_uir/Yelp.mat');
                            file_prefix ='YL'; 
%                        case 'Dianping'
%                            DataSet_UIR = load('../out/2_uir/Dianping.mat');
%                            file_prefix ='DP'; 
                        otherwise
                            warning('Unexpected Dataset Type');
                    end
                
                    m_fileNameNorm = strcat(file_prefix, "_S", num2str(sigma), "_B", num2str(beta), "_N_", num2str(randomized),".mat");
                    m_filePathNorm = strcat("../out/3_disguise/", data_set_name, "/");
                    m_filePathNorm = strcat(m_filePathNorm, m_fileNameNorm);
                
                    m_fileNameUnif = strcat(file_prefix, "_S", num2str(sigma), "_B", num2str(beta), "_U_", num2str(randomized),".mat");
                    m_filePathUnif = strcat("../out/3_disguise/", data_set_name, "/");
                    m_filePathUnif = strcat(m_filePathUnif, m_fileNameUnif);
                
                    [m_disguise_unif, m_disguise_norm] = generate_disguise(DataSet_UIR, beta, sigma);
                
                    save(m_filePathUnif, 'm_disguise_unif', '-v7.3');
                    save(m_filePathNorm, 'm_disguise_norm', '-v7.3');
                    
                    m_progress = floor(calculation_counter * 100 / total_calculation);
                    disp(strcat(datestr(datetime("now")), " ", m_fileNameNorm, " %", num2str(m_progress), " completed. (",num2str(calculation_counter),"/",num2str(total_calculation),")"));
                    disp(strcat(datestr(datetime("now")), " ", m_fileNameUnif, " %", num2str(m_progress), " completed. (",num2str(calculation_counter),"/",num2str(total_calculation),")"));
                    
                    calculation_counter = calculation_counter + 1;
            end
        end
    end
end

disp("Finish create_3_disguise");