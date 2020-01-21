function [poreD_nm,...
          pore_resistance] = amoureux_pore_diameter( postBD_resistance, ...
                                                  preBD_resistance,  ...
                                                  bare_resistance,   ...
                                                  sol_conductivity_Sm,  ...
                                                  membrane_thickness )
 
%Attempt a simple approach first - assume at DC the capillary and membrane
%resistance is in series with one another

preBD_membrane_MO = preBD_resistance - bare_resistance;
postBD_membrane_MO = postBD_resistance - bare_resistance;

%Assuming another simple approach

pore_resistance = preBD_membrane_MO - postBD_membrane_MO;
pore_resistance = pore_resistance * 1E6;
%Assume the pore is filled with solution

%poreD_nm=(1./2)*((pi.^(2./3)*pore_resistance*sol_conductivity_Sm)./(3.^(1./3)*(sqrt(3)*sqrt(27*membrane_thickness.^4-pi*pore_resistance.^3*sol_conductivity_Sm.^3*membrane_thickness.^3)-9*membrane_thickness.^2).^(1./3))+(pi.^(1./3)*(sqrt(3)*sqrt(27*membrane_thickness.^4-pi*pore_resistance.^3*sol_conductivity_Sm.^3*membrane_thickness.^3)-9*membrane_thickness.^2).^(1./3))./(3.^(2./3)*membrane_thickness));
poreD_nm = ((sqrt((16*pore_resistance* sol_conductivity_Sm*membrane_thickness)/pi + 1) + 1)/(2 *pore_resistance* sol_conductivity_Sm))*1E9;
poreD_nm = poreD_nm * 1E9;
end
