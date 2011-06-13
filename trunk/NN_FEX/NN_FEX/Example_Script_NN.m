% Example Script for NN

% This script will model a time series using the two different methods
% and then plot the forecasts versus real points

addpath('m_Files');

load Example_Data.mat;

x=Ibov;     % Load data from .mat file
d=1000;     % Defines where to start the forecasts
m=3;        % Size of histories (embeding dimension)
k=20;       % Number of nearest neighbors to use in the forecast's calculation

method_1='correlation';         
method_2='absolute_distance';

[OutSample_For_Corr,InSample_For_Corr,InSample_Res_Corr]=nn(x,d,m,k,method_1);

[OutSample_For_Abs,InSample_For_Abs,InSample_Res_Abs]=nn(x,d,m,k,method_2);

plot([x(d+1:end),InSample_For_Corr,InSample_For_Abs]);
xlabel('Time');
ylabel('Values');
title(['Forecasts VS Real values (m=',num2str(m),' , k=',num2str(k),' d=',num2str(d),')']);
legend('Ibov Real Series','NN forecast with correlation Method','NN forecast with abs distance Method');

rmpath('m_Files');