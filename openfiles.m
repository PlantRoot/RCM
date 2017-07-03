function openfiles

global filename fileno img others hslider;

fn1=1;
fns=1;
fn2=str2num(fileno);

if fn1==fn2
    if exist(filename,'file'),
        fname=sscanf(filename(end:-1:1),'%[^\\^/]');
        fname=fname(end:-1:1);
        img(1).filename=fname;
        img(1).image=imread(filename); %(read filename)
        img(1).imageorg=imread(filename);
        img(1).skel=[];
        others.cimage=1;
    else
        str=sprintf('File "%s" not found',filename);
        warndlg(str,'File not found');
        return
    end
    return
end

nn=findstr(filename,'#');

if isempty(nn),
    warndlg('Please identify the sequence no. in the template with #', 'File template error');
    return;
end

fname1=filename(1:nn(1)-1);
fname2=filename(nn(end)+1: end);

%str2num converts string to integer

h=mywaitbar(0,'Loading files, please wait ...');
nfc=length(fn1:fns:fn2);
n=0;
for i=fn1:fns:fn2,
    if length(nn)==1,
        filenames=sprintf('%s%d%s',fname1,i,fname2);
    elseif length(nn)==2,
        filenames=sprintf('%s%02d%s',fname1,i,fname2);
    elseif length(nn)==3,
        filenames=sprintf('%s%03d%s',fname1,i,fname2);
    elseif length(nn)==4,
        filenames=sprintf('%s%04d%s',fname1,i,fname2);
    elseif length(nn)==5,
        filenames=sprintf('%s%05d%s',fname1,i,fname2);
    elseif length(nn)==6,
        filenames=sprintf('%s%06d%s',fname1,i,fname2);
    end
    fname=sscanf(filenames(end:-1:1),'%[^\\^/]');
    fname=fname(end:-1:1);
    if exist(filenames,'file'),
        n=n+1;
        img(n).filename=fname;
        img(n).image=imread(filenames);
        img(n).imageorg=imread(filenames);
        img(n).skel=[];
        mywaitbar(n/nfc);
    else
        str=sprintf('%s not found',filenames);
        disp(str);
    end
end
close(h);

if n>0
    others.cimage=1;
    nimage=length(img);
    if nimage > 0,
        sliderstep=[1/nimage,min(1,10/nimage)];
    else
        sliderstep=[0.01,1];
    end
    hslider = uicontrol(gcf,'style','slider','position',[150 15 350 20],...
        'Min',1,'Max',max(nimage,2),'SliderStep',sliderstep, ...
        'callback','playslider');
    imagedraw(others.cimage);
end
return
