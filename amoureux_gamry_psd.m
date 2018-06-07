function [voltage,current,time,rX,rY] = amoureux_gamry_psd()

fileroot = uigetdir('amoureux PSD Selector');
files = dir(fullfile(fileroot, '*.DTA'));

No  = inputdlg('Enter the sampling rate in kHz');
s_freq = str2double(No{1,1});

button = questdlg(['Is ' No{1,1} ' kHz definitely the sampling rate?']);
if strcmp(button, 'Yes') == 1
    s_freq = str2double(No{1,1});
else
    No  = inputdlg('Enter the sampling rate in kHz');
    s_freq = str2double(No{1,1});
end

current = [];
voltage = [];

for j = 1:length(files)
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name));
    else
        filepath = char(strcat(fileroot,'/',files(j).name));
    end
    [A,~,~,~,~,~] = amoureux_txt2mat(filepath,'NumHeaderLines',68);
    voltage = A(:,3);
    current = A(:,4);
    
    [rX,rY] = amoureux_FFT(current, s_freq);
    plot(rX,log10(rY));
end
time = 0:1/s_freq:(length(current)-1)/s_freq;
end