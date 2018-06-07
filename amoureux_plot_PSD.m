function [PSD_x,PSD_y] = amoureux_plot_PSD(current,Fs)

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

%periodogram(current,rectwin(length(current)),length(current),Fs)

end