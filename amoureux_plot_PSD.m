function [bin_x,bin_y,PSD_x,PSD_y] = amoureux_plot_PSD(Fs,current)
close all;

N = length(current);
xdft = fft(current);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(current):Fs/2;

PSD_y = 10*log10(psdx);
PSD_x = freq;
% semilogx(PSD_x,PSD_y)
% grid on
% title('PSD')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')

bin_x = [];
bin_y = [];
binEdges = logspace(-3,5,1600);
for i = 1:2:length(binEdges)
    [ ~, ix ] = min( abs( PSD_x-binEdges(i) ) );
    [ ~, ix2 ] = min( abs( PSD_x-binEdges(i+1) ) );
    bin_x =[bin_x, (PSD_x(ix)+PSD_x(ix2))/2];
    bin_y = [bin_y, mean(PSD_y(ix:ix2))];
end

%periodogram(current,rectwin(length(current)),length(current),Fs)

end