function [ files ] = get_files( directory, pattern, pattern_mode)
% Returns cell array containing all files of a given directory.
% If pattern is given, only filenames matching the pattern are returned.
% The search can be either a wild-card or regular expression search and is
% case insensitive.
%
%    pattern    - Default: *.* (All files)
%               - Wild-card examples
%                   filePattern = '*.xls' % find Excel files
%                   filePattern = {'*.m' *.mat' '*.fig'}; % MATLAB files
%               - Regular expression examples (See regexpi help for more)
%                   filePattern = '^[af].*\.xls' % Excel files beginning
%                                                % with either A,a,F or f
%
%    pattern_mode   - Default: 'wildcard'
%                   - 'wildcard' for wild-card searches or 
%                   - 'regexp' for regular expression searches
%
% author: Frank Preiswerk (2013)

if(~exist(directory,'dir'))
    error(sprintf('Directory %s does not exist.',directory))
end

if ~exist('pattern','var') || isempty(pattern)
    pattern={'*.*'};
end

if ~exist('pattern_mode','var') || isempty(pattern_mode)
    pattern_mode = 'wildcard';
end

switch lower(pattern_mode)
    case 'regexp'
        % file pattern is already a regular expression, nothing to
        % do
    otherwise
        % file pattern is a wildcard. Convert to regular expression
        pattern = regexptranslate(pattern_mode,pattern);
end

dir_contents = dir(directory);

files = {};
for i=1:numel(dir_contents)
    if(~dir_contents(i).isdir)
        if(~isempty(regexpi(dir_contents(i).name,pattern)))
            files{end+1} = dir_contents(i).name;
        end
    end
end
