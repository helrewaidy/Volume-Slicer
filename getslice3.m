function [surfh xd yd zd next_corners vol_center] = getslice3(ctvol,corners,xd, yd, zd,vol_center,tx,ty,tz,rx,ry,rz,moveNorm)
% 
% [surfh xd yd zd next_corners vol_center] = getslice3(ctvol,corners,... 
% xd,yd, zd,vol_center,tx,ty,tz,rx,ry,rz,moveNorm) interpolated the volume  
% 'ctvol' at the plane defined by 'xd, yd, and zd' matrices after applying
% the translations 'tx, ty, and tz', rotations 'rx, ry, and rz', and motion 
% in normal direction by step of 'moveNorm'.  
% 

% created by: Hossam El-Rewaidy, March 2017.
% 

if(nargin<7)
     tx=0; ty=0; tz=0; rx=0; ry=0; rz=0; moveNorm=0;
end
    
ctvol = cast(ctvol,'double');

rs=(1/sqrt(1-sin(pi/4)^2));

s2=size(ctvol,1);
s1=size(ctvol,2);
s3=size(ctvol,3);

b1 = [1 1 0; s1 1 0; s1 s2 0; 1 s2 0; 1 1 0];
b2 = [0 0 s3; s1 0 s3; s1 s2 s3; 0 s2 s3; 0 0 s3];
if(isempty(vol_center))
    vol_center = [mean([b1(1:4,1); b2(1:4,1)]) mean([b1(1:4,2); b2(1:4,2)]) mean([b1(1:4,3); b2(1:4,3)])];
end
if(isempty(corners))
    corners = b1*rs;
end

if(isempty(xd) | isempty(zd) |isempty(yd))
    hsp = surface(linspace(1,ceil(s1*rs),ceil(s1*rs)),linspace(1,ceil(s2*rs),ceil(s2*rs)),zeros(ceil(s1*rs),ceil(s2*rs)));
    rotate(hsp,[1 0 0],0)
    rotate(hsp,[0 1 0],0)
    rotate(hsp,[0 0 1],0)
    xd = get(hsp,'XData');
    yd = get(hsp,'YData');
    zd = get(hsp,'ZData');
    if(ishandle(hsp))
        delete(hsp);
    end
end


corners1=[xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1)];
curr_c = [mean(corners1(:,1)) mean(corners1(:,2)) mean(corners1(:,3))];

[n3, s3x1, s3x2, s3x3] = getNormalToSurf(corners1);
corners1 = [corners1;corners1(1,:)];
plot3(corners1(:,1)+vol_center(1)-curr_c(1),corners1(:,2)+vol_center(2)-curr_c(2),corners1(:,3)+vol_center(3)-curr_c(3),'color',[.1 .3 .1])

hold on
%create surface
hsp = surface(linspace(1,s1,s1),linspace(1,s2,s2),zeros(s1,s2),'Visible', 'off');

set(hsp,'XData',xd);
set(hsp,'YData',yd);
set(hsp,'ZData',zd);

rotate(hsp,s3x1,rx,curr_c)
rotate(hsp,s3x2,ry,curr_c)
rotate(hsp,s3x3,rz,curr_c)

xd = get(hsp,'XData');
yd = get(hsp,'YData');
zd = get(hsp,'ZData');

if(ishandle(hsp))
    delete(hsp);
end

next_corners = [xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1);xd(1,1) yd(1,1) zd(1,1)];

center = [mean(corners(1:4,1)) mean(corners(1:4,2)) mean(corners(1:4,3))];

ax1 = [(corners(2,:)+corners(3,:))/2-center]/norm([(corners(2,:)+corners(3,:))/2-center]);
ax2 = [(corners(1,:)+corners(2,:))/2-center]/norm([(corners(1,:)+corners(2,:))/2-center]);
ax3 = cross(ax1,ax2);

xd = real(xd-curr_c(1)+vol_center(1)+moveNorm*n3(1)+tx*ax1(1)+ty*ax2(1)+tz*ax3(1));
yd = real(yd-curr_c(2)+vol_center(2)+moveNorm*n3(2)+tx*ax1(2)+ty*ax2(2)+tz*ax3(2));
zd = real(zd-curr_c(3)+vol_center(3)+moveNorm*n3(3)+tx*ax1(3)+ty*ax2(3)+tz*ax3(3));

corners=[xd(1,1) yd(1,1) zd(1,1); xd(1,end) yd(1,end) zd(1,end) ; xd(end,end) yd(end,end) zd(end,end);xd(end,1) yd(end,1) zd(end,1)];
cent = [mean(corners(:,1)) ,mean(corners(:,2)) ,mean(corners(:,3))];
vol_center =cent;

plot3(cent(1),cent(2),cent(3))


I = mirt3D_mexinterp(ctvol,xd,yd,zd);
% I(isnan(I))=0;
I = (255/6)*((I / (max(ctvol(:))-min(ctvol(:))))+1);

surfh = surface('XData',xd,'YData',yd,'ZData',zd,...
    'CData', I,...
    'EdgeColor','none',...
    'LineStyle','none',...
    'Marker','none',...
    'MarkerFaceColor','none',...
    'MarkerEdgeColor','none',...
    'CDataMapping','direct');

colormap gray
hold on

plotCornersAndAxes(corners,next_corners, b1, b2)

end



