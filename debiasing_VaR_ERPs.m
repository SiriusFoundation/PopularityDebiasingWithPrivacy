function  [VarTopN, MulTopN, AugTopN] = VaR_ERPs(Dataset,PredMatrix)
% Input:
% Dataset: mxn format rating dataset
% Predictions: nx3 prediction data
% Output:
% TopNRecs: mx10 format topn list where m is the number of users

%% Construct Prediction Matrix (mxn)
Predictions=zeros(size(Dataset,1),size(Dataset,2));
for row=1:size(PredMatrix,1)
	UserID=PredMatrix(row,1);
	ItemID=PredMatrix(row,2);
	Rating=PredMatrix(row,3);
	Predictions(UserID,ItemID)=Rating;
end


%% Determine popularity of each item in original range
Pop=sum(Dataset~=0);

VarTopN = zeros(size(Dataset,1),10);
MulTopN = zeros(size(Dataset,1),10);
AugTopN = zeros(size(Dataset,1),10);

for user=1:size(Dataset,1)
    [VarTopN(user,:), MulTopN(user,:), AugTopN(user,:)] = VaR_ERP_Ranking(Predictions(user,:), Pop, 10);
    % user
end



return
end

function [TopN_VaR, TopN_Erp_Mul, TopN_Erp_Aug] = VaR_ERP_Ranking (Predictions, Pop, N)
%%  Input parameters:
%   Predictions:prediction vectors for the user 1xN
%   PopI: Number of times each item rated 1xN
%   N: size of top-N list
lambda = 0.5;
PopItems=Pop/size(Predictions,1);
PredNorms=normalize(Predictions(1,:),'range');
PopItemsNorm=normalize(PopItems(1,:),'range');
weightERPs = 1-PopItemsNorm;

% Calculate weights:
VaRRankingScores = zeros(1,size(PopItemsNorm,2));
for item=1:size(PopItemsNorm,2)
    VaRRankingScores(1,item) = ((1-lambda)*PredNorms(1,item)) + (lambda*(1/log10(Pop(1,item))));
    ErpMulRankingScores(1,item) = PredNorms(1,item)*weightERPs(1,item);
    ErpAugRankingScores(1,item) = (PredNorms(1,item)*weightERPs(1,item)) + PredNorms(1,item);
end

[a, TopN_VaR] = maxk(VaRRankingScores(1,:),N);
[a, TopN_Erp_Mul] = maxk(ErpMulRankingScores(1,:),N);
[a, TopN_Erp_Aug] = maxk(ErpAugRankingScores(1,:),N);

return
end













