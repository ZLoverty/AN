function [Phip,Phin]=OrthProj(Phi,position,center)
xc=center(1);
yc=center(2);
xp=position(1);
yp=position(2);
r=sqrt((xp-xc).^2+(yp-yc).^2);
cost=(xp-xc)./r;
sint=(yp-yc)./r;
% R=[-sint cost;-cost -sint];
r=sqrt((xp-xc).^2+(yp-yc).^2);
rx=(xp-xc)./r;
ry=(yp-yc)./r;
tx=-ry;
ty=rx;
R=[tx ty;-ty tx];
X=[cos(Phi);sin(Phi)];
Xr=R*X;
% Phip=atan2(Xr(2),Xr(1));
Phin=atan2(sint,cost)+pi/2;
Phip=Phin-Phi;
if Phip>pi
    Phip=Phip-2.*pi;
end
if Phip<-pi
    Phip=Phip+2.*pi;
end
    
%
% % ProjDir=cell(1,N);
% for ni=1:N
%     Directions=DefDir{ni};
%     dims=size(Directions);
%     Nd=dims(1);
%     Angles=zeros(Nd,3);
%     for k=1:Nd
%         xp=Directions(k,1);
%         yp=Directions(k,2);
%         Phi=Directions(k,3);
%         r=sqrt((xp-xc).^2+(yp-yc).^2);
%         rx=(xp-xc)./r;
%         ry=(yp-yc)./r;
%         tx=-ry;
%         ty=rx;
%         %         teta=atan2(ty,tx);
%         R=[tx ty;-ty tx];
%         X=[cos(Phi);sin(Phi)];
%         Xr=R*X;
%         Phi2=atan2(Xr(2),Xr(1));
%         Angles(k,:)=[xp yp Phi2];
%     end
%     ProjDir{ni}=Angles;
end