function plotCornersAndAxes(corners,next_corners, b1, b2)

corners =[corners; corners(1,:)];

plot3(corners(:,1),corners(:,2),corners(:,3),'r')
plot3(corners(1,1),corners(1,2),corners(1,3),'ro')
ax1 = [(corners(1,:)+corners(2,:))/2; (corners(3,:)+corners(4,:))/2];
ax2 = [(corners(2,:)+corners(3,:))/2; (corners(4,:)+corners(1,:))/2];

center = [mean(corners(1:4,1)) mean(corners(1:4,2)) mean(corners(1:4,3))];
[ax3_dir tmp1 tmp2 tmp3] = getNormalToSurf(next_corners);

ax3 = [center+ax3_dir*150 ; center-ax3_dir*150];

plot3(ax1(:,1),ax1(:,2),ax1(:,3),'m','LineWidth',2);
plot3(ax2(:,1),ax2(:,2),ax2(:,3),'g','LineWidth',2);
plot3(ax3(:,1),ax3(:,2),ax3(:,3),'b','LineWidth',2);

plot3(b1(:,1),b1(:,2),b1(:,3),'c')
plot3(b2(:,1),b2(:,2),b2(:,3),'c')

for i=1:4
    plot3([b1(i,1) b2(i,1)],[b1(i,2) b2(i,2)],[b1(i,3) b2(i,3)],'c')
end

plot3(b1(1,1),b1(1,2),b1(1,3),'co')
plot3(b1(2,1),b1(2,2),b1(2,3),'cx')

end
