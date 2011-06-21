%径向基神经网络

clc;
clear;
%load matlab;
load yn;
load xite;
P=yn(:,1:5);
T=yn(:,6:7);
net=newgrnn(P',T',0.7);
A=sim(net,P');
p=xite;
a=sim(net,p')
a'
