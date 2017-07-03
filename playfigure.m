function playfigure
global img others skelval priskelval IndiRootval BraPtsval;

nimages=length(img);
n=others.cimage;
if n==nimages,
    n=1;
end

for i=n:nimages
    others.cimage=i;
    imagedraw(i);
    hold on;
    if skelval==1
        skelline(i)=plot(img(i).skel(:,2),img(i).skel(:,1),'b.','markersize',0.5);
    end
    hold on;
    if priskelval==1
        priskelline(i)=plot(img(i).priskel(:,2),img(i).priskel(:,1),'r.','markersize',0.5);
    end
    hold on;
    if BraPtsval==1
        if img(i).BraPts(:,2)~=0
            BraPts(i)=plot(img(i).BraPts(:,2),img(i).BraPts(:,1),'ro','markersize',5);
        end
    end
    if IndiRootval==1
        if length(img(i).tiplable)~=0
            Tipseg(i)=plot(img(i).tiplable(:,2),img(i).tiplable(:,1),'g.','markersize',1);
            Tippoint(i)=plot(img(i).tipPts(:,2),img(i).tipPts(:,1),'r*','markersize',5);
        end
    end
    hold off;
    drawnow;
end
return
