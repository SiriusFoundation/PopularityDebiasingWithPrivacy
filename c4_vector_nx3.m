
% version
% create_4_vector_nx3.m
% v8.2_29.09.2022
% notes:
% uir matrix --> to vector

clc;
clear;

disp("Start create_4_vector_nx3");
m_ImportPath = "../out/3_disguise/";
m_ExportPath = "../out/4_uir_vector/";


data_set_collection = ["Yelp"];
% data_set_collection = ["MLM", "DoubanBooks", "Yelp", "Dianping"];

for dataSetCounter=1:size(data_set_collection,2)
    tempDataSetName = data_set_collection(dataSetCounter);
    tempDirPath = m_ImportPath + tempDataSetName + "/*.mat";
    m_fileList = dir(tempDirPath);
    
    for fileCounter=1:size(m_fileList,1)

        m_fileName = m_fileList(fileCounter).name;

        m_FilePath = m_ImportPath + tempDataSetName + "/" + m_fileName;
        m_DataSet = load(m_FilePath);

        temp_DataSet = struct2cell(m_DataSet );
        m_DataSet  = temp_DataSet{1};

        user_count = size(m_DataSet, 1);
        item_count = size(m_DataSet, 2);

        % count ratings
        m_rating_count = 0;
        for i=1:user_count
            for j=1:item_count
                if (m_DataSet(i,j) ~= 0)
                    m_rating_count = m_rating_count + 1;
                end
            end
        end

        uir_vector = zeros(m_rating_count,3,'double');
        
        % create vectors
        k = 1;
        for i=1:user_count
            for j=1:item_count
                m_rating = m_DataSet(i,j);
                if (m_rating ~= 0)
                    
                    %user vector
                    uir_vector(k,1) = i;    
                    
                    % item vector
                    uir_vector(k,2) = j;
                    
                    %rating vector
                    if (isnan(m_rating))
                        m_rating = 0;
                    end

                    uir_vector(k,3) = m_rating;

                    k = k + 1;
                end
            end
        end

        % export 
        m_exportFilePath_mat = m_ExportPath + tempDataSetName + "/" + m_fileName;
        m_exportFilePath_csv = strrep(m_exportFilePath_mat,'mat','csv');

        save(m_exportFilePath_mat, 'uir_vector', '-v7.3');
        writematrix(uir_vector,m_exportFilePath_csv);

        % log and progress
        total_calc = size(data_set_collection,2) * size(m_fileList,1);
        current_calc = dataSetCounter * fileCounter;
        disp(strcat(datestr(datetime("now")), " ", m_fileName," created. (", num2str(current_calc),"/",num2str(total_calc),")"));
    end
end

disp("Finish create_4_vector_nx3");