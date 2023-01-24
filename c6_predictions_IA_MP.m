% item average, most populer
% NonPersonalized

clc;
clear;

disp("Start c6_predictions_IA_MP");

m_ImportPath = "../out/3_disguise/";
m_ExportPath = "../out/6_predictions/";

data_set_collection = ["Yelp"];
% data_set_collection = ["DoubanBooks", "Yelp"];
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

        % call nonPersonalized
        [MostPopVector, ItemAVGVector] = NonPersonalized(m_DataSet);
        
        % export
        % path
        m_exportFilePath_MP_mat = m_ExportPath + tempDataSetName + "/" + m_fileName + "_MP" ;
        m_exportFilePath_MP_mat = strrep(m_exportFilePath_MP_mat,'.mat','') + ".mat";
        m_exportFilePath_MP_csv = strrep(m_exportFilePath_MP_mat,'.mat','.csv');

        m_exportFilePath_IA_mat = m_ExportPath + tempDataSetName + "/" + m_fileName + "_IA" ;
        m_exportFilePath_IA_mat = strrep(m_exportFilePath_IA_mat,'.mat','') + ".mat";
        m_exportFilePath_IA_csv = strrep(m_exportFilePath_IA_mat,'.mat','.csv');


        % save MAT
        % save(m_exportFilePath_MP_mat, 'MostPopVector', '-v7.3');
        % save(m_exportFilePath_IA_mat, 'ItemAVGVector', '-v7.3');

        % save csv
        writematrix(MostPopVector, m_exportFilePath_MP_csv);
        % writematrix(ItemAVGVector, m_exportFilePath_IA_csv);


        % log ve progress
        total_calc = size(data_set_collection,2) * size(m_fileList,1);
        current_calc = dataSetCounter * fileCounter;
        disp(strcat(datestr(datetime("now")), " ", m_fileName," created. (", num2str(current_calc),"/",num2str(total_calc),")"));
    end
end

disp("Finish c6_predictions_IA_MP");