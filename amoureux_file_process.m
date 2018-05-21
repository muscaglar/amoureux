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

keep_mat = sort(unique(keep_mat));
keep_mat_files = files_mat(keep_mat);

end