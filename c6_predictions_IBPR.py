import datetime
import sys
import os
import math
import numpy as np
from os import listdir
from os.path import isfile, join

import pandas as pd
import cornac as cn
import scipy as sc
from scipy import stats, sparse
from recommenders.models.cornac.cornac_utils import predict_ranking, predict
from recommenders.utils.constants import SEED
from cornac.eval_methods import RatioSplit, cross_validation, stratified_split
from cornac.models import MF, PMF, BPR, BiVAECF, CausalRec, ComparERSub, AMR, C2PF, MTER, NARRE, PCRL, VAECF, CVAECF, CVAE, GMF, IBPR, MCF, MLP, NeuMF, VMF, CDR, COE, ConvMF, HPF, CDL, VBPR, EFM, SBPR, HFT, WBPR, SKMeans, OnlineIBPR, BaselineOnly, SVD, NMF, UserKNN  ## EASEᴿ import edilemedi

print("Script Started!")

def getTime(): return datetime.datetime.now().strftime("%Y/%m/%d %H:%M:%S")

predictionCalculationFlag = True
sourceFilePath = '../out/5_shifting/'
exportFilePath = '../out/6_predictions/'
dataCollection = ['DoubanBooks']
# dataCollection = ['MLM', 'Yelp', 'DoubanBooks']
# dataCollection = ['MLM', 'Yelp', 'Dianping', 'DoubanBooks']
m_file_counter = 0

for datasetName in dataCollection:
    currentSourceFilePath = sourceFilePath + datasetName + "/"
    currentExportFilePath = exportFilePath + datasetName + "/"

    m_file_list = [f for f in listdir(currentSourceFilePath) if isfile(join(currentSourceFilePath, f))]

    i = 0
    for my_file in m_file_list:
        if my_file.rfind('.csv') == -1:
            del m_file_list[i]
        i = i + 1

    for my_file in m_file_list:
        m_fileName = my_file
        sourceFile = currentSourceFilePath + m_fileName
        exportFile = currentExportFilePath

        m_file_counter = m_file_counter + 1
        # herşey buraya

        # if (predictionCalculationFlag) and (m_file_counter >= 201 and m_file_counter <= 250):   #   dell 1
        # if (predictionCalculationFlag) and (m_file_counter >= 141 and m_file_counter <= 200):   #   omen 2
        if (predictionCalculationFlag) and (m_file_counter >= 20 and  m_file_counter <= 20):
            # torch kur
            # IBPR
            m_dataset = pd.read_csv(sourceFile, sep=',', names=['user_id', 'item_id', 'rating'], low_memory=False)
            train_set = cn.data.Dataset.from_uir(m_dataset.itertuples(index=False), seed=SEED)
            # print(getTime(), " ", m_file_counter, " ", m_fileName + " " + sourceFile + " " + exportFile)

            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Starting")
            ibpr = cn.models.IBPR(k=20, max_iter=10, verbose=True).fit(train_set)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Making Predictions")
            PredictionsIBPR = predict_ranking(ibpr, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Exporting")
            PredictionsIBPR.to_csv(currentExportFilePath + m_fileName.replace("shifted_","").replace(".csv","") + "_" + "IBPR" + ".csv", sep=',')
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Finished")

        print(m_file_counter, m_fileName)

        # print(datasetName , " Finished")
print("")
print("Script Finished!")