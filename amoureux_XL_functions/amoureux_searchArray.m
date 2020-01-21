
    function [index,indexend] = amoureux_searchArray(array, value)
        n = length(array);
        i1 = 1;
        while (i1<=n) && array(i1)~= value
            i1 = i1 + 1;
        end
        j1=length(array);
        while (j1>=1) && array(j1)~= value
            j1 = j1 - 1;
        end
        if array~=value
            error('VALUE was not found.');
        end
        index=i1;
        indexend=j1;
    end
