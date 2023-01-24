function  [Avg,Results]=Metrics(Dataset, TopN)
format short g
% ----Input ----
% Dataset: Original data mxn (matris) format
% Predictions: Prediction matrix mx3 (vector) format (e.g., the file produced by Cornac)



%% Construct tail item set
Pop=sum(Dataset~=0);
PopItems=Pop/size(Dataset,1);
[outPop,idxPop]=sort(Pop,'descend');
LimitHead=(sum(Pop))*20/100;
top=0;HeadIDX=[]; TailIDX=[];
for i=1:size(idxPop,2)
    if (top<=LimitHead)
        top=top+outPop(1,i);
        HeadIDX = [HeadIDX; idxPop(1,i)];
    else
        top=top+outPop(1,i);
        TailIDX = [TailIDX; idxPop(1,i)];
    end
end


%% Calculate metrics for all users:
GAPp=zeros(size(Dataset,1),1);
GAPr=zeros(size(Dataset,1),1);
NDCG=zeros(size(Dataset,1),1);
Precision=zeros(size(Dataset,1),1);
Recall=zeros(size(Dataset,1),1);
F1=zeros(size(Dataset,1),1);
APLT=zeros(size(Dataset,1),1);
Novelty=zeros(size(Dataset,1),1);
DeltaGAP=zeros(size(Dataset,1),1);

for user=1:size(Dataset,1)
    GAPp(user,1)=GAPProfileFunc(Dataset(user,:),PopItems);
    GAPr(user,1)=GAPRecFunc(TopN(user,:),PopItems);
    DeltaGAP(user,1)= ((GAPr(user,1)-GAPp(user,1))/GAPp(user,1))*100;
    NDCG(user,1)=NDCGFunc(Dataset(user,:),TopN(user,:));
    [Precision(user,1),Recall(user,1),F1(user,1)] = PrecRecallFunc(Dataset(user,:),TopN(user,:));
    APLT(user,1) = APLTFunction(TailIDX,TopN(user,:));
    Novelty(user,1) = NoveltyFunction(Dataset(user,:),TopN(user,:));
end

%% Store all results in Avg variable (1-GAPp, 2-GAPr, 3-DeltaGAP(Individually mean), 4-DeltaGAP(Mean_ALL), 5-NDCG, 6-Precision, 
%% 7-Recall, 8-F1, 9-APLT, 10-Novelty, 11-LTC, 12-Entropy)
Results(:,1)=GAPp(:,1);
Results(:,2)=GAPr(:,1);
Results(:,3)=DeltaGAP(:,1);
Results(:,5)=NDCG(:,1);
Results(:,6)=Precision(:,1);
Results(:,7)=Recall(:,1);
Results(:,8)=F1(:,1);
Results(:,9)=APLT(:,1);
Results(:,10)=Novelty(:,1);

Avg = mean(Results);
Avg(1,4)=((Avg(1,2)-Avg(1,1))/Avg(1,1))*100;
Avg(1,11)=LongTailCoverage(TopN, TailIDX);
Avg(1,12)=EntropyCal(Dataset,TopN);

return
end

function [Entropy] = EntropyCal(Dataset,TopN)

% All recommended items
topnItems=TopN(1,:);
for i=2:size(TopN,1)
    topnItems = cat(2,topnItems,TopN(i,:));
end

itemNumber=size(Dataset,2);
Entropy=0;

for item=1:itemNumber
    pItem=size(find(topnItems==item),2)/size(topnItems,2);
    if(pItem~=0)
    Entropy =  Entropy - pItem*(log(pItem)/log(itemNumber));  
    end
end

return 
end

function [LTC] = LongTailCoverage(TopN, TailIDX)

% All recommended items
countLC=0;
topnItems=TopN(1,:);
for i=2:size(TopN,1)
    topnItems = cat(2,topnItems,TopN(i,:));
end
UnItems=unique(topnItems);
for i=1:size(UnItems,2)
        if (any(TailIDX==UnItems(1,i)))
            countLC=countLC+1;
        end
end

LTC=countLC/size(TailIDX,1);


return 
end

function [GAPp] = GAPProfileFunc(Profile, PopItems)
% --- Input ---
% Profile: User profile vector 1xn
% PopItems: Popularity of items 1xn

idx=find(Profile(1,:)~=0); total=0;
for i=1:size(idx,2)
    ItemID=idx(1,i);
    total=total+PopItems(1,ItemID);
end
GAPp=total/size(idx,2);
return
end

function [GAPr] = GAPRecFunc(TopN, PopItems)
% --- Input ---
% TopN: TopN recommendation list 1xN
% PopItems: Popularity of items nx1

total=0;
for i=1:size(TopN,2)
    ItemID=TopN(1,i);
    total=total+PopItems(1,ItemID);
end
GAPr=total/size(TopN,2);
return
end

function [nDCG] = NDCGFunc(Profile, TopN)
% --- Input ---
% Profile: User profile vector 1xn
% TopN: TopN recommendation list for the user 1xN
DCG=0; IDCG=0;
i=1;
[val,idx]=maxk(Profile(1,:),size(TopN,2));
for item=1:size(TopN,2)
    itemID=TopN(1,item);
    if(i==1)
        DCG=Profile(1,itemID);
        IDCG=val(1,item);
        i=i+1;
    else
        DCG=DCG+(Profile(1,itemID)/log2(item));
        IDCG=IDCG+(val(1,item)/log2(item));
    end
end

nDCG=DCG/IDCG;

return
end

function [prec,recall,f1] = PrecRecallFunc(Profile, TopN)
% --- Input ---
% Profile: User profile vector 1xn
% TopN: TopN recommendation list for the user 1xN

count=0;
for i=1:size(TopN,2)
    itemID=TopN(1,i);
    if(Profile(1,itemID)>=4)
        count=count+1;
    end
end

prec=count/size(TopN,2);
AllGood = size(find(Profile(1,:)>=4),2);
if(AllGood==0)
    recall=0;
else
    recall=count/AllGood;
end

if(prec+recall~=0)
    f1=(2*prec*recall)/(prec+recall);
else
    f1=0;
end

return
end

function [aplt] = APLTFunction (TailSet, TopN)
% --- Input ---
% TailSet: The set of tail items nx1
% TopN: TopN recommendation list for the user 1xN
count=0;
for item=1:size(TopN,2)
    itemID=TopN(1,item);
    if(ismember(itemID,TailSet))
        count=count+1;
    end
end

aplt=count/size(TopN,2);

return
end

function [novelty] = NoveltyFunction(Profile, TopN)
% --- Input ---
% Profile: User profile vector 1xn
% TopN: TopN recommendation list for the user 1xN
count=0;
for item=1:size(TopN,2)
    itemID=TopN(1,item);
    if(Profile(1,itemID)==0)
        count=count+1;
    end
end

novelty = count / size(TopN,2);

return
end









