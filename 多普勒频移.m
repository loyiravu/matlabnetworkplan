vk=0:10:350;
q=-pi:0.01:pi;
[q,vk]=meshgrid(q,vk);
v=vk*10^3/3600;
f=1800*10^3;
w=299792458/f;
fd=v./w.*cos(q);
mesh(q,vk,fd)
xlabel('q=角度');
ylabel('vk=速度');
zlabel('fd=多普勒频移');
axis([-pi,pi,0,350,-1,1]);
a=max(max(fd))
b=min(min(fd))
a =
    0.5837

b =
   -0.5837