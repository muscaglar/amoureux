function [] = amoureux_testbed(date,bare,sealed,bd,Fs)
close all;
figure;

current = [];
time = [];
voltage =[];


str = ['C:\Users\mc934\Desktop\DataBackup_270618\Data_Axopatch\' num2str(date) '\' num2str(date) '_' num2str(bare) '\run' num2str(date) '.mat'];

load(str);

N = length(current);
xdft = fft(current);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(current):Fs/2;

%plot(freq,10*log10(psdx))
PSD_y = 10*log10(psdx);
PSD_x = freq;

semilogx(PSD_x,PSD_y)
hold on;
current = [];
time = [];
voltage =[];

str = ['C:\Users\mc934\Desktop\DataBackup_270618\Data_Axopatch\' num2str(date) '\' num2str(date) '_' num2str(sealed) '\run' num2str(date) '.mat'];

load(str);

N = length(current);
xdft = fft(current);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(current):Fs/2;

%plot(freq,10*log10(psdx))
PSD_y = 10*log10(psdx);
PSD_x = freq;

semilogx(PSD_x,PSD_y)


current = [];
time = [];
voltage =[];

str = ['C:\Users\mc934\Desktop\DataBackup_270618\Data_Axopatch\' num2str(date) '\' num2str(date) '_' num2str(bd) '\run' num2str(date) '.mat'];

load(str);

N = length(current);
xdft = fft(current);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(current):Fs/2;

%plot(freq,10*log10(psdx))
PSD_y = 10*log10(psdx);
PSD_x = freq;
semilogx(PSD_x,PSD_y)

grid on
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB/Hz)')
legend('bare','sealed','breakdown')
end