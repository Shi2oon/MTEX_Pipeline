I = imread('P:\Abdo\untitled2.png','PNG');
imshow(I,[]);
I=openfig('P:\Abdo\untitled2.fig');
title ('first draw a line along the legend and another along the map');
[xl,yl] = ginput(2);    xlline = [xl(1), xl(1)];    ylline = [yl(1), yl(2)];
[x,y] = ginput(2);      xline  = [x(1), x(2)];      yline  = [y(1), y(2)];
Imax = input('Legend Max value:  ');    Imin = input('Legend Min value:  ');
[clx,cly,cl]=improfile(I,xlline,ylline);    [cx,cy,c]=improfile(I,xline,yline);
cl=squeeze(cl);                               c=squeeze(c);
plot(cl(:,3))
imagesec(cl)
