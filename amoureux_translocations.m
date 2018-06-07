function [] = amoureux_translocations()

freq = 250000;

% [baseName, folder] = uigetfile({'*.dat';'*.mat';},'CoolWater File Selector');
% filepath = fullfile(folder, baseName);
fileroot = '/Volumes/MUS/ExperimentData/Data/170517/170517_63';%uigetdir('Amourux File Selector');
[files,keep_mat_files] = amoureux_file_process(fileroot);

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
        
        %         if(amoureux_getNumber(files(i).name) == amoureux_getNumber(files(i-1).name))
        %             result = convertTDMS(0,filepath);
        %             voltage = [voltage, result.Data.MeasuredData(3).Data'];
        %             current = [current, result.Data.MeasuredData(4).Data'];
        %         else
        %             amoureux_saveMat(files(i-1).name,files(i-1).folder,voltage,current);
        result = convertTDMS(0,filepath);
        voltage = [voltage, result.Data.MeasuredData(3).Data'];
        current = [current, result.Data.MeasuredData(4).Data'];
        
    end
    
    
end

time = 0:1/freq:(length(current)-1)/freq;
if(ispc)
    save_mat = char(strcat(fileroot,'\','saved_trans.mat'));
else
    save_mat = char(strcat(fileroot,'/','saved_trans.mat'));
end

save(save_mat,'time','current','voltage');

    function [number] = amoureux_getNumber(fName)
        out = str2double(regexp(fName,'[\d.]+','match'));
        number = out(1);
    end

    function [voltage, current] = amoureux_removeKickOut(voltage,current)
        bound = mean(voltage);
        index1 = voltage>(bound*1.1);
        index2 = voltage<(bound*0.9);
        index = or(index1,index2);
        index = not(index);
        voltage = voltage(index);
        current = current(index);
        
        bound2 = mean(current);
        index1 = current>(bound2*2);
        index2 = current<(bound2*0.25);
        index = or(index1,index2);
        index = not(index);
        voltage = voltage(index);
        current = current(index);
    end
end