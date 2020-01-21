function [ IV_Clean ] = amoureux_IVClean( IV, TH )

if nargin < 2
    TH = 2.5;
end
p1 = polyfit(IV(:,2),IV(:,1),3);
I_Fit = polyval(p1,IV(:,2));
Error = (IV(:,1) - I_Fit).^2;
PercentError = Error ./ sum(Error);
MeanPercentError = mean(PercentError);
ToKeep = PercentError < (TH * (MeanPercentError));
IV_Clean = IV(ToKeep,:);

%Strip out where value is at saturation limit
MaxLimit = 18.5;
MinLimit = -19.4;
if(or((max(IV_Clean(:,1)) > 22),(min(IV_Clean(:,1)) < -22)) )
    MaxLimit = 190;
    MinLimit = -190;
end
if (or((max(IV_Clean(:,1)) > 500),(min(IV_Clean(:,1)) < -500)) )
    MaxLimit = 50000;
    MinLimit = -50000;
end
IV_Clean = IV_Clean((IV_Clean(:,1)<MaxLimit)&(IV_Clean(:,1)>MinLimit),:);

end

