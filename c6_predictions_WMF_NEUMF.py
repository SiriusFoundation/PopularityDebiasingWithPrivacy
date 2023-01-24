# 2 algorithm
# for_TF create ettim
# conda activate for_TF2
# pip install recommenders
# pip install tensorflow==1.15.5
# pip install protobuf==3.20.*

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
sourceFilePath = '../out/4_uir_vector/'
exportFilePath = '../out/6_predictions/'
# dataCollection = ['MLM', 'Yelp', 'Dianping', 'DoubanBooks']
dataCollection = ['MLM', 'Yelp', 'DoubanBooks']
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

        m_dataset = pd.read_csv(sourceFile, sep=',', names=['user_id', 'item_id', 'rating'], low_memory=False)
        train_set = cn.data.Dataset.from_uir(m_dataset.itertuples(index=False), seed=SEED)

        m_file_counter = m_file_counter + 1
        # print(getTime(), " ", m_file_counter, " ", m_fileName + " " + sourceFile + " " + exportFile)

        # block
        if predictionCalculationFlag:

            # # MMF
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "MMF" , " " , "Starting")
            # mmmf = cn.models.MMMF(k=10, max_iter=200, learning_rate=0.01, verbose=True).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "MMF" , " " , "Making Predictions")
            # PredictionsMMMF = predict_ranking(mmmf, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "MMF" , " " , "Exporting")
            # PredictionsMMMF.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "MMMF" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "MMF" , " " , "Finished")
            #
            # # HPF
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "HPF" , " " , "Starting")
            # hpf = cn.models.HPF(k=5, seed=42, hierarchical=False).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "HPF" , " " , "Making Predictions")
            # PredictionsHPF = predict_ranking(hpf, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "HPF" , " " , "Exporting")
            # PredictionsHPF.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "HPF" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "HPF" , " " , "Finished")
            #
            # # WBPR
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WBPR" , " " , "Starting")
            # wbpr = cn.models.WBPR(k=50, max_iter=200, learning_rate=0.001, lambda_reg=0.001, verbose=True).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WBPR" , " " , "Making Predictions")
            # PredictionsWBPR = predict_ranking(wbpr, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WBPR" , " " , "Exporting")
            # PredictionsWBPR.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "WBPR" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WBPR" , " " , "Finished")
            #
            # # SKM
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "SKM" , " " , "Starting")
            # skm = cn.models.SKMeans(k=5, max_iter=100, tol=1e-10, seed=42).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "SKM" , " " , "Making Predictions")
            # PredictionsSKM = predict_ranking(skm, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "SKM" , " " , "Exporting")
            # PredictionsSKM.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "SKM" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "SKM" , " " , "Finished")
            #
            # # torch
            # # VAECF
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "VAECF" , " " , "Starting")
            # vaeCF = cn.models.VAECF(k=10, autoencoder_structure=[20], act_fn="tanh", likelihood="mult", n_epochs=100, batch_size=100, learning_rate=0.001, beta=1.0, seed=123, use_gpu=True, verbose=True).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "VAECF" , " " , "Making Predictions")
            # PredictionsVAECF = predict_ranking(vaeCF, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "VAECF" , " " , "Exporting")
            # PredictionsVAECF.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "VAECF" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "VAECF" , " " , "Finished")

            # tensorflow
            # WMF
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WMF" , " " , "Starting")
            wmf = cn.models.WMF(k=50, max_iter=50, learning_rate=0.001, lambda_u=0.01, lambda_v=0.01, verbose=True, seed=123).fit(train_set)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WMF" , " " , "Making Predictions")
            PredictionsWMF = predict_ranking(wmf, m_dataset, usercol='user_id', itemcol='item_id',remove_seen=False)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WMF" , " " , "Exporting")
            PredictionsWMF.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "WMF" + ".csv", sep=',')
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "WMF" , " " , "Finished")

            # tensorflow
            # NEUMF
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "NEUMF" , " " , "Starting")
            neumf = cn.models.NeuMF(num_factors=8, layers=[32, 16, 8], act_fn="tanh", num_epochs=1, num_neg=3, batch_size=256, lr=0.001, seed=42, verbose=True).fit(train_set)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "NEUMF" , " " , "Making Predictions")
            PredictionsNEUMF = predict_ranking(neumf, m_dataset, usercol='user_id', itemcol='item_id',remove_seen=False)
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "NEUMF" , " " , "Exporting")
            PredictionsNEUMF.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "NEUMF" + ".csv", sep=',')
            print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "NEUMF" , " " , "Finished")

            # torch
            # IBPR
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Starting")
            # ibpr = cn.models.IBPR(k=20, max_iter=10, verbose=True).fit(train_set)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Making Predictions")
            # PredictionsIBPR = predict_ranking(ibpr, m_dataset, usercol='user_id', itemcol='item_id', remove_seen=False)
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Exporting")
            # PredictionsIBPR.to_csv(currentExportFilePath + m_fileName.replace(".csv","") + "_" + "IBPR" + ".csv", sep=',')
            # print(getTime(), " ", m_file_counter , " " , m_fileName , " " , "IBPR" , " " , "Finished")

    # print(datasetName , " Finished")

print("")
print("Script Finished!")