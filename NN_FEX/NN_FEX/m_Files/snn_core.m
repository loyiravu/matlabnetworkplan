% DESCRIPTION:
% 
% Core function for snn.m
% 
% INPUT:
%         x - Series to be modelled
%         y - Series that will help to model x
%         m - Embedding dimension (size of the histories).
%         k - The number of nearest neigbours to be used in the construction of the forecasts.
%         
%  OUTPUT:
%         For_x - The one out of sample forecast of x made using the series x and y
%         For_y - The one out of sample forecast of y made using the series x and y
% 
%         
% POURPOSE: This core function will create each forecast in snn.m


function [For_x,For_y]=snn_core(x,y,m,k);


[n1,n2]=size(x);


%   Calculation of the correlations between the pieces of the time series.

chunkx = x(n1-m+1:n1,1);
chunky = y(n1-m+1:n1,1);

for i=0:n1-m-1;
    aba=corrcoef(chunkx,x(n1-m-i:n1-i-1,1));
    aba2=corrcoef(chunky,y(n1-m-i:n1-i-1,1));
    mcorrelX(n1-m-i,1)=abs(aba(2,1));
    mcorrelY(n1-m-i,1)=abs(aba2(2,1));
end;


mcorrel2=mcorrelX+mcorrelY;

%   Find the k max abs correlation and also the piece related to such k correlations.

[sorted idx] = sort(mcorrel2);

% idx=sort2(idx);

fullIdx = repmat(idx((end-k+1):end),1,m+1) + repmat([0:m],k,1);


%   REgression to find the coefficents of x.

s = x(fullIdx);

Coefficients = regress(s(:,m+1),[ones(k,1),s(:,m:-1:1)]);

c = ones(1,m+1);
c(2:end) = x(n1+2 - [2:m+1]);

For_x(1,1)=c*Coefficients;    

%   REgression to find the coefficents of y

s2 = y(fullIdx);

Coefficients = regress(s2(:,m+1),[ones(k,1),s2(:,m:-1:1)]);

c = ones(1,m+1);
c(2:end) = y(n1+2 - [2:m+1]);

For_y(1,1)=c*Coefficients; 