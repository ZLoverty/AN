function newfield=sample_field(inputfield,spacing)
[Ly,Lx]=size(inputfield);
y=spacing:spacing:Ly;
x=spacing:spacing:Lx;
ky=size(y,2);
kx=size(x,2);
[X,Y]=meshgrid(x,y);%sampled mesh
newfield=zeros(ky,kx);

for i=1:ky
    for j=1:kx
        newfield(i,j)=inputfield(Y(i,j),X(i,j));
    end
end