function [R, IV] = amoureux_get_R_IV(filename,Amp)

[A] = amoureux_txt2mat(filename);
if(strcmp(Amp,'Gamry'))
    IV = [A(:,2) A(:,1)]; %for Gamry
    [R, ~] = amoureux_ResistanceAnalyse(IV,0);
    R = R / 1000000;
elseif(strcmp(Amp,'Axopatch'))
    IV = [A(:,1) A(:,2)]; %for Axo
    [R, ~] = amoureux_ResistanceAnalyse(IV,0);
end

close all;

end