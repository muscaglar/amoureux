function [] = amoureux_TDMS_MAT()

%Use this to merge TDMS file fragments, generate a time, current, voltage
%matrix and save as a '.mat' file. This is much smaller and can be readily
%loaded into Origin and the like.

fileroot = uigetdir('Amourux File Selector');
[files,~] = amoureux_file_process(fileroot);

No  = inputdlg('Enter the sampling rate in kHz');
s_freq = str2double(No{1,1});

button = questdlg(['Is ' No{1,1} ' kHz definitely the sampling rate?']);
if strcmp(button, 'Yes') == 1
    s_freq = str2double(No{1,1});
else
    No  = inputdlg('Enter the sampling rate in kHz');
    s_freq = str2double(No{1,1});
end

s_freq = s_freq *1000;

voltage = [];
current = [];

for i = 1:numel(files)
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(i).name));
    else
        filepath = char(strcat(fileroot,'/',files(i).name));
    end
    
    if(i==1)
        result = convertTDMS(0,filepath);
        voltage = result.Data.MeasuredData(3).Data';
        current = result.Data.MeasuredData(4).Data';
    else
        result = convertTDMS(0,filepath);
        voltage = [voltage, result.Data.MeasuredData(3).Data'];
        current = [current, result.Data.MeasuredData(4).Data'];
    end
end

time = 0:1/s_freq:(length(current)-1)/s_freq;
[PSD_x,PSD_y] = amoureux_plot_PSD(current,s_freq);
amoureux_saveMat(files(i).name,files(i).folder);

    function [] = amoureux_saveMat(fName,fPath)
        name = ['run',num2str(amoureux_getNumber(fName))];
        if(ispc)
            savepath = strcat(fPath,'\',name);
            savepath2 = strcat(fPath,'\',name,'PSD');
        else
            savepath = strcat(fPath,'/',name);
            savepath2 = strcat(fPath,'/',name,'PSD');
        end
        save_mat = char(strcat(savepath,'.mat'));
        save(save_mat,'voltage','current','time');
        
        save_mat = char(strcat(savepath2,'.mat'));
        save(save_mat,'PSD_x','PSD_y');
    end

    function [number] = amoureux_getNumber(fName)
        out = str2double(regexp(fName,'[\d.]+','match'));
        number = out(1);
    end
end