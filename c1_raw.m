% version
% create_1_raw.m
% v8.2_29.09.2022
% notes:
%

clc;
clear;

disp("Start create_1_raw");

% import raw data to workplace
copyfile('../out/0_input/*.mat', '../out/1_raw/');

disp("Finish create_1_raw");