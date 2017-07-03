function varargout = RootTraits(varargin)
% ROOTTRAITS MATLAB code for RootTraits.fig
%      ROOTTRAITS, by itself, creates a new ROOTTRAITS or raises the existing
%      singleton*.
%
%      H = ROOTTRAITS returns the handle to a new ROOTTRAITS or the handle to
%      the existing singleton*.
%
%      ROOTTRAITS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROOTTRAITS.M with the given input arguments.
%
%      ROOTTRAITS('Property','Value',...) creates a new ROOTTRAITS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RootTraits_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RootTraits_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RootTraits

% Last Modified by GUIDE v2.5 14-Jun-2017 19:35:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RootTraits_OpeningFcn, ...
    'gui_OutputFcn',  @RootTraits_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RootTraits is made visible.
function RootTraits_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RootTraits (see VARARGIN)

% Choose default command line output for RootTraits
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RootTraits wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RootTraits_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filenametemplate.
function filenametemplate_Callback(hObject, eventdata, handles)
% hObject    handle to filenametemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global skelval priskelval IndiRootval BraPtsval;
set(handles.filetemplate,'string','');
set(handles.fileno,'string','');
skelval=0;
priskelval=0;
IndiRootval=0;
BraPtsval=0;
[filename, directory] =uigetfile('*.jpg;*.jpeg;*.tif;*.tiff', ...
    'Select first file');
if filename==0
    return
end
cd(directory);
str = sprintf('%s%s',directory, filename);
set(handles.filetemplate,'string',str);


function filetemplate_Callback(hObject, eventdata, handles)
% hObject    handle to filetemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filetemplate as text
%        str2double(get(hObject,'String')) returns contents of filetemplate as a double


% --- Executes during object creation, after setting all properties.
function filetemplate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filetemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function fileno_Callback(hObject, eventdata, handles)
% hObject    handle to fileno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileno as text
%        str2double(get(hObject,'String')) returns contents of fileno as a double


% --- Executes during object creation, after setting all properties.
function fileno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotarea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotarea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Openfiles.
function Openfiles_Callback(hObject, eventdata, handles)
% hObject    handle to Openfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename fileno;
axes(handles.axes);
filename=get(handles.filetemplate,'String'); %(from filetemplate.m)
fileno=num2str(get(handles.fileno,'String'));
openfiles;


% --- Executes during object creation, after setting all properties.
function axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes


% --- Executes on button press in Dynamic.
function Dynamic_Callback(hObject, eventdata, handles)
% hObject    handle to Dynamic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global others skelval priskelval IndiRootval BraPtsval;
skelval=get(handles.skelradio,'value');
priskelval=get(handles.PriSkelradio,'value');
IndiRootval=get(handles.Indirootradio,'value');
BraPtsval=get(handles.BraPtsradio,'value');
others.slowness=0.0;
playfigure;


function edittop_Callback(hObject, eventdata, handles)
% hObject    handle to edittop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edittop as text
%        str2double(get(hObject,'String')) returns contents of edittop as a double


% --- Executes during object creation, after setting all properties.
function edittop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edittop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editbottom_Callback(hObject, eventdata, handles)
% hObject    handle to editbottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editbottom as text
%        str2double(get(hObject,'String')) returns contents of editbottom as a double


% --- Executes during object creation, after setting all properties.
function editbottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editbottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editleft_Callback(hObject, eventdata, handles)
% hObject    handle to editleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editleft as text
%        str2double(get(hObject,'String')) returns contents of editleft as a double


% --- Executes during object creation, after setting all properties.
function editleft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editright_Callback(hObject, eventdata, handles)
% hObject    handle to editright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editright as text
%        str2double(get(hObject,'String')) returns contents of editright as a double


% --- Executes during object creation, after setting all properties.
function editright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Cropbutton.
function Cropbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cropbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global topmost bottommost leftmost rightmost;
topmost=str2num(get(handles.edittop,'String'));
bottommost=str2num(get(handles.editbottom,'String'));
leftmost=str2num(get(handles.editleft,'String'));
rightmost=str2num(get(handles.editright,'String'));
imagecrop;


% --- Executes on button press in Registerbutton.
function Registerbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Registerbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagesregister;


% --- Executes on button press in Thresholdingbutton.
function Thresholdingbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Thresholdingbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global threshvalue thresh;
threshvalue=get(handles.Threshedit,'String');
imagesBW;
threshstr=num2str(thresh);
set(handles.Threshedit,'String',threshstr);


function Threshedit_Callback(hObject, eventdata, handles)
% hObject    handle to Threshedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Threshedit as text
%        str2double(get(hObject,'String')) returns contents of Threshedit as a double


% --- Executes during object creation, after setting all properties.
function Threshedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebwbutton.
function savebwbutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebwbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
nimages=length(img);
[FileName,PathName] = uiputfile('*.jpg');
for  i=1:nimages
    str=strcat(PathName,num2str(i),FileName);
    images=img(i).image;
    imwrite(images,str);
end


% --- Executes on button press in globaltraitsbutton.
function globaltraitsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to globaltraitsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global skelval priskelval IndiRootval BraPtsval;
skelval=get(handles.skelradio,'value');
priskelval=get(handles.PriSkelradio,'value');
IndiRootval=get(handles.Indirootradio,'value');
BraPtsval=get(handles.BraPtsradio,'value');
globaltraits;


