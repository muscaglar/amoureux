function [ filenames, savenames ] = amoureux_readXL_generateIVFilename(date,XLpath,Gam,Axo,IDs,comment)
f2 = date;

IDs = reshape(IDs,[size(IDs,1)*size(IDs,2),1]);
IDs(IDs==0)=[];
IDs = sort(IDs);

for i = 1:length(IDs)
    if(Gam==1)
        f1 = 'Data_Gamry';
        f3 = [date,'_',num2str(IDs(i)),'.txt'];
    elseif(Axo==1)
        f1 = 'Data_Axopatch';
        f3 = [date,'_',num2str(IDs(i)),'_C1__IV_StepAverage.txt'];
    else
        disp('Incorrect Amplifier Selection');
        f1 = '';
        f3 = '';
    end
    if(ispc)
        filenames{i} = strcat(XLpath,f1,'\',f2,'\',f3);
        savenames{i} = strcat(XLpath,'Analysis','\',f2,'\','IV','\',f1,'_',comment,num2str(IDs(i)),'.txt');
    else
        filenames{i} = strcat(XLpath,f1,'/',f2,'/',f3);
        savenames{i} = strcat(XLpath,'Analysis','/',f2,'/','IV','/',f1,'_',comment,num2str(IDs(i)),'.txt');
    end
end
end
