%   SNN -  Creates forecasts of a time series on t+1 using multivariate nearest neighbor algorithm.
% 
%   REQUIRES MREGRESS.M FILE available at http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=202&objectType=file
% 
% 
%       Usage: [OutSample_For_x,InSample_For_x,InSample_Res_x]=snn(x,y,d,m,k,n)
% 
%       Where:  
%               x - The time series to be forecasted (the function was originally made for stock prices, but it accepts any kind of time series).
% 
%               y - The independent time series that will help to find the nearest neighbours of x.
%               
%               d - the observation where the forecasts will start. It also defines the training period of the algorithm. For example, if lenght(x)=500 and d=400, the values of 1:400 will be the training period 
%                   for the forecasted value of 401. For the forecast of 402, the training period is 1:401, meaning that each time a new observation is available, the algorithm adds it to the training period.  
% 
%               m - Embedding dimension (size of the histories).
% 
%               k - The number of nearest neigbours to be used in the construction of the forecasts.
% 
%               n - Number of out Sample Forecasts for x
%
%       OUTPUT:
%               OutSample_For_x - A vector with the out of sample forecasted values of the time series. The length of [OutSample_For_x] is n. Notes that the out sample forecasts are build with the whole modeled series x. 
%                
%               InSample_For_x - A vector with the in sample forecasted values of the time series. The length of [InSample_For] is length(x)-d 
%
%               InSample_Res_x - A vector with the same size as InSample_For_x, with the residues from the in sample forecasts.
%                   
%         
%   Marcelo Scherer Perlin
%   Email: marceloperlin@gmail.com
%   Graduate Business School/Department of Finance
%   UFRGS - Federal University of Rio Grande do Sul/ Brazil
%   Created: March/2006
%   Last Update: November/2006    
% 
%   This is the algorithm involved on the use of the non-linear forecast of asset's prices
%   based on the simultaneous nearest neighbor method. The rotines were build according to the work of Rodriguez, Rivero and Artilles (2001).
%   A more complete description of the method can be found at the word document "detailed description of NN algorithm.doc" attached to the downloaded zip file.
%   
%   
%   Feel Free to use, re-use or modify the function.
%    
%   
%   REQUIRES MREGRESS.M FILE available at:
%   http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=202&objectType=file
% 
%   References:
% 
%   FERNÁNDEZ-RODRÍGUEZ, F., SOSVILLA-RIVERO, S., GARCÍA-ARTILES, M. An empirical evaluation of non-linear trading rules. Working paper, n. 16, FEDEA, 2001. 
%   Available at: http://papers.ssrn.com/sol3/papers.cfm?abstract_id=286471


function [OutSample_For_x,InSample_For_x,InSample_Res_x]=snn(x,y,d,m,k,n)

if (nargin<5)
    error('Its missing arguments.')
end

if d>length(x)-1
    error('The value of d must be between 1 and lenght(x)-1. If you want out of sample forecasts, use the parameter n.');
end


if (nargin==5)||n==0
    n=0;
    OutSample_For_x=[];
end

% Main Loop.

for v=0:length(x)-d-1;
    
    Series_x=x(1:d+v);
    Series_y=y(1:d+v);
 
    [For_x,For_y]=snn_core(Series_x,Series_y,m,k);
    
%   Calculation of the correlations between the pieces of the time series.
    
    InSample_For_x(v+1,1)=For_x;
    
    Finishes_when_it_reaches_1=v/(length(x)-d-1);
    
    Finishes_when_it_reaches_1
    
end

InSample_Res_x=x(d+1:length(x))-InSample_For_x

if n~=0
    x2=x;
    y2=y;
    for z=1:n
        [Out_For]=snn_core(x2,y2,m,k);
        OutSample_For_x(z,1)=Out_For;
        x2=[x2;OutSample_For_x(z,1)];
        y2=[y2;OutSample_For_x(z,1)];
    end
end



