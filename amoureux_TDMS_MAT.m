function [] = amoureux_TDMS_MAT()

fileroot = uigetdir('Amourux File Selector');
fileroot = dir(fileroot);
dirFlags = [fileroot.isdir];
subFolders = fileroot(dirFlags);
subFolders(1:2)=[];

for x = 1:length(subFolders)
    SavefileName = 'filename_not_found_00_00_01_00';
    if(ispc)
        fileroot = strcat(subFolders(x).folder, '\' ,subFolders(x).name);
    else
        fileroot = strcat(subFolders(x).folder, '/' ,subFolders(x).name);
    end
    [files,~] = amoureux_file_process(fileroot);
    
    if(isempty(files))
    else
        
        %         No  = inputdlg('Enter the sampling rate in kHz');
        %         s_freq = str2double(No{1,1});
        %
        %         button = questdlg(['Is ' No{1,1} ' kHz definitely the sampling rate?']);
        %         if strcmp(button, 'Yes') == 1
        %             s_freq = str2double(No{1,1});
        %         else
        %             No  = inputdlg('Enter the sampling rate in kHz');
        %             s_freq = str2double(No{1,1});
        %         end
        s_freq=150;
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
                    SavefileName = files(i).name;
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
        %current = current(current>0);
        if(~isempty(current))
            %[~,current] = neroli_clean_currentTrace(current);
             %time = 0:1/s_freq:(length(current)-1)/s_freq;
            %%%%% ONLY SAVING CURRENT CURRENTLY %%%%%%
        end
        amoureux_saveMat(SavefileName,files(i).folder);
        
    end
end
    function [] = amoureux_saveMat(fName,fPath)
        [num1,num2]=amoureux_getNumber(fName);
        name = ['run',num2str(num1),'_',num2str(num2)];
        if(ispc)
            savepath = strcat(fPath,'\',name);
            savepath2 = strcat(fPath,'\',name,'PSD');
        else
            savepath = strcat(fPath,'/',name);
            savepath2 = strcat(fPath,'/',name,'PSD');
        end
        save_mat = char(strcat(savepath,'.mat'));
        save(save_mat,'current','voltage');
        %save_mat = char(strcat(savepath2,'.mat'));
    end

    function [number1,number2] = amoureux_getNumber(fName)
        out = str2double(regexp(fName,'[\d.]+','match'));
        number1 = out(1);
        number2 = out(2);
    end
end