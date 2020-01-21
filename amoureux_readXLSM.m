function [] = amoureux_readXLSM()

if nargin < 2
    [FileName, XLpath] = uigetfile({'*.xlsx;*.xlsm','Excel Files';},'Choose Excel File');
end

[status,sheets] = xlsfinfo([XLpath '/' FileName]);

% if nargin < 3
%     % Select the correct page
%     sheet = inputdlg('Enter the page you want to load from');
% else
%     sheet{1,1} = page;
% end

for l = 1:length(sheets)
    sheet = sheets{l};
    
    disp(sheet)
    [~,~,raw] = xlsread([XLpath '/' FileName],sheet);
    
    
   try 
    day = raw{1,3};
    month = raw{2,3};
    year = raw{3,3};
    if (year > 100)
        year = year -2000;
    end
    
    date = day*10000 + month * 100 + year;
    date = num2str(date);
    if(length(date)==6)
    else
        date = strcat('0',date);
    end
    
    investigator = raw{5,4};
    investigator = str2num(investigator(1));
    
    header= 12;
    
    cap_No = raw(:,21);
    cap_No(1:12)=[];
    cap_no_id=cellfun(@(cap_No) isnan(cap_No), cap_No);
    cap_sum = sum(~cap_no_id);
    cap_No(cap_sum+1:length(cap_No)) = [];
    cap_No = cell2mat(cap_No);
    unique_caps = unique(cap_No);
    
    disp(['There are ' num2str(length(unique_caps)) ' unique capillaries in this dataset']);
    
    
    for k=1:length(unique_caps)
        cap = unique_caps(k);
        disp(['I am stating with capillary number: ' num2str(cap)]);
        
        [istart,iend]= amoureux_searchArray(cap_No, cap);
        
        location = raw(istart+header:iend+header,15);
        file_numbers = amoureux_readXLmixedNum( raw, istart, iend, header,19);
        membrane = raw(istart+header:iend+header,23);
        amplifier = raw(istart+header:iend+header,25); %strcmp(amplifier{1},'Gamry ')
        isGamry = strcmp(amplifier,'Gamry');
        isAxopatch = strcmp(amplifier,'Axopatch');
        sampling_freq = amoureux_readXLmixedNum( raw, istart, iend, header,26);
        cap_salt = raw(istart+header:iend+header,28);
        cap_salt_conc = amoureux_readXLmixedNum( raw, istart, iend, header,29);
        res_salt = raw(istart+header:iend+header,31);
        res_salt_conc = amoureux_readXLmixedNum( raw, istart, iend, header,32);
        cap_type = raw(istart+header:iend+header,33);
        comment = raw(istart+header:iend+header,55);
        
        disp(['Misc. data has been captured']);
        disp(['Processing IV curves']);
        
        IV_bare = cell2mat(raw(istart+header:iend+header,2));
        IV_bare(isnan(IV_bare))=0;
        IV_sealed = cell2mat(raw(istart+header:iend+header,3));
        IV_sealed(isnan(IV_sealed))=0;
        IV_away = cell2mat(raw(istart+header:iend+header,4));
        IV_away(isnan(IV_away))=0;
        IV_BD = cell2mat(raw(istart+header:iend+header,5));
        IV_BD(isnan(IV_BD))=0;
        
        isAxopatch(isnan(isAxopatch))=0;
        isGamry(isnan(isGamry))=0;
        
        amoureux_XL_processIVFiles(IV_bare,IV_sealed,IV_away,IV_BD,isAxopatch,isGamry,date,XLpath,file_numbers);
        
        disp(['IV curves completed successfully.']);
        disp(['Processing PSDs']);
        PSD_bare = cell2mat(raw(istart+header:iend+header,7));
        PSD_sealed = cell2mat(raw(istart+header:iend+header,8));
        PSD_BD = cell2mat(raw(istart+header:iend+header,9));
        
        amoureux_XL_processPSDFiles(PSD_bare,PSD_sealed,PSD_BD,isAxopatch,isGamry,date,XLpath,file_numbers,sampling_freq);
        
        disp('PSDs complete');
        
        
        disp(['Processing trace files. This will take some time.']);
        Trace_BD = cell2mat(raw(istart+header:iend+header,11));
        Trace_Translocation = cell2mat(raw(istart+header:iend+header,13));
        Trace_BD(isnan(Trace_BD))=0;
        Trace_Translocation(isnan(Trace_Translocation))=0;
        disp(['Trace files complete.']);
        disp(['Analysis of capillariy ' num2str(k) ' is complete.']);
        
        %[] = amoureux_auto_TDMS_MAT(fileroot,s_freq)
        %[] = amoureux_auto_TDMS_PSD(fileroot,s_freq)
        
        %     for j=istart:iend
        %
        %     end
    end
    
   catch
       disp(['Failed to process sheet:' sheet]);
   end
end


end