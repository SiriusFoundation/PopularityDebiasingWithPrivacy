% version
% generate_disguise.m
% v8.2_29.09.2022
% notes:
%

function [m_disguise_unif, m_disguise_norm] = generate_disguise(TU, betamax, sigmamax)

%disp("Start generate_disguise");

temp_DataSet = struct2cell(TU);
TU = temp_DataSet{1};

dTU = TU;

% all process wil be done to all users
for userid=1:size(dTU,1)
    % find indexes which ratings not equal to zero 
    indexOfRatings = find(dTU(userid,:)~=0);

    %ratings assigned to vector
    ratings(1,1:size(indexOfRatings,2)) = dTU(userid,indexOfRatings);    
    
    % calculate average and standart deviation
    average=mean(ratings);
    standarddeviation = std(ratings);   

    % to calculate z score: substract from rating divide to ss
    for i=1:size(indexOfRatings,2)
        dTU(userid,indexOfRatings(1,i)) = (dTU(userid,indexOfRatings(1,i))-average)/standarddeviation;
    end
end

%disp("Finish generate_disguise");

m_disguise_unif = dTU;
m_disguise_norm = dTU;

% calculate random number to add ratings
for userid=1:size(dTU,1)
    stddev = sigmamax * rand(1);
    delta = (betamax * rand(1))/100;
    indexOfEmptyCells = find(dTU(userid,:)==0);
    indexOfRatings = find(dTU(userid,:)~=0);
    randindex = randperm(size(indexOfEmptyCells,2));
    numberOfEmptyCellsToBeFilled = floor(delta*size(randindex,2));
    numberOfRatingsToBeDisguised = size(indexOfRatings,2);
    totalNumberOfCells = numberOfEmptyCellsToBeFilled + numberOfRatingsToBeDisguised;
        
    % unif
    alpha = sqrt(3) * stddev;
    unif_randomNumbers(1,1:totalNumberOfCells)=random('unif',-alpha,alpha,1,totalNumberOfCells);

    % norm
    norm_randomNumbers(1,1:totalNumberOfCells)=random('norm',0,stddev,1,totalNumberOfCells);
    
    indexOfRandomNumbers = 1;

    % perturbation: disguise ratings
    for i=1:numberOfRatingsToBeDisguised
      % dTU(userid,indexOfRatings(1,i)) = dTU(userid,indexOfRatings(1,i)) + randomNumbers(1,indexOfRandomNumbers);
        m_disguise_unif(userid,indexOfRatings(1,i)) = m_disguise_unif(userid,indexOfRatings(1,i)) + unif_randomNumbers(1,indexOfRandomNumbers);
        m_disguise_norm(userid,indexOfRatings(1,i)) = m_disguise_norm(userid,indexOfRatings(1,i)) + norm_randomNumbers(1,indexOfRandomNumbers);

        indexOfRandomNumbers = indexOfRandomNumbers + 1;
    end

    % obfuscation: add fake ratings to empty cell
    for i=1:numberOfEmptyCellsToBeFilled
      % dTU(userid,indexOfEmptyCells(1,randindex(1,i))) = randomNumbers(1,indexOfRandomNumbers);
        m_disguise_unif(userid,indexOfEmptyCells(1,randindex(1,i))) = unif_randomNumbers(1,indexOfRandomNumbers);
        m_disguise_norm(userid,indexOfEmptyCells(1,randindex(1,i))) = norm_randomNumbers(1,indexOfRandomNumbers);
                
        indexOfRandomNumbers = indexOfRandomNumbers + 1;
    end    
end

end




