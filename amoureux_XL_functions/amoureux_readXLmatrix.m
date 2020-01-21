
    function [ Matrix ] =amoureux_readXLmatrix( raw , startRow, startCol, noRows, noCols)
        % Read Excel Matrix - if noRows = 0 of noCols = 0 then it reads as many of
        % these cols are full
        
        Matrix = [];
        i = 0;
        if noRows > 0 && noCols > 0
            Matrix = raw(startRow:startRow+noRows-1,starCol:startCol+noCols-1);
        elseif noRows == 0
            while raw{startRow + i, startCol } > 0
                Matrix = [Matrix; raw(startRow + i, (startCol):(startCol + noCols-1) )] ;
                i = i+1;
            end
            
        elseif noCols == 0
            while raw{startRow, startCol + i} > 0
                Matrix = [Matrix raw(startRow:(startRow + noRows-1), (startCol+i) )] ;
                i = i+1;
            end
            
        else
            %Read in an unlimited matrix in either Cols or Rows - but ensure
            %complete.
            
        end
        
        
    end
