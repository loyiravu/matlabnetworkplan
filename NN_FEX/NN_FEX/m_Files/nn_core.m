%{

DESCRIPTION:

Core function for nn.m

INPUT:
        x - Series to be modelled
        m - Embedding dimension (size of the histories)
        k - The number of nearest neigbours to be used in the construction 
            of the forecasts
        method - The method to be used in the calculations
      
        
 OUTPUT:
        For_x - The one out of sample forecast of x
         
        
POURPOSE: This core function will create each forecast in nn.m

%}

function [For_x]=nn_core(x,m,k,method);


[n1,n2]=size(x);

switch method
    case 'correlation'

        %   Calculation of the correlations between the pieces of the time series.

        chunk = x(n1-m+1:n1,1);
        for i=0:n1-m-1;
            aba=corrcoef(chunk,x(n1-m-i:n1-i-1,1));
            mcorrel(n1-m-i,1)=aba(2,1);
        end;

        mcorrel2=abs(mcorrel);

        %   Find the k max abs correlation and also the piece related to such k correlations.

        [sorted idx] = sort(mcorrel2);

        fullIdx = repmat( idx((end-k+1):end),1,m+1) + repmat([0:m],k,1);

        %   REgression to find the coefficents.
        
        s = x(fullIdx);

        Coefficients = regress(s(:,m+1),[ones(k,1),s(:,m:-1:1)]);

        c = ones(1,m+1);
        c(2:end) = x(n1+2 - [2:m+1]);

        For_x(1,1)=c*Coefficients;

    case 'absolute_distance'
        
        %   Calculation of the sum of distances between the pieces of the time series.

        chunk = x(n1-m+1:n1,1);
        for i=0:n1-m-1;
            distance=sum(abs(chunk-x(n1-m-i:n1-i-1,1)));
            sum_distance(n1-m-i,1)=distance;
        end
        
        % Sort the distances and find the lowests
        
        [sorted idx] = sort(sum_distance,'descend');
        
        % Create a matrix with the indexes of the neighbors found
        
        fullIdx = repmat( idx((end-k+1):end),1,m+1) + repmat([0:m],k,1);
        
        % Grab the values of such neighbors
        
        s = x(fullIdx);
        
        % Calculate the forecast
                
        For_x(1,1)=mean(s(:,m+1));
end
        
        
        
        
        