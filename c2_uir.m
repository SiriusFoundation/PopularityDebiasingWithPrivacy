% version
% create_2_uir.m
% v8.2_29.09.2022
% notes:
% for control
% mean(nonzeros(m_uir(1,:)))

clc;
clear;

disp("Start create_2_uir");

% convert every dataset to uir format

% read data
DataSet_MLM = load('../out/1_raw/MLM.mat');
% generate matrix with generate_uir method
m_uir = generate_uir(DataSet_MLM);
% save matrix (use v7.3 for big dataset)
save('../out/2_uir/MLM.mat', 'm_uir', '-v7.3');
disp("MLM UIR Created!");

DataSet_DoubanBooks = load('../out/1_raw/DoubanBooks.mat');
m_uir = generate_uir(DataSet_DoubanBooks);
save('../out/2_uir/DoubanBooks.mat', 'm_uir', '-v7.3');
disp("DoubanBooks UIR Created!");

DataSet_Yelp = load('../out/1_raw/Yelp.mat');
m_uir = generate_uir(DataSet_Yelp);
save('../out/2_uir/Yelp.mat', 'm_uir', '-v7.3');
disp("Yelp UIR Created!");

% DataSet_Dianping = load('../out/1_raw/Dianping.mat');
% m_uir = generate_uir(DataSet_Dianping);
% save('../out/2_uir/Dianping.mat', 'm_uir', '-v7.3');
% disp("Dianping UIR Created!");

disp("Finish create_2_uir");
