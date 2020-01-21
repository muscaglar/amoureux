function [files,keep_mat_files] = amoureux_file_process(fileroot)

files = dir(fullfile(fileroot, '*.tdms'));
files_mat = dir(fullfile(fileroot, '*.mat'));
%% This checks if the DAT file has a corressponding MAT file and will omit it from analysis.
keep_mat = [];
remove_id = [];
for j = 1:numel(files_mat)
    mat_number = coolwater_getNumber(files_mat(j).name);
    for k = 1:numel(files)
        file_number = coolwater_getNumber(files(k).name);
        if(mat_number==file_number)
            remove_id = [remove_id, k];
            keep_mat = [keep_mat, j];
        end
    end
end

files(remove_id) = [];
if(isempty(files))
else
    [delete] = remove_corrupt_TDMS(files);
end

keep_mat = sort(unique(keep_mat));
keep_mat_files = files_mat(keep_mat);


    function [delete,also_delete] = remove_corrupt_TDMS(files)
        also_delete = [];
        n =zeros(1,length(files));
        for i=1:length(files)
            m = strsplit(files(i).name,'_');
            if ( length(m) >= 6)
                m = m{length(m)};
                m = strsplit(m,'.');
                m = m{1};
                n(i) = str2num(m);
            else
                also_delete = i;
            end
        end
        n = n';
        [~, uniqueIdx] = unique( n );
        duplicateLocations = ismember( n, find( n( setdiff( 1:numel(n), uniqueIdx ) ) ) );
        delete = setdiff( 1:numel(n), uniqueIdx );
        delete = [delete, also_delete];
    end

end