% --- Executes on button press in skelradio.
function skelradio_Callback(hObject, eventdata, handles)
% hObject    handle to skelradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of skelradio


% --- Executes on button press in PriSkelradio.
function PriSkelradio_Callback(hObject, eventdata, handles)
% hObject    handle to PriSkelradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PriSkelradio


% --- Executes on button press in Indirootradio.
function Indirootradio_Callback(hObject, eventdata, handles)
% hObject    handle to Indirootradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Indirootradio


% --- Executes on button press in BraPtsradio.
function BraPtsradio_Callback(hObject, eventdata, handles)
% hObject    handle to BraPtsradio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BraPtsradio


% --- Executes on button press in extractglobaltraitsbutton.
function extractglobaltraitsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to extractglobaltraitsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global morphologycell;
Title={ 'Image' 'Area' 'Length' 'Width' 'Depth' 'ConvexHull' 'PrimaryArea' 'LateralArea' 'PrimaryLength' 'BranchNum' 'PrimTipDiam' 'ApicalunBranLen'};
[FileName,PathName] = uiputfile('*.csv');
str=strcat(PathName,FileName);
csvwriteh(str, morphologycell, Title);


% --- Executes on button press in extractinditraitsbutton.
function extractinditraitsbutton_Callback(hObject, eventdata, handles)
% hObject    handle to extractinditraitsbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
nimages=length(img);
[FileName,PathName] = uiputfile('*.csv');
header={'Label' 'PixelsCount' 'Radius_mean' 'Radius_median' 'Pixels_Num' 'Length_mean' 'Order' 'Rank' 'SingleRoot' 'Side' 'Tip_Angle' 'BranchPts_X' 'BranchPts_Y' 'Tip_Diam'};
for  i=1:nimages
    str=strcat(PathName,num2str(i),FileName);
    if length(img(i).topology_seg)~=0
        topology_seg=img(i).topology_seg;
        [data] = savdata(topology_seg);
        csvwriteh(str, data, header);
    end
end


% --- Executes on button press in zonedivibtn.
function zonedivibtn_Callback(hObject, eventdata, handles)
% hObject    handle to zonedivibtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global rgbLabel maininterval;
set(handles.skelradio,'value',0);
set(handles.PriSkelradio,'value',0);
set(handles.Indirootradio,'value',0);
set(handles.BraPtsradio,'value',0);
maininterval=str2num(get(handles.zonelenedit,'String'));
zonergbLabel;
imshow(rgbLabel);


function cutfilename_Callback(hObject, eventdata, handles)
% hObject    handle to cutfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cutfilename as text
%        str2double(get(hObject,'String')) returns contents of cutfilename as a double


% --- Executes during object creation, after setting all properties.
function cutfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cutfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MSIbutton.
function MSIbutton_Callback(hObject, eventdata, handles)
% hObject    handle to MSIbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
set(handles.cutfilename,'string','');
nimages=length(img);
[filename, directory] =uigetfile('*.jpg;*.jpeg;*.tif;*.tiff', ...
    'Select first file');
if filename==0
    return
end
cd(directory);
str = sprintf('%s%s',directory, filename);
set(handles.cutfilename,'string',str);
img(nimages).image=imread(str);
imagesc(img(nimages).image);


% --- Executes on button press in LRGseparationbtn.
function LRGseparationbtn_Callback(hObject, eventdata, handles)
% hObject    handle to LRGseparationbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LRGseparation;


% --- Executes on button press in Extractlocaltraitbtn.
function Extractlocaltraitbtn_Callback(hObject, eventdata, handles)
% hObject    handle to Extractlocaltraitbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maininterval;
maininterval=str2num(get(handles.zonelenedit,'String'));
Localtraits;


function zonelenedit_Callback(hObject, eventdata, handles)
% hObject    handle to zonelenedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zonelenedit as text
%        str2double(get(hObject,'String')) returns contents of zonelenedit as a double


% --- Executes during object creation, after setting all properties.
function zonelenedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zonelenedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveLRGbtn.
function saveLRGbtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveLRGbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img;
VarNames={'Row' 'Col' 'Zone' 'ImageNum'};
[FileName,PathName] = uiputfile('*.csv');
nimages=length(img);
for  i=1:nimages
    if length(img(i).LRGpoints)~=0
        str=strcat(PathName,'totalarea-',num2str(i),FileName);
        LRGpoints=img(i).LRGpoints;
        [data] = savdata(LRGpoints);
        csvwriteh(str, data, VarNames);
    end
    if length(img(i).basaldiameter)~=0
        str=strcat(PathName,'basalarea-',num2str(i),FileName);
        basaldiameter=img(i).basaldiameter;
        [data] = savdata(basaldiameter);
        csvwriteh(str, data, VarNames);
    end
end


% --- Executes on button press in clearbtn.
function clearbtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.filetemplate,'string','');
set(handles.fileno,'string','');
set(handles.edittop,'string','');
set(handles.editbottom,'string','');
set(handles.editleft,'string','');
set(handles.editright,'string','');
set(handles.Threshedit,'String','');
set(handles.skelradio,'value',0);
set(handles.PriSkelradio,'value',0);
set(handles.Indirootradio,'value',0);
set(handles.BraPtsradio,'value',0);
set(handles.zonelenedit,'String','');
set(handles.cutfilename,'String','');
A=[];
imshow(A);
clc;
clear all;
