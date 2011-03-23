clear all
close all

input_filename='G:\matlabnetworkplan\PESQ\composite\sp09_babble_sn10.wav';
%input_filename='e:\B_NoNois.wav';

x_Org=wavread(input_filename);
%sound(x)
%pause
%x=wavread(input_filename);
%sound(x);
%pause
N1=1;
N2=120;
%Echo_time=[25 30 35 40 45 50 55 60];%err=[0 0 0 1 0 1 2 1 2 1]
%Echo_time=[15 18 21 24 27 30 33 36];%err=[2 0 0 0 0 2 1 1 0 1]
%Echo_time=[15 17 19 21 23 25 27 29];
Echo_time=[12 13 14 15 16 17 18 19];
%Echo_time=[30 33 36 39 42 45 48 51];%err=[2 0 0 1 0 1 0 1 1 0]
%Echo_time=[40 43 46 49 52 55 58 61];%err=[3 0 1 1 0 1 1 2 1 0]
%Echo_time=[40 42 44 46 48 50 52 54];%err=6
%Echo_time=[40 41 42 43 44 45 46 47];%err=6
%Echo_time=[60 61 62 63 64 65 66 67];%err=6
%Echo_time=[60 63 66 69 72 75 78 81];%err=[1 0 0 0 0 0 0 0 1 0]
%Echo_time=[80 83 86 89 92 95 98 101];%err=[2 0 0 0 0 0 0 0 0 0]
alpha=0.4;
FrameLength=N2-N1+1;
ErrorBit=0;

wnd=(hamming(FrameLength))';
Data=round(rand(1,100)/0.1);
    for i=1:length(Data)
        if Data(i)>=9 Data(i)=8;
           else if Data(i)==0 Data(i)=1;
                end
        end
     end
%Data=[1 2 3 4 5 6 7 8 1 4 5 6 7 7 1 8 
%      3 4 5 6 5 6 7 8 4 2 1 3 4 5 1 8 
 %     3 4 5 6 7 5 1 8 2 3 4 5 6 6 7 8
  %    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 
  %    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 
  %    1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 
   %   1 2 3 4 5 6 7 8 2 2 3 4 5 6 7 8
   %   1 2 3 4 5 6 7 8 ];%40
%%%% 产生发送数据
N=length(Data);
Rdata=ones(1,N);
y=zeros(1,N);

ErrorSymble=zeros(1,20);
for ii=1:10
 ErrorBit=0;   
 %%%%%%%%%%%%%%%%%% 处理一帧数据 %%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   for i=1:N % 发送N个数据
   x=wavread(input_filename,[N1,N2]);
   x=x.*hamming(FrameLength);
   n0=Echo_time(Data(i));
   x_b=echoshift(x',n0);
   x_f=echoshift(x',-n0);
      for n=1:FrameLength;
       x0(n)=x(n)+alpha*x_b(n)+alpha*x_f(n);
       xxx0(n)=x0(n)+alpha*xx_b(n);
   end
   x0=x'+alpha*x_b+alpha*x_f;   
 sound(x0)
 y=[y,x0];
 x0=x0.*wnd;
 c0=rceps(x0);

 %figure
 plot(0:FrameLength/2,c0(1:FrameLength/2+1)/max(abs(c0)),'r')
 N1=N1+FrameLength;
 N2=N2+FrameLength;
 %figure
 plot(0:FrameLength/2,c0(1:FrameLength/2+1)/max(abs(c0)),'r')
 %%%%%%%%% 确定峰值的位置 %%%%%%%%%%%%%%%%%%%%%%%
 % maxc0=max(c0(5:FrameLength/2));
     %for k=5:FrameLength/2
        %if c0(k)==maxc0
          %Rdelay(i)=k-1;
          %end
          %end    
 %%%%%%%%%%%%%%%%%%% 放音延时 %%%%%%%%%%%%%
 %      for l=1:1:600
 %         for m=1:600
 %           ppp=abs(5);
 %         end
 %     end
%%%%%%%%%%%% 确定峰值位置所对应的接收数据 %%%%%%%%%%%%%%%%%%%%%%%%%%
       for j=1:8
         %if ((Rdelay(i)>=Echo_time(j)-11)|(Rdelay(i)<=Echo_time(j)-9))
           if (Rdelay(i)==Echo_time(j))     Rdata(i)=j;
%%%%%%%%%%%%%%%%%% ?????????????? else  ????????            
          end
       end 
%%%%%%%%%%%%% 计算误码率 %%%%%%%%%%%%%%%%%%%%%%
    
         if Data(i)~=Rdata(i)
           ErrorBit=ErrorBit+1;
         end
  end   
    ErrorSymble(ii)=ErrorBit;
end
   
%plot(0:11,ErrorSymble)
%sound(y,8000)
     
  
 plot(ErrorSymble)
 sound(y,8000)
%%%%%%%%%%%%%%%%%%%% 判决准则仍有问题 应加容错 


%带通滤拨( 逼近理想带通)
fs=8000;
wp=[400,3200]/(fs/2);
ws=[350,3250]/(fs/2);
rp=0.001;
rs=30;
 [n,wn]=cheb1ord(wp,ws,rp,rs);
[b,a]=cheby1(n,rp,wn);
[h,w]=freqz(b,a);
plot(w*fs/(2*pi),abs(h))

%的 到短时 能 ;量, 加 窗,FFT


input_filename='G:\matlabnetworkplan\PESQ\composite\sp09.wav';
 N=240;
 Y=wavread(input_filename,[1 18000]);
 L=length(Y);
 LL=length(Y)/N;
 Em=zeros(1,(LL-1)*240);
 for ii=1:(LL-1)*240
temp=Y(ii:ii+240-1);
temp=temp.*hamming(240);
Em(ii)=sum(temp.*temp);
end
plot(jj,Em);
jj=[1:(LL-1)*240];
subplot(4,1,1);
YY=fft(Em,256);
 f=500*(0:128)/256;
 plot(f,YY(1:129));





% 汉明窗的短时的付立叶变换
input_filename='e:\B012_Ori.wav';
offset=17700;
N=400;
fid=fopen(input_filename,'r');
fseek(fid,offset*2,-1);
[y,count]=fread(fid,N,'int16');
fclose(fid);
y=y.*hamming(N);
%画出时域波形图
figure(1);
subplot(2,1,1);
x=0:N-1;
plot(x,y)
%画出频谱图
figure(2);
FFTSIZE=8000;
Y=zeros(FFTSIZE,1);
Y=20*log10(abs(fft(y,FFTSIZE)));
plot(Y(1:4000));
