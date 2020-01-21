
function [ folderDir ] = amoureux_readXL_generateTraceFilename(date,XLpath,Gam,Axo,IDs)
f2 = date;
for i = 1:length(IDs)
    if(Gam(i)==1)
        f1 = 'Data_Gamry';
    elseif(Axo(i)==1)
        f1 = 'Data_Axopatch';
    else
        disp('Incorrect Amplifier Selection');
        f1 = '';
    end
    f3 = [date,'_',num2str(IDs(i))];
    if(ispc)
        folderDir{i} = strcat(XLpath,f1,'\',f2,'\',f3);
    else
        folderDir{i} = strcat(XLpath,f1,'/',f2,'/',f3);
    end
end
end
