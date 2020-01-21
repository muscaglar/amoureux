function [] = amoureux_XL_processPSDFiles(PSD_bare,PSD_sealed,PSD_BD,isAxopatch,isGamry,date,XLpath,file_numbers,sampling_freq)

if (ispc)
    sPath = strcat(XLpath,'Analysis','\',date,'\','PSD','\');
    mkdir(sPath);
else
    sPath = strcat(XLpath,'Analysis','/',date,'/','PSD','/');
    mkdir(sPath);
end

writeout(:,1) = {'Amplifer','File ID','Resistance'};

PSD_bare_IDs = file_numbers(PSD_bare&isAxopatch,:);
PSD_bare_IDs(PSD_bare_IDs==0)=[];
PSD_bare_freq = sampling_freq(PSD_bare==1);

PSD_sealed_IDs = file_numbers(PSD_sealed&isAxopatch,:);
PSD_sealed_IDs(PSD_sealed_IDs==0)=[];
PSD_sealed_freq = sampling_freq(PSD_sealed==1);

PSD_BD_IDs = file_numbers(PSD_BD&isAxopatch,:);
PSD_BD_IDs(PSD_BD_IDs==0)=[];
PSD_BD_freq = sampling_freq(PSD_BD==1);

if(~isempty(PSD_bare_IDs))
    [ folderDirs ] = amoureux_readXL_generateTraceFilename(date,XLpath,isGamry(PSD_bare&isAxopatch),isAxopatch(PSD_bare&isAxopatch),PSD_bare_IDs);
    %index_wo = size(writeout,2);
    for j=1:length(PSD_bare_IDs)
        if(PSD_bare_IDs(j)==0)
        else
            amoureux_XL_processPSDFiles_TDMS(folderDirs{j},PSD_bare_freq(j),sPath,'bare');
        end
    end
    %[writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,bare_A_IDs,'Axopatch');
end

if(~isempty(PSD_sealed_IDs))
    [ folderDirs ] = amoureux_readXL_generateTraceFilename(date,XLpath,isGamry(PSD_sealed&isAxopatch),isAxopatch(PSD_sealed&isAxopatch),PSD_sealed_IDs);
    for j=1:length(PSD_sealed_IDs)
        if(PSD_sealed_IDs(j)==0)
        else
            amoureux_XL_processPSDFiles_TDMS(folderDirs{j},PSD_sealed_freq(j),sPath,'sealed');
        end
    end
end

if(~isempty(PSD_BD_IDs))
    [ folderDirs ] = amoureux_readXL_generateTraceFilename(date,XLpath,isGamry(PSD_BD&isAxopatch),isAxopatch(PSD_BD&isAxopatch),PSD_BD_IDs);
    for j=1:length(PSD_BD_IDs)
        if(PSD_BD_IDs(j)==0)
        else
            amoureux_XL_processPSDFiles_TDMS(folderDirs{j},PSD_BD_freq(j),sPath,'bd');
        end
    end
end

%wo_save = strcat(XLpath,'Analysis','\',date,'\','IV','\Summary.xls');
%xlswrite(wo_save,writeout');

end