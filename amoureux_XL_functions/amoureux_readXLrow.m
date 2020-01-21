 function [ rowVector ] = amoureux_readXLrow( raw , startRow, startCol)
        i = 0;
        rowVector = [];
        while raw{startRow, startCol+i } > 0
            rowVector = [rowVector raw{startRow, startCol +i }] ;
            i = i+1;
        end
 end