function [S,P,Sm,Pm,A]=Order2(ProjDir,teta,nav)
phi=0:0.1:2*pi;
Np=numel(phi);
Ni=numel(ProjDir);

Pol=zeros(Np,Ni);
for np=1:Np
teta=phi(np);
SS=cellfun(@(x) 2.*cos(x(:,3)-teta).^2-1,ProjDir,'UniformOutput',0);
S=cellfun(@(x) mean(x),SS);
Pol(np,:)=S;
end

P=zeros(1,Ni);
A=zeros(1,Ni);
for ni=1:Ni
    values=Pol(:,ni);
%     plot(values)
    length(values);
    [v ind]=max(values);
    P(ni)=values(1);
    A(ni)=phi(ind);
%     pause(.1)
end

plot(P)

Sm=zeros(size(S));
for k=1:length(S)
    Sm(k)=mean(S(k:min(k+nav,length(S))));
end

PP=cellfun(@(x) cos(x(:,3)-teta),ProjDir,'UniformOutput',0);
P=cellfun(@(x) mean(x),PP);

Pm=zeros(size(P));
for k=1:length(P)
    Pm(k)=mean(P(k:min(k+nav,length(P))));
end

% figure()
% subplot(121)
% plot(S,'b-')
% title('Nematic Order')
% subplot(122)
% plot(P,'r-')
% title('Polar Order')
end
end