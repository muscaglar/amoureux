
function [ filenames ] = amoureux_readXL_generateFilename_test(date,XLpath,Axo,Gam,IDs)
        if(Gam==1)
            f1 = 'Data_Gamry';
        elseif(Axo==1)
            f1 = 'Data_Axopatch';
        else
            disp('Incorrect Amplifier Selection');
            f1 = '';
        end
        f2 = date;
        for i = 1:length(IDs)
            f3 = [date,'_',num2str(IDs(i))];
            if(ispc)
                filenames{i} = strcat(XLpath,f1,'\',f2,'\',f3);
            else
                filenames{i} = strcat(XLpath,f1,'/',f2,'/',f3);
            end
        end
    end
