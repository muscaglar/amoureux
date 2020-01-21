function [ R , Rectification] = amoureux_ResistanceAnalyse( IV,varargin )

verbose = 1;

if nargin >= 2
    verbose = varargin{1};
end

if(verbose == 1)
hold off;
plot(IV(:,2),IV(:,1),'ok');
hold on;
end
%  Remove really bad points
IV_Edit = amoureux_IVClean(IV);
if(verbose == 1)
plot(IV_Edit(:,2),IV_Edit(:,1),'.b');
%Remove bad Points
end
%-------------------------------------------------------------------------
%Fit V = IR
[ Parameters, StdErrors, Y_Fit, r2] = LineFit( IV_Edit(:,1) , IV_Edit(:,2));

R = Parameters(1);
if(verbose == 1)
plot(Y_Fit,IV_Edit(:,1),'-k');
end
%-------------------------------------------------------------------------
%Look for rectification
%Split About zero in IV_Edit
%   Find 0 crossing index
k = max(size(IV_Edit));
if k >3
Zero = 1;
for i = 2:k
    if(( IV_Edit(i-1,1) < 0 && IV_Edit(i,1) > 0))
        %this is the zero crossing  - though could be more robust
        Zero = i;
    end
    if(( IV_Edit(i-1,1) > 0 && IV_Edit(i,1) < 0))
        %This is the zero corssing if in the other direction.
        Zero = i;
    end
end
if(Zero > 1)
    if(IV_Edit(1,2) < IV_Edit(end,2)) 
        IV_Low = IV_Edit(1:Zero,:);
        IV_High = IV_Edit(Zero:end,:);
    else
        IV_Low = IV_Edit(Zero:end,:);
        IV_High = IV_Edit(1:Zero,:);    
    end
    if(verbose==1)
    plot(IV_Low(:,2),IV_Low(:,1),'+r');
    plot(IV_High(:,2),IV_High(:,1),'+b');
    end
    [ Parameters, StdErrors, Y_Fit, r2] = LineFit( IV_Low(:,1) , IV_Low(:,2));
    if(verbose==1)
    plot(Y_Fit, IV_Low(:,1),'-r');
    end
    Rectification(1,1) = Parameters(1);
    [ Parameters, StdErrors, Y_Fit, r2] = LineFit( IV_High(:,1) , IV_High(:,2));
    if(verbose==1)
    plot(Y_Fit, IV_High(:,1),'-b');
    end
    Rectification(1,2) = Parameters(1);
    Rectification(1,3) = Rectification(1,2)/Rectification(1,1);
else
    %Data doesn't cross zero - so just use all
    IV_Low = IV_Edit;
    Rectification = [0 0 0];
    warning('Data doesn''t go through 0 current')
end
else
    Rectification = [0 0 0];
end


%-------------------------------------------------------------------------
%Look at nonlinearity


xlabel('Voltage (mV)')
ylabel('Current (nA)')


end

