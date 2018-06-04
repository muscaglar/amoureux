function [] = amoureux_trans()

fileroot = uigetdir('amoureux Selector');
files = dir(fullfile(fileroot, '*.DTA'));

% No  = inputdlg('Enter the sampling rate in kHz');
% s_freq = str2double(No{1,1});
% 
% button = questdlg(['Is ' No{1,1} ' kHz definitely the sampling rate?']);
% if strcmp(button, 'Yes') == 1
%     s_freq = str2double(No{1,1});
% else
%     No  = inputdlg('Enter the sampling rate in kHz');
%     s_freq = str2double(No{1,1});
% end

s_freq = 300;

current = [];
voltage = [];
time = [];

for j = 1:length(files)
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name));
    else
        filepath = char(strcat(fileroot,'/',files(j).name));
    end
    [A,~,~,~,~,~] = amoureux_txt2mat(filepath,'NumHeaderLines',62);
    if (j == 1)
        voltage = A(:,3);
        current = A(:,4);
        %time = A(:,2);
    else
        voltage = [voltage; A(:,3)];
        current = [current; A(:,4)];
        %time = [time; A(:,2)];
    end
end
voltage = voltage';
current = current';
% time = time';
time = 0:1/(s_freq*1000):(length(current)-1)/(s_freq*1000);

voltage(1:8)=[];
current(1:8)=[];
time(1:8)=[];

if(ispc)
    save_mat = char(strcat(fileroot,'\','saved_trans.mat'));
else
    save_mat = char(strcat(fileroot,'/','saved_trans.mat'));
end

save(save_mat,'time','current','voltage');
end