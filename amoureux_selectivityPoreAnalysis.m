function [resistances,pore_sizes,selectivites] = amoureux_selectivityPoreAnalysis(varargin)
%[resistances,pore_sizes,selectivites] = amoureux_selectivityPoreAnalysis([873,1010],[875,973],[875,974],[878,950],[878,972],[886,954],[888,955],[891,956],[896,958],[900,959],[901,961],[903,962],[908,963],[923,967])
%[resistances,pore_sizes,selectivites] = amoureux_selectivityPoreAnalysis([873,1010],[875,973],[875,974],[878,950],[878,972],[881,952],[886,954],[888,955],[891,956],[893,957],[896,958],[900,959],[901,961],[903,962],[908,963],[916,966],[923,967],[925,968]);
%Non 1M KCl, non graphene samples: [867,964],[913,965],[928,969],[870,970]
% Resistnace lower than bare after BD [883,953]
% Multilayer: [925,968],[881,952]
DB = DBConnection;
E_Bare = Experiments(DB);
E_Sealed = Experiments(DB);
E_Away = Experiments(DB);

resistances = [];
pore_sizes = [];
selectivites = [];
permeabilities = [];
for i = 1:nargin
    
    E_Bare.setid(0);
    E_Sealed.setid(0);
    E_Away.setid(0);
    
    caps = varargin{i};
    
    [ ~,~,~,~,~, ~,pre_vGrad, pre_iGrad] = ca_selectivity(caps(1));
    [ ~,~,~,~,~, ~,post_vGrad, post_iGrad] = ca_selectivity(caps(2));
    
    str = ['Capillary = ''' num2str(caps(1)) ''' AND Suppressed = 0 AND Sealed = ''0'' ORDER BY No ASC'];
    
    E_Bare.SELECT(str);
    bare_res = E_Bare.getResistance();
    bare_res_low = E_Bare.getLowRes();
    bare_res_high = E_Bare.getHighRes();
    
    SealedSuppression = [0 20];
    if ( caps(2) == 973 )
    str = ['Capillary = '''  num2str(974) ''' AND ' ConcatVectorToSQL( SealedSuppression, 'Suppressed') ' AND Sealed > 0 ORDER BY No ASC'];     
    elseif(caps(2) == 1033)
    str = ['Capillary = '''  num2str(873) ''' AND ' ConcatVectorToSQL( SealedSuppression, 'Suppressed') ' AND Sealed > 0 ORDER BY No ASC'];             
    else
    str = ['Capillary = '''  num2str(caps(2)) ''' AND ' ConcatVectorToSQL( SealedSuppression, 'Suppressed') ' AND Sealed > 0 ORDER BY No ASC']; 
    end
    E_Sealed.setid(0);
    E_Sealed.SELECT(str);
    E_Sealed.CloseConnection;
    
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
    
    if (caps(2)==968 || caps(2)==952)
        membrane_thickness = 1.2e-9;
    else
        membrane_thickness = 0.6e-9;
    end
    
    [Diameter_nm ,~] = amoureux_pore_diameter( post_BD_res, sealed_res , bare_res , 10, membrane_thickness );
    [Diameter_nm1,~] = amoureux_pore_diameter( post_BD_res_low_diam , sealed_res_low_diam , bare_res_low_diam , 10, membrane_thickness);
    [Diameter_nm2,~] = amoureux_pore_diameter( post_BD_res_low_diam , sealed_res_high_diam , bare_res_low_diam , 10, membrane_thickness);
    [Diameter_nm3,~] = amoureux_pore_diameter( post_BD_res_low_diam , sealed_res_high_diam , bare_res_high_diam , 10, membrane_thickness );
    [Diameter_nm4,~] = amoureux_pore_diameter( post_BD_res_high_diam , sealed_res_low_diam , bare_res_low_diam , 10, membrane_thickness );
    [Diameter_nm5,~] = amoureux_pore_diameter( post_BD_res_high_diam , sealed_res_low_diam , bare_res_high_diam , 10, membrane_thickness );
    [Diameter_nm6,~] = amoureux_pore_diameter( post_BD_res_high_diam , sealed_res_high_diam , bare_res_low_diam , 10, membrane_thickness );
    [Diameter_nm7,~] = amoureux_pore_diameter( post_BD_res_high_diam , sealed_res_high_diam , bare_res_high_diam , 10, membrane_thickness );
    
    Diameter_nm_low = min([Diameter_nm1,Diameter_nm2,Diameter_nm3,Diameter_nm4,Diameter_nm5,Diameter_nm6,Diameter_nm7]);
    Diameter_nm_high = max([Diameter_nm1,Diameter_nm2,Diameter_nm3,Diameter_nm4,Diameter_nm5,Diameter_nm6,Diameter_nm7]);
    
    pore_mean = mean([Diameter_nm,Diameter_nm1,Diameter_nm2,Diameter_nm3,Diameter_nm4,Diameter_nm5,Diameter_nm6,Diameter_nm7]);
    pore_std = std([Diameter_nm,Diameter_nm1,Diameter_nm2,Diameter_nm3,Diameter_nm4,Diameter_nm5,Diameter_nm6,Diameter_nm7]);
    
    resistances = [resistances; caps(1),caps(2), bare_res * 1000000, bare_res_low * 1000000, bare_res_high * 1000000, sealed_res * 1000000, sealed_res_low * 1000000, sealed_res_high * 1000000, post_BD_res * 1000000, post_BD_res_low * 1000000, post_BD_res_high * 1000000];
    pore_sizes = [pore_sizes; caps(1),caps(2),Diameter_nm];
    selectivites = [selectivites; caps(1),caps(2),Diameter_nm, pre_vGrad(1),pre_vGrad(2), pre_iGrad(1),pre_iGrad(2), post_vGrad(1),post_vGrad(2), post_iGrad(1),post_iGrad(2)];
    
    close all;
end

end