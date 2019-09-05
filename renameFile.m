%% This little script is to remove multiple files in a directory

% files' directory
path = 'C:\Users\hitma\OneDrive\ROOT\Видео\YouTube\Иерей Георгий Максимов\Playlists\';
folder = 'Трансляции';
fullpath = [path folder];
cd(fullpath);
% get names of files

fileStruct = dir(fullpath);
temp = ~isfolder({fileStruct.name});

% names of files in cell array
fileNameC = {fileStruct(temp).name};

% names of files in string array
fileNameS = cellfun(@string, fileNameC)';

% find the index of each file
N = length(fileNameS);

for i=1:N
    % splitting file names according to '_' symbol
    temp = regexp(fileNameS(i)', '_', 'split');
    
    % writing two columns from temp variable to string array of size 216x2
    namestring(i, :) = temp(1, 1:2);
end



%{
% reassign values to old indices
%temp = str2double(nameString(:, 1));

% padding with leading zeros
for i=1:N
newIndex(i, :) = sprintf( '%03d', temp(i));
end
%}
% creating new names for files


% removing number indices from names
newname = namestring(:, 2);

%% now renaming files
for i = 1 : N
    movefile(char(fileNameS(i)), char(newname(i)));
end
