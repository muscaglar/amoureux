function [] = amoureux_XL_processIVFiles(IV_bare,IV_sealed,IV_away,IV_BD,isAxopatch,isGamry,date,XLpath,file_numbers)

if (ispc)
    mkdir(strcat(XLpath,'Analysis','\',date,'\','IV','\'));
else
    mkdir(strcat(XLpath,'Analysis','/',date,'/','IV','/'));
end

writeout(:,1) = {'Amplifer','File ID','Resistance'};

bare_A_IDs = file_numbers(IV_bare&isAxopatch,:);
bare_G_IDs = file_numbers(IV_bare&isGamry,:);

if(~isempty(bare_A_IDs))
    [ filenames, savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,0,1,bare_A_IDs,'bare');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,bare_A_IDs,'Axopatch');
end
if(~isempty(bare_G_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,1,0,bare_G_IDs,'bare');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,bare_G_IDs,'Gamry');
end
sealed_A_IDs = file_numbers(IV_sealed&isAxopatch,:);
sealed_G_IDs = file_numbers(IV_sealed&isGamry,:);

if(~isempty(sealed_A_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,0,1,sealed_A_IDs,'sealed');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,sealed_A_IDs,'Axopatch');
end
if(~isempty(sealed_G_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,1,0,sealed_G_IDs,'sealed');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,sealed_G_IDs,'Gamry');
end

away_A_IDs = file_numbers(IV_away&isAxopatch,:);
away_G_IDs = file_numbers(IV_away&isGamry,:);
if(~isempty(away_A_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,0,1,away_A_IDs,'away');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,away_A_IDs,'Axopatch');
end
if(~isempty(away_G_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,1,0,away_G_IDs,'away');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,away_G_IDs,'Gamry');
end

bd_A_IDs = file_numbers(IV_BD&isAxopatch,:);
bd_G_IDs = file_numbers(IV_BD&isGamry,:);

if(~isempty(bd_A_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,0,1,bd_A_IDs,'breakdown');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,bd_A_IDs,'Axopatch');
end
if(~isempty(bd_G_IDs))
    [ filenames,savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,1,0,bd_G_IDs,'breakdown');
    index_wo = size(writeout,2);
    [writeout] = amoureux_XL_saveIV(filenames,savenames,writeout,index_wo,bd_G_IDs,'Gamry');
end

wo_save = strcat(XLpath,'Analysis','\',date,'\','IV','\Summary.xls');
xlswrite(wo_save,writeout');

    function [wo] = amoureux_XL_saveIV(fNames,sNames,wo,i_wo,IDs,Amp)
        IDs = reshape(IDs,[size(IDs,1)*size(IDs,2),1]);
        IDs(IDs==0)=[];
        IDs = sort(IDs);
        for i = 1:length(fNames)
            try
                [Res, IV] = amoureux_get_R_IV(fNames{i},Amp);
                dlmwrite(sNames{i},IV,'delimiter','\t','precision',3);
                wo(:,i_wo+i) = {Amp,IDs(i),Res};
            catch
                disp('File Does Not Exist');
            end
        end
    end

end