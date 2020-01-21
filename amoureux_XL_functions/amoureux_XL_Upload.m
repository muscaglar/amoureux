function [ FileName, PathName , CapIDs] = amoureux_XL_Upload(pages, User)

if(ispc)
    fileName = 'E:\neroli_amoureux.xlsm';
else
    fileName = '';
end

index = size(pages,2);

for i = 1:index
    
    sheet{1,1} = pages{i};
    
    % Load Excel File
    [num,txt, raw] = xlsread(fileName,sheet{1,1});
    
    % Check the data / load into variables
    [Date, CapNo, CapType, CapSol, CapConc, CapPH, Membrane, BareIVCurves,SealedIVCurves,AwayIVCurves, Expts, ExptType, Traces  ]
    
    %Match Membrane to Membrane No
    [ MembraneID ] = getMembraneID( Membrane );
    
    ExperimentType = ExptType; % String details/comment about the experiment

        if GetCapID( Date, CapNo ) == 0
            %Enter Data into DB
            %Create Capillary and get No  - NB might use existing function for this!
            % Use AddCapillaries to create experiments
            % This will add the bare and sealed values as well using AddExperiments
            [ CapID ] = AddCapillaries( Date, CapType, CapNo ,ExperimentType, BareIVCurves,SealedIVCurves,AwayIVCurves, MembraneID , User, Expts, CapSol, CapConc, CapPH, Traces );
            
            %Ouput the capillary No and expeirment No range.
            disp(['Data Entered as Capillary ' num2str(CapID)]);
            
            if (CapID > 0)
                ElectrodeSolution = raw{15,7};
                ElectrodeConc = raw{15,9};
                if ~isnan(ElectrodeConc)
                    [ rValue, rStringValue, rid ] = UpdateNameValueCapillary( CapID, 'ElectrodeSolution', ElectrodeConc, ElectrodeSolution );
                else
                    warning('Didn''t add electrode as no conc value')
                end
            end
            %should write the capillay no back to the excel file - though
            
        else
            disp('THIS CAPILLARY ALREADY EXISTS');
            CapID = GetCapID( Date, CapNo )
        end
%     else
%         disp('You have chosen not to enter data');
%     end
    
    
end

end