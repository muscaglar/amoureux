function [resMatrix] = amoureux_elecoPoration_resAnalyse(varargin)

%[resistances,pore_sizes,selectivites,permeabilities] = amoureux_selectivityPoreAnalysis([873,960],[875,973],[875,974],[878,950],[878,972],[881,952],[886,954],[888,955],[891,956],[893,957],[896,958],[900,959],[901,961],[903,962],[908,963],[916,966],[923,967],[925,968]);
%Non 1M KCl, non graphene samples: [867,964],[913,965],[928,969],[870,970]
% Resistnace lower than bare after BD [883,953]
% Multilayer: [925,968],[881,952]
DB = DBConnection;
E_Bare = Experiments(DB);
E_Sealed = Experiments(DB);
E_Away = Experiments(DB);

resMatrix= [];

resistances = [];
pore_sizes = [];
selectivites = [];
permeabilities = [];
for i = 1:nargin
    
    E_Bare.setid(0);
    E_Sealed.setid(0);
    E_Away.setid(0);
    
    caps = varargin{i};
    
%     if(caps(2)==972)
%         str = ['Capillary = ''' num2str(caps(1)) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];
%     elseif(caps(2)==973 || caps(2)==974)
%         str = ['Capillary = ''' num2str(875) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];
%     elseif(caps(2) == 958)
%         str = ['Capillary = ''' num2str(895) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];
%     elseif(caps(1)==986)
%       str = ['Capillary = ''' num2str(caps(1)) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];  
%      elseif(caps(1)==991)
%       str = ['Capillary = ''' num2str(990) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];  
%          elseif(caps(1)==997)
%       str = ['Capillary = ''' num2str(996) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];  
%     else
        str = ['Capillary = ''' num2str(caps(2)) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];
 %   end
    
    E_Bare.SELECT(str);
    bare_res = E_Bare.getResistance();
    bare_res_low = E_Bare.getLowRes();
    bare_res_high = E_Bare.getHighRes();
    
%     if(caps(2)==972 || caps(2) == 952 || caps(2) == 973)
%         str = ['Capillary = ''' num2str(caps(1)) ''' AND (Suppressed = 20) AND Sealed > 0 ORDER BY No ASC'];
%     else
        str = ['Capillary = ''' num2str(caps(2)) ''' AND (Suppressed = 20) AND Sealed > 0 ORDER BY No ASC'];
%    end
    
    E_Sealed.SELECT(str);
    sealed_res = E_Sealed.getResistance();
    sealed_res_low = E_Sealed.getLowRes();
    sealed_res_high = E_Sealed.getHighRes();
    
    if(sealed_res_low > sealed_res_high)
        sealed_res_low = E_Sealed.getHighRes();
        sealed_res_high = E_Sealed.getLowRes();
    end
    
    str = ['Capillary = ''' num2str(caps(2)) ''' AND (Suppressed = 21) AND Sealed > 0 ORDER BY No ASC'];
    E_Away.SELECT(str);
    post_BD_res = E_Away.getResistance();
    post_BD_res_low = E_Away.getLowRes();
    post_BD_res_high = E_Away.getHighRes();
       
    if(post_BD_res_low > post_BD_res_high)
    post_BD_res_low = E_Away.getHighRes();
    post_BD_res_high = E_Away.getLowRes();
    end
    
    caps = varargin{i};
    
    if(post_BD_res_low == 0)
        post_BD_res_low_diam = post_BD_res;
    else
        post_BD_res_low_diam = post_BD_res_low;
    end
    if(post_BD_res_high == 0)
        post_BD_res_high_diam = post_BD_res;
    else
        post_BD_res_high_diam = post_BD_res_high;
    end
    if(sealed_res_low == 0)
        sealed_res_low_diam = sealed_res;
    else
        sealed_res_low_diam = sealed_res_low;
    end
    if(sealed_res_high == 0)
        sealed_res_high_diam = sealed_res;
    else
        sealed_res_high_diam = sealed_res_high;
    end
    
    if(bare_res_low == 0)
        bare_res_low_diam = bare_res;
    else
        bare_res_low_diam = bare_res_low;
    end
    if(bare_res_high == 0)
        bare_res_high_diam = bare_res;
    else
        bare_res_high_diam = bare_res_high;
    end
    
resMatrix = [resMatrix; caps(1), caps(2), bare_res, bare_res_low_diam, bare_res_high_diam,sealed_res,sealed_res_low_diam,sealed_res_high_diam, post_BD_res, post_BD_res_low_diam, post_BD_res_high_diam];
    
    
end

end