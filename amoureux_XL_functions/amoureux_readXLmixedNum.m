
    function [ data ] = amoureux_readXLmixedNum( array, istart, iend, iheader,col)
        data=[];
        for i3 = istart+iheader:iend+iheader
            current_data = cell2mat(array(i3,col));
            if(isnan(current_data))
                current_data = 0;
            else
                current_data = str2num(string(current_data));
            end
            if(i3==istart+iheader)
                data = current_data;
            else
                data = catpad(1,data,current_data,'padval',0);
            end
        end
    end
