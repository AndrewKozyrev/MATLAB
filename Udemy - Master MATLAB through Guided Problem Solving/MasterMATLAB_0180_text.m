%% 
%     COURSE: Master MATLAB through guided problem-solving
%    SECTION: Vectors and variables
%      VIDEO: Working with text (characters and strings)
% Instructor: mikexcohen.com
%
%%

wholetext = 'Hello my name is Mike and I like purple.';

% separate into a cell array based on spaces
wordsep = regexp(wholetext, ' ', 'split');

% remove any words with exactly 4 characters
numchars   = cellfun(@length, wordsep);
words2keep = numchars~=4;
wordsep2 = wordsep(words2keep);

% replace 'Mike' with your name and 'purple' with your favorite color
targname  = 'Mike';
targcolor = 'purple';

namestart   = strfind(wholetext, targname);
colorstart  = strfind(wholetext, targcolor);
newtext     = [wholetext(1:namestart-1) 'Andrew Kozyrev' wholetext(namestart + length(targname):colorstart-1) ...
    'to watch TV' wholetext(colorstart + length(targcolor):end)]

%%
