% Removing all variables, functions, and MEX-files from memory, leaving the
% workspace empty.
clear all


% Deleting all figures whose handles are not hidden.
close all


% Deleting all figures including those with hidden handles.
close all hidden


% Clearing all input and output from the Command Window display giving us a clean screen.
clc


% Opening the file 'TEOTH.mp3' in the read access mode.
fid = fopen ('TEOTH.mp3','r');


% Generating the input signal 'm(t)' by reading the binary data in 16 bit
% integer format from the specified file and writing it into a matrix
% 'm(t)'.
m = fread (fid,'int16');


% Defining the count for efficiency.
count = 8500;


% Calculating maximum value of the input signal 'm(t)'.
Mp = max (m)


% Setting number of bits in a symbol.
bits = 8;


% Defining the number of levels of uniform quantization.
levels = 2^bits;


% Calculating the step size of the quantization.
step_size = (2*Mp)/levels


% Setting the sampling frequency.
% because the audio signal has a maximum frequency of 4K and according to
% Nyquist criteria, we get the following sampling frequency.
Fs = 8000;


% Setting the sampling instant.
Ts = 1;


% Setting the number of samples to be used.
No_Samples = (2*Fs)+Ts;


% Define the time vector for the calculations.
time = [1:Fs/64];


% Calculating the bit rate.
bit_rate = 8000*bits;


% Quantizing the input signal 'm(t)'.
for k = 1:No_Samples,
    samp_in(k) = m(k*Ts);
    quant_in(k) = samp_in(k)/step_size;
    error(k) = (samp_in(k) - quant_in(k))/No_Samples;
end


% Indicating the sign of the input signal 'm(t)' and calculating the
% quantized signal 'quant_out'.
signS = sign (m);
quant_out = quant_in;
for i = 1:count,
    S(i) = abs (quant_in(i)) + 0.5;
    quant_out(i) = signS(i)*round(S(i))*step_size;
end


% Calculating the quantization noise 'Nq'.
Nq = ((Mp)^2)/(3*((levels)^2))


% Calculating signal to noise ratio 'SNR'.
SNR = 1.5*((levels)^2)
Gms = log10(SNR)


% Plotting the input signal 'm(t)'.
%figure;
subplot(4,1,1);
plot(time,m(time));
title('Message Signal');
xlabel('Time');
ylabel('m(t)');
grid on;


% Plotting the quantized signal 'quant_in(t)'.
%figure;
subplot(4,1,2);
stem(time,quant_in(time),'r');
title('Quantized Speech Signal');
xlabel('Time');
ylabel('Levels');
grid on;


% Plotting the PCM signal 's_out(t)'.
%figure;
subplot(4,1,3);
plot(time,quant_out(time));
title('PCM Speech Signal');
xlabel('Time');
ylabel('PC Signal');
grid on;


% Plotting the error signal 'error(t)'.
subplot(4,1,4);
plot(time,error(time));
title('Error Signal');
xlabel('Time');
ylabel('Error(t)');
grid on;


% Removing all variables, functions, and MEX-files from memory, leaving the
% workspace empty.
clear all