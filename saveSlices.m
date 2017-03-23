function saveSlices(ctvol,xd,yd,zd,path,step)
%saveSlices(ctvol,xd,yd,zd,path,step) saves all images in the perpendicular
%direction to image plane identified by matrices (xd,yd and zd), that
%interpolated from the volume (ctVol) to the directory with URL of (path),
%the volume is sliced by steps equal to (step).
%
%OUTPUT: this function exports both DICOM and raw .mat files contains all  
%interpolated slices lies within the volume 'ctVol' in the normal direction 
%to the provided plane. Also, it displayes the slices that being exported.
%
%INPUT: 
%   -ctvol: 3D matrix contains the volume to be resliced.
%   -xd: 2D matrix contains the x- values of the slice plane 
%   -yd: 2D matrix contains the y- values of the slice plane 
%   -zd: 2D matrix contains the z- values of the slice plane 
%   -path: string contains the exporting URL
%   -step: is the spacing between each slice and the following one in the 
%           normal direction to the given slice plane.
% 
%   Created by: Hossam El-Rewaidy, Harvard University, March 2017.



if(nargin<6)
    step=4;
end

if(nargin<5)
    path = './';
end

if(nargin<4)
    return;
end

ctvol = cast(ctvol,'double');

s1=size(ctvol,1);
s2=size(ctvol,2);
s3=size(ctvol,3);

maxDis = max([s1, s2, s3])*sqrt(2);

b1 = [0 0 0; s1 0 0; s1 s2 0; 0 s2 0; 0 0 0];
b2 = [0 0 s3; s1 0 s3; s1 s2 s3; 0 s2 s3; 0 0 s3];

hold off

corners=[xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1)];
[n3] = getNormalToSurf(corners);

disp(['INTER-SLICE SPACING = ' num2str(step)])
info = dicominfo('anonDICOM.dcm');
instNum=0;

for i=-maxDis:step:maxDis
    %     disp('======= Please wait for saving ! ============')
    disp(['Saving Slice @ position' num2str(i) ' ...........'])
    hold off
    moveNorm=i;
    next_corners = [xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1)];
    
    xd = real(xd+moveNorm*n3(1));
    yd = real(yd+moveNorm*n3(2));
    zd = real(zd+moveNorm*n3(3));
    
    corners=[xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1)];
    cent = [mean(corners(:,1)) ,mean(corners(:,2)) ,mean(corners(:,3))];
    
    plot3(cent(1),cent(2),cent(3))
    hold on
    
    I = mirt3D_mexinterp(ctvol,xd,yd,zd);
    
    I(isnan(I))=0;
    
    if(sum(I(:))==0)
        xd = real(xd-moveNorm*n3(1));
        yd = real(yd-moveNorm*n3(2));
        zd = real(zd-moveNorm*n3(3));
        continue
    end
    
    ImageOrientationPatient = [(corners(2,:)-corners(1,:))/norm(corners(2,:)-corners(1,:)) (corners(4,:)-corners(1,:))/norm(corners(4,:)-corners(1,:)) ];
    ImagePositionPatient = [corners(1,:)];
    instNum=instNum+1;
    info.InstanceNumber = instNum;
    info.ImageOrientationPatient = ImageOrientationPatient;
    info.ImagePositionPatient = ImagePositionPatient;
    
    dicomwrite(I,strcat(path,'\IM 0',int2str(instNum)),info)
    
    save(strcat(path,'\RIM 0',int2str(instNum)),'I','ImageOrientationPatient','ImagePositionPatient','corners');
    
    I = (255/6)*((I / (max(ctvol(:))-min(ctvol(:))))+1);
    
    surfh = surface('XData',xd,'YData',yd,'ZData',zd,...
        'CData', I,...
        'EdgeColor','none',...
        'LineStyle','none',...
        'Marker','none',...
        'MarkerFaceColor','none',...
        'MarkerEdgeColor','none',...
        'CDataMapping','direct');
    
    plotCornersAndAxes(corners,next_corners, b1, b2)
    
    xd = real(xd-moveNorm*n3(1));
    yd = real(yd-moveNorm*n3(2));
    zd = real(zd-moveNorm*n3(3));
    
    
    pause(0.2)
end

disp('======= Saving Finished ! ============')

end

