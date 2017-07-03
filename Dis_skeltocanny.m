function [ cf ] = Dis_skeltocanny( im,primskel_prev,interval)
%function to calculate the most recent distance from the skeleton to the edge

primskel_prev=sortrows(primskel_prev,1);
cannyImg=[];
cannyImg=edge(im, 'canny');
[x0,y0]=find(cannyImg);
a0=primskel_prev(:,1);
b0=primskel_prev(:,2);
jl=[];lj=[];cf=[];rn=1;
for i=1:interval:length(a0)
    Pmax=a0(i)+50;
    Pmin=a0(i)-50;
    Qmax=b0(i)+50;
    Qmin=b0(i)-50;
    zuo=1;you=1;
    for j=1:length(x0)
        if Pmin<x0(j)<Pmax
            if Qmin<y0(j)<Qmax
                if y0(j)<b0(i)
                    jl(zuo)=sqrt((a0(i)-x0(j))^2+(b0(i)-y0(j))^2);
                    Z(zuo,1)=x0(j);
                    Z(zuo,2)=y0(j);
                    zuo=zuo+1;
                elseif y0(j)>b0(i)
                    lj(you)=sqrt((a0(i)-x0(j))^2+(b0(i)-y0(j))^2);
                    Y(you,1)=x0(j);
                    Y(you,2)=y0(j);
                    you=you+1;
                end
            end
        end
    end
    [zx,zxxh]=min(jl);
    [yx,yxxh]=min(lj);
    cf(rn,1)=zx;cf(rn,2)=a0(i);cf(rn,3)=b0(i);
    cf(rn,4)=Z(zxxh,1);cf(rn,5)=Z(zxxh,2);
    cf(rn,6)=Y(yxxh,1);cf(rn,7)=Y(yxxh,2);
    jl=[];lj=[];
    rn=rn+1;
end
end

