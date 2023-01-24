function [MostPopVector, ItemAVGVector] =NonPersonalized(Data)
format long g
% Input: 
% Data: Original rating matrix (mxn format)

% Output:
% MostPopVector: Predictions for MostPop algorithm (vector format, nx3)
% ItemAVGVector: Predictions for ItemAVG algorithm (vector format, nx3)

% Computing Popularity of items
Pop=sum(Data~=0,1);
% Computing average rating of items
B=Data;
B(Data==0)=nan;
ItemMeans = nanmean(B);
ItemMeans(isnan(ItemMeans))=0;

TotalPredictionNumber=size(Data,1)*size(Data,2);
MostPopVector=zeros(TotalPredictionNumber,3);
ItemAVGVector=zeros(TotalPredictionNumber,3);
row=1;
for user=1:size(Data,1)
    for item=1:size(Data,2)
        % Constructing MostPop predictions
        MostPopVector(row,1)=user;
        MostPopVector(row,2)=item;
        MostPopVector(row,3)=Pop(1,item);
        
        % Constructing ItemAVG predictions
        ItemAVGVector(row,1)=user;
        ItemAVGVector(row,2)=item;
        ItemAVGVector(row,3)=ItemMeans(1,item);

        row=row+1;
    end
end


return 
end




