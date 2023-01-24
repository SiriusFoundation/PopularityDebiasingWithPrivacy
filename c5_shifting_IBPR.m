clc;
clear;

disp("Start c5_shifting_IBPR");

m_ImportPath = "../out/4_uir_vector/";
m_ExportPath = "../out/5_shifting/";

data_set_collection = ["MLM", "DoubanBooks", "Yelp"];
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

        m_rating_count = size(m_DataSet, 1);
        
        % empty users
        user_count = max(m_DataSet(:,1));
        % m_user_list = unique(m_DataSet(:,1));
        m_user_list = zeros(user_count,1,'double');


        
        % m_min_rating = 100.* ones(user_count,1,'double');
        % m_total_rating_per_user = zeros(user_count,1,'double');
        % m_user_list = [m_user_list m_total_rating_per_user m_min_rating];
        m_user_list = [m_user_list zeros(user_count,1,'double') 100.* ones(user_count,1,'double')];

        % get minimums
        for i=1:m_rating_count
            m_active_user_id = m_DataSet(i,1);
            m_active_item_id = m_DataSet(i,2);
            m_active_rating = m_DataSet(i,3);

            % rating count
            m_user_list(m_active_user_id,2) = m_user_list(m_active_user_id,2) + 1;
            
            % get minimum point
            if (m_user_list(m_active_user_id,3) > m_active_rating)
                m_user_list(m_active_user_id,3) = m_active_rating;
            end

            % if (mod(i,791783)==0)
            %     disp(i);
            % end

        end

        % shifting process
        for i=1:m_rating_count
            m_active_user_id = m_DataSet(i,1);
            m_active_item_id = m_DataSet(i,2);
            m_active_rating = m_DataSet(i,3);

            m_min_rating = m_user_list(m_active_user_id,3);

            m_active_rating = m_active_rating + abs(m_min_rating) + 1;
            m_DataSet(i,3) = m_active_rating;

        end

        
        % export 
        m_exportFilePath_mat = m_ExportPath + tempDataSetName + "/" + "shifted_" + m_fileName;
        m_exportFilePath_csv = strrep(m_exportFilePath_mat,'mat','csv');

        save(m_exportFilePath_mat, 'm_DataSet', '-v7.3');
        writematrix(m_DataSet,m_exportFilePath_csv);

        % log and progress
        total_calc = size(data_set_collection,2) * size(m_fileList,1);
        current_calc = dataSetCounter * fileCounter;
        disp(strcat(datestr(datetime("now")), " ", m_fileName," created. (", num2str(current_calc),"/",num2str(total_calc),")"));
    end
end

disp("Finish c5_shifting_IBPR");