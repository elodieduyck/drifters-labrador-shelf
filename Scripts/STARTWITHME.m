%%%%% Set path and working folder %%%%%%

% Set where you saved the project
global path_start
path_start='C:\Users\u241341\Documents\2-Work_published\5-Labrador_shelf\';
% add the folders where the scripts are stored
addpath(genpath([path_start 'Scripts\LOAD\']))   
addpath(genpath([path_start 'Scripts\COMP\']))   
addpath(genpath([path_start 'Scripts\PLOT\']))   

% Data from the project \ that you downloaded
global data_folder
data_folder=[path_start 'Data\'];

% Additional libraries
addpath(genpath(['C:\Users\u241341\Documents\4-Scripts\MATLAB\tools']))   