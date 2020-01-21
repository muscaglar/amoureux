function [] = amoureux_auto_TDMS_MAT(fileroot,s_freq)

fileroot = dir(fileroot);
dirFlags = [fileroot.isdir];
subFolders = fileroot(dirFlags);
subFolders(1:2)=[];

for x = 1:length(subFolders)
    if(ispc)
        fileroot = strcat(subFolders(x).folder, '\' ,subFolders(x).name);
    else
        fileroot = strcat(subFolders(x).folder, '/' ,subFolders(x).name);
    end
    [files,~] = amoureux_file_process(fileroot);
    
    if(isempty(files))
    else
        s_freq = s_freq *1000;
        
        voltage = [];
        current = [];
        
        disp(['Filepath: ', fileroot]);
        
        for i = 1:numel(files)
            if(ispc)
                filepath = char(strcat(fileroot,'\',files(i).name));
            else
                filepath = char(strcat(fileroot,'/',files(i).name));
            end
            
            if(i==1)
                try
                    result = convertTDMS(0,filepath);
                    voltage = result.Data.MeasuredData(3).Data';
                    current = result.Data.MeasuredData(4).Data';
                catch error
                    fprintf('This file was skipped: %s\n',files(i).name,'Due to error: %s', error.message);
                    continue;
                end
            else
                try
                    result = convertTDMS(0,filepath);
                    voltage = [voltage, result.Data.MeasuredData(3).Data'];
                    current = [current, result.Data.MeasuredData(4).Data'];
                catch error
                    fprintf('This file was skipped: %s\n',files(i).name,'Due to error: %s', error.message);
                    continue;
                end
            end
        end
        
        time = 0:1/s_freq:(length(current)-1)/s_freq;
        
        amoureux_saveMat(files(i).name,files(i).folder);
    end
end
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
        %save_mat = char(strcat(savepath2,'.mat'));
    end

    function [number] = amoureux_getNumber(fName)
        out = str2double(regexp(fName,'[\d.]+','match'));
        number = out(1);
    end
end