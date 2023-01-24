% version
% generate_uir.m
% v8.2_29.09.2022
% notes:
%

function uir = generate_uir(DataSet)

    % read data and convert to struct 
    temp_DataSet = struct2cell(DataSet);
    DataSet = temp_DataSet{1};

    % rating count to use in loop 
    observation_count = size(DataSet,1);
    
    % create user item vector
    user_vector = DataSet(:,1);
    item_vector = DataSet(:,2); 
    % rating_vector = DataSet(:,3);
    
    user_count = max(user_vector);
    item_count = max(item_vector);

    %user_count_2 = (unique(user_vector));
    %item_count_2 = (unique(item_vector));

    user_count = size(unique(user_vector),1);
    item_count = size(unique(item_vector),1);
    % 3952 - 3706 = 246
    
    % create empty matrix
    uir = zeros(user_count,item_count,'uint32');
    uir = double(uir);
    
    % to all  ratings
    for i=1:observation_count
        user = DataSet(i,1);
        item = DataSet(i,2);
        rating = DataSet(i,3);
        
        % rating assign to matrix with related address 
        uir(user,item) = rating;
    end
end




