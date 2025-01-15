function [Fs]=smooth_flow(F,threshold,lowpass_threshold)
    [l1, l2]=size(F);
    N=max(l1,l2);
    F_bis=reshape(F,1,[]);
    Fs=zeros(N);
    
    %% Removing peaks
    
    sharpleft=zeros(1,N);
    sharpright=zeros(1,N);
    b=zeros(1,N);
    
    for i=2:N-1
        sharpleft(1,i)=abs(F_bis(1,i-1)-F_bis(1,i))>threshold;
        sharpright(1,i)=abs(F_bis(1,i+1)-F_bis(1,i))>threshold;
        b(1,i)=(F_bis(1,i-1)-F_bis(1,i))*(F_bis(1,i+1)-F_bis(1,i))>0 ;
    end
    %first condition change must be big enough



    figure()
    plot(b.*sharpleft.*sharpright.*F_bis(1,:),'*')
    hold on
    plot(F_bis(1,:),'b')

    F1=zeros(1,N);
    for i=2:N-1
        if b(1,i)*sharpleft(1,i)*sharpright(1,i)==1
            F1(1,i)=(F_bis(1,i-1)+F_bis(1,i+1))/2;
    
        else
            F1(1,i)=F_bis(1,i);
        end
    end
    
    %% second time of removing peaks
    sharpleft=zeros(1,N);
    sharpright=zeros(1,N);
    b=zeros(1,N);
    
    for i=2:N-1
        sharpleft(1,i)=abs(F1(1,i-1)-F1(1,i))>threshold;
        sharpright(1,i)=abs(F1(1,i+1)-F1(1,i))>threshold;
        b(1,i)=(F1(1,i-1)-F1(1,i))*(F1(1,i+1)-F1(1,i))>0 ;
    end
    %first condition change must be big enough



    figure(2)
    plot(b.*sharpleft.*sharpright.*F1(1,:),'*')
    hold on
    plot(F1(1,:),'b')

    F2=zeros(1,N);
    for i=2:N-1
        if b(1,i)*sharpleft(1,i)*sharpright(1,i)==1
            F2(1,i)=(F1(1,i-1)+F1(1,i+1))/2;
    
        else
            F2(1,i)=F1(1,i);
        end
    end
    
    %% Low pass filtering
    Fs=lowpass(F2,lowpass_threshold);
    
end