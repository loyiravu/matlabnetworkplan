function [chain,state]=markov(T,n,s0,V);
%function [chain,state]=markov(T,n,s0,V);
%  chain generates a simulation from a Markov chain of dimension
%  the size of T
%
%  T is transition matrix
%  n is number of periods to simulate
%  s0 is initial state (initial probabilities)
%  V is the quantity corresponding to each state
%  state is a matrix recording the number of the realized state at time t
%
% Original author: Tom Sargent
% Comments added by Qiang Chen


[r c]=size(T);   % r is # of rows, c is # of columns of T
if nargin == 1;  % "nargin" refers to "number of arguments in". So only T is provided in this case
  V=[1:r];
  s0=1;
  n=100;
end;
if nargin == 2;  % both T and n are provided 
  V=[1:r];
  s0=1;
end;
if nargin == 3;  % T, n and S0 are provided
  V=[1:r];
end;
% check if the transition matrix T is square
if r ~= c;  
  disp('error using markov function');
  disp('transition matrix must be square');
  return;  % break the program and return
end;
% check if each row of T sums up to 1
for k=1:r;
  if sum(T(k,:)) ~= 1;
   disp('error using markov function')
    disp(['row ',num2str(k),' does not sum to one']);  % "num2str" converts numbers to a string. 
    disp(' it sums to :'); 
    disp([ sum(T(k,:)) ]); 
    disp(['normalizing row ',num2str(k),'']);
    T(k,:)=T(k,:)/sum(T(k,:));
  end;
end;
[v1 v2]=size(V);
if v1 ~= 1 | v2 ~=r   % "|" means "or"
  disp('error using markov function'); 
  disp(['state value vector V must be 1 x ',num2str(r),''])
  if v2 == 1 &v2 == r;
    disp('transposing state valuation vector');
    V=V';  % change it to a column vector
  else;
    return;
  end;  
end
if s0 < 1 |s0 > r;
  disp(['initial state ',num2str(s0),' is out of range']);
  disp(['initial state defaulting to 1']);
  s0=1;
end;

% The simulation of Markov chain formally starts from here
%T
%rand('uniform');

X=rand(n-1,1);  % generate (n-1) random numbers drawn from uniform distribution on [0,1], each number to be used in one simulation.

s=zeros(r,1);   % initiate the state vector "s" to be a rx1 zero vector

s(s0)=1;        % change the "s0"th element of "s" to 1

cum=T*triu(ones(size(T))); 
% "triu(ones(size(T)))" generates an upper triangular matrix with all elements equal to 1
% cum is a rxr matrix whose ith column is the cumulative sum from the 1st column to the ith column 
% the ith row of cum is the cumulative distribution for the next period given the current state. 

for k=1:length(X);  % "length(X)" returns the size of the longest dimension of X. "k" indicates the kth simulation. 
    
  state(:,k)=s;     % state is a matrix recording the number of the realized state at time k 
  
  ppi=[0 s'*cum];   % this is the conditional cumulative distribution for the next period given the current state s
  
  s=((X(k)<=ppi(2:r+1)).*(X(k)>ppi(1:r)))';    
  % compares each element of ppi(2:r+1) or ppi(1:r) with a scalar X(k), and
  % returns 1 if the inequality holds and 0 otherwise
  % this formula assigns 1 when both inequalities hold, and 0 otherwise
  
end;
chain=V*state;
