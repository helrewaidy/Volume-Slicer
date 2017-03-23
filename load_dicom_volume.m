function [ stack, permutation ] = load_dicom_volume( directory )
% Reads the dicom volume from directory. It is assumed that each slice is
% stored in a separate file. The function reads all images, sorts them
% according to the SliceLocation and returns the image together with the
% permutation applied to the axes (e.g. to keep track of the scaling).

fprintf('Reading DICOM images in %s...\n',directory)

files = get_files(directory,'img');
if(~numel(files))
    fprintf('%s: No .img files found,\n trying .dcm please wait ...', mfilename('fullpath'));
    files = get_files(directory,'dcm');
    if(~numel(files))
        error('Neither .img nor .dcm files found.')
    end
end

% read file info
slice_positions = [];
for i=1:numel(files)
    info{i} = dicominfo(fullfile(directory,files{i}));
    slice_positions(i) = info{i}.SliceLocation;
end

stack = zeros(info{1}.Width,info{1}.Height,numel(files));

for i=1:numel(files)
    image = dicomread(fullfile(directory,files{i}));
    stack(:,:,i) = image';
end

% check if slices are sorted correctly
[sorted inds] = sort(slice_positions);
if(length(find(diff(inds)==1))~=length(inds)-1)
    stack = stack(:,:,inds);
end

% orient to DICOM's LPS
orient = info{1}.ImageOrientationPatient;
dir_x = orient(1:3);
dir_y = orient(4:6);
dir_z = cross(dir_x,dir_y);

[nil x] = max(abs(dir_x));
[nil y] = max(abs(dir_y));
[nil z] = max(abs(dir_z));

% correct sign of axes

if(sign(dir_x(x))==-1)
    stack=flipdim(stack,1);
end
if(sign(dir_y(y))==-1)
    stack=flipdim(stack,2);
end
if(sign(dir_z(z))==-1)
    stack=flipdim(stack,3);
end

% now after the signs are fine, do the permutation
permutation = [x y setdiff([1:3],[x y])];
stack = permute(stack,permutation);