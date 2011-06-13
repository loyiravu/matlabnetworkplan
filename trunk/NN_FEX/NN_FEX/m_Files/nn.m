%{

NN -  Creates forecasts of a time series on t+1 using nearest neighbour
  algorithm.


      Usage: [OutSample_For,InSample_For,InSample_Res]=nn(x,d,m,k,method,n)

      INPUT:  

              x - The time series to be forecasted (the function was
              originally made for stock price, but it accepts any kind of
              time series).

              d - the observation where the InSample forecasts will
              start. It also defines the training period of the
              algorithm. For example, if lenght(x)=500 and d=400, the
              values of 1:400 will be the training period for the
              forecasted value of 401. For the forecast of 402, the
              training period is 1:401, meaning that each time a new
              observation is available, the algorithm adds it to the
              training period. Please notes that the parameter d doesn't 
              have any effect on the out of sample forecasts.

              m - Embedding dimension (size of the histories).

              k - The number of nearest neigbours to be used in the
              construction of the forecasts.

              method - Defines the method to calculate the forecasts. Can
              take values 'absolute_distance' (default) or 'correlation'.
              More details about each method can be found at word
              document.

              n - Number of outsample Forecasts. The default value is 0.

      OUTPUT:
              OutSample_For - A vector with the out of sample forecasted
              values of the time series. The length of [OutSample_For] is
              n. Notes that the out sample forecasts are build with the
              whole modeled series x. 
               
              InSample_For  - A vector with the in sample forecasted
              values of the time series. The length of [InSample_For] is
              length(x)-d    

              InSample_Res  - A vector with the out-of-sample residues
              from the in-sample forecasts.

   
  Marcelo Scherer Perlin 
  Email: marceloperlin@gmail.com 
  Department of Finance. 
  University of Rio Grande do Sul/ Brazil. 
  Created: January/2006
  Last Update: January/2007

  This is the algorithm involved on the use of the non-linear forecast of
  asset's prices based on the nearest neighbour method, Perlin(2006). The
  rotines were build according to the work of Rodriguez, Rivero and
  Artilles (2001). A more complete description of the method can be found
  at the pdf document "description_of_NN.pdf" attached to the downloaded zip file.
  
  There is, also, an example file ("Example.mat") with daily observations
  of Ibovespa (Major Brazilian Market Index) from 2000-2005 (1242
  observations). Load up the .mat file and try:

  [OutSample_For,InSample_For,InSample_Res]=nn(Ibov,1000,3,50,'absolute_distance',5)

  Feel Free to use, re-use or modify the function. Since i'm a beginner
  programmer, please send your feedback to the MatLab Exchange Site. I'm
  also open to suggestions.
  
  References:

  FERNÁNDEZ-RODRÍGUEZ, F., SOSVILLA-RIVERO, S., GARCÍA-ARTILES, M. An
  empirical evaluation of non-linear trading rules. Working paper, n. 16,
  FEDEA, 2001. Available at:
  http://papers.ssrn.com/sol3/papers.cfm?abstract_id=286471

  PERLIN, M. S. Non Parametric Modelling in Major Latin America Market
  Indexes: An Analysis of the Performance from the Nearest Neighbor
  Algorithm in Trading Strategies. BALAS Conference, Lima, Peru, 2006.

%}

function [OutSample_For,InSample_For,InSample_Res]=nn(x,d,m,k,method,n)

if (nargin<4)
    error('Its missing arguments.')
end

if d>=length(x)
    error('The value of d must be between 1 and length(x)-1')
end

if (nargin==4)
    n=0;
    method='absolute_distance';
    OutSample_For=[];
end

if (nargin==5)
    n=0;
    OutSample_For=[];
end

% Main Loop.

for v=0:length(x)-d-1;
    
     Series=x(1:d+v);
    
    [For]=nn_core(Series,m,k,method);
        
    InSample_For(v+1,1)=For;
    
    fprintf(1,['\nCalculating NN Forecast #',num2str(v+1)]);
    
end

disp(' ');

InSample_Res=x(d+1:length(x))-InSample_For;

if n~=0
    x2=x;
    for z=1:n
        [Out_For]=nn_core(x2,m,k,method);
        OutSample_For(z,1)=Out_For;
        x2=[x2;OutSample_For(z)];
    end
end