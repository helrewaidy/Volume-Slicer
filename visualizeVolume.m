function visualizeVolume(D,downsamplingRate)
% visualizeVolume(D,downsamplingRate) displays the provided 3D volume 'D' 
% with sampling rate of 'downsamplingRate'. 
% 
% OUTPUT: Display 3D Volume.
% INPUTs:
%   -D: is the 3D volume to be displayed.
%   -downsamplingRate: the rate that volume D will be down sampled with to 
%       keep fast displaying.
% 
% Created by: Hossam El-Rewaidy, Harvard University, March 2017.
% 

if(nargin<2)
   downsamplingRate = 4; 
end

if(nargin<1)
   return 
end

D = D(1:downsamplingRate:end,1:downsamplingRate:end,1:downsamplingRate:end);
limits = [NaN NaN NaN NaN NaN size(D,3)];
[x, y, z, D] = subvolume(D, limits);           % extract a subset of the volume data

[fo,vo] = isosurface(x,y,z,D,20);               % isosurface for the outside of the volume
[fe,ve,ce] = isocaps(x,y,z,D,5);               % isocaps for the end caps of the volume

p1 = patch('Faces', fo, 'Vertices', vo);       % draw the outside of the volume
p1.FaceColor = 'red';
p1.EdgeColor = 'none';
p1.FaceAlpha = 0.6;

p2 = patch('Faces', fe, 'Vertices', ve,'FaceVertexCData', ce); % draw the end caps of the volume
p2.FaceColor = 'interp';
p2.EdgeColor = 'none';
p2.FaceAlpha = 1;

camlight(40,40)                                % create two lights 
camlight(-20,-10)
lighting gouraud

end