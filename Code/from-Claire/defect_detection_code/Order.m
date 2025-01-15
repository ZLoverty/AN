function [S,P,Sm,Pm]=Order(ProjDir,teta,nav)
SS=cellfun(@(x) 2.*cos(x(:,3)-teta).^2-1,ProjDir,'UniformOutput',0);
S=cellfun(@(x) mean(x),SS);

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