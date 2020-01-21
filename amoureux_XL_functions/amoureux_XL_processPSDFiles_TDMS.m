function [] = amoureux_XL_processPSDFiles_TDMS(folderDir,sFreq,sPath,tag)
files = dir(fullfile(folderDir, '*.tdms'));
%Could use amoureux_file_process(folderDir) to make a clever filter for already processed files
if(isempty(files))
else
    sFreq = sFreq *1000;
    voltage = [];
    current = [];
    disp(['Filepath: ', folderDir]);
    for i = 1:numel(files)
        if(ispc)
            filepath = char(strcat(folderDir,'\',files(i).name));
        else
            filepath = char(strcat(folderDir,'/',files(i).name));
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
    
    %% Process Current
    current = current(current>0);
    No = length(current);
    segments = floor(No/1000);
    allmeans = 0;
    [N,edges,bin] = histcounts(current);
    aim_mean = edges(find(N==max(N)));
    for i = 1:segments:No-segments
        if( (mean(current(i:i+segments)) < 0.9 *aim_mean) || (mean(current(i:i+segments)) > 1.1 *aim_mean) )
            current(i:i+segments) = 0;
        end
    end
    current(current==0) = [];
    %% Continue
    time = 0:1/sFreq:(length(current)-1)/sFreq;
    [rX,rY,psdest] = amoureux_FFT(current', sFreq);
    [bin_x,bin_y,rX2,rY2] = amoureux_plot_PSD(sFreq,current);
    temp = strsplit(folderDir,'\');
    f_Name = temp{length(temp)};
    amoureux_XL_saveMat(f_Name,sPath,tag);
end
    function [] = amoureux_XL_saveMat(f_Name,s_Path,s_tag)
        if(ispc)
            savepath = strcat(s_Path,'\',f_Name,'_PSD_',s_tag);
            savepath2 = strcat(s_Path,'\',f_Name,'_IVT_',s_tag);
        else
            savepath = strcat(s_Path,'/',f_Name,'_PSD_',s_tag);
            savepath2 = strcat(s_Path,'/',f_Name,'_IVT_',s_tag);
        end
        save_mat = char(strcat(savepath,'.mat'));
        save_mat2 = char(strcat(savepath2,'.mat'));
        save(save_mat2,'current','voltage','time');
        save(save_mat,'bin_x','bin_y');%'rX','rY','rX2','rY2',
    end
end