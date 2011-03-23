t = [0:0.0001:1];                           % Set independent (time) variable.1
A = 1;                                      % Set amplitude.

%f_c = 261.63;                               % Create C tone.
f_c = 16.35;
tone_c = A*sin(2*pi*f_c*t);

%f_g = 392.00;                               % Create G tone.
f_g = 24.50;
tone_g = A*sin(2*pi*f_g*t);
subplot(2,1,1);plot(tone_c);
subplot(2,1,2);plot(tone_g);
Fsamp = 44100;                              % Set sampling frequency.
%Fsamp = 8000;
bps = 32;                                   % Set bits per second.
siz = 65536
wavwrite(tone_g, 'tone_g.wav');    % Write audio to file.
wavwrite(tone_c,'tone_c.wav');

tone_mix = (tone_c + tone_g);               % Add tones.
wavwrite(tone_mix,Fsamp,bps,'tone_mix');    % Write mixed audio to file.
%sound(tone_mix,44100,bps);                  % Play mixed audio

fft_tone_c = fft(tone_c,65536);             % Get fft of each tone and mixed
tone.
fft_tone_g = fft(tone_g,65536);
fft_tone_mix = fft(tone_mix,65536);
  
n = [0:65535];                              % Setup array for graphing against.
fp = n*(Fsamp/65535);
subplot(3,1,1); plot(fp,fft_tone_mix);      % Plot each tone and mixed tone.
subplot(3,1,2); plot(fp,fft_tone_g);
subplot(3,1,3); plot(fp,fft_tone_c);

split_wav.m

file1 = 'tone_mix.wav';
file2 = 'split.wav';

siz = wavread(file1,'size');        % Get total length of mixed audio.
siz(:,2) = [];                      % Make siz vector an "int".

[x,Fs,bits] = wavread(file1, siz);  % Read in mixed audio.

y = fft(x,siz);                   % Get fft of mixed audio.

z = ifft(y);
wavwrite(z,Fs,bits,file2);    % Write mixed audio to file.
[a,Fs,bits] = wavread(file2); % Read mixed audio file.

n = [0:siz-1];                      % Setup array for graphing against.
f = n*(Fs/siz-1);
plot(f,y);                          % Plot mixed fft.
title('Mixed FFT');

