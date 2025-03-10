function  ECM=elasticCost(Q11, Q12, Q22)

    [size1,size2]=size(Q11);
    ECM=zeros(size1,size2);
    dxQxx=0.5*(Q11(2:size1-1,3:size2)-Q11(2:size1-1,1:size2-2));
    dyQxx=0.5*(Q11(3:size1,2:size2-1)-Q11(1:size1-2,2:size2-1));
    dxQxy=0.5*(Q12(2:size1-1,3:size2)-Q12(2:size1-1,1:size2-2));
    dyQxy=0.5*(Q12(3:size1,2:size2-1)-Q12(1:size1-2,2:size2-1));
    dxQyy=0.5*(Q22(2:size1-1,3:size2)-Q22(2:size1-1,1:size2-2));
    dyQyy=0.5*(Q22(3:size1,2:size2-1)-Q22(1:size1-2,2:size2-1));
    
    ECM(2:(size1-1),2:(size2-1))=(dxQxx.*dxQxx+dyQxx.*dyQxx+2*dxQxy.*dxQxy+2*dyQxy.*dyQxy...
        +dxQyy.*dxQyy+dyQyy.*dyQyy);
    EC=mean(ECM,'all','omitmissing');

end
