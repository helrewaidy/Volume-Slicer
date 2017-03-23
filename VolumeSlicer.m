function varargout = VolumeSlicer(varargin)
% VOLUMESLICER M-file for VolumeSlicer.fig
%      VOLUMESLICER, by itself, creates a new VOLUMESLICER or raises the existing
%      singleton*.
%
%      H = VOLUMESLICER returns the handle to a new VOLUMESLICER or the handle to
%      the existing singleton*.
%
%      VOLUMESLICER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOLUMESLICER.M with the given input arguments.
%
%      VOLUMESLICER('Property','Value',...) creates a new VOLUMESLICER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VolumeSlicer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VolumeSlicer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".%-- 3/19/2017 11:13 AM --%
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Created by: Hossam El-Rewaidy, Harvard University, using GUIDE v2.5 20-Mar-2017 01:50:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VolumeSlicer_OpeningFcn, ...
    'gui_OutputFcn',  @VolumeSlicer_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    try
        gui_mainfcn(gui_State, varargin{:});
    catch
        
    end
end


function AppData = initAppData()
AppData.freezedSlices={};
AppData.corners = [];
AppData.prev_rot = [0 0 0];
AppData.downsamplingRate=4;
AppData.xd=[];
AppData.yd=[];
AppData.zd=[];
AppData.prev_trans=[0 0 0 0];
AppData.vol_center = [];
AppData.IsDicomFiles=0;
AppData.VolShowed=0;

warning off

try
    load('lastPath.mat');
    AppData.volPath=volPath;
catch
    disp('No saved pathes found!')
    AppData.volPath=[];
end

try
    [ AppData.Volume, permutation ] = load_dicom_volume( AppData.volPath);
catch
    try
        AppData.Volume =loadVolume(AppData.volPath);
    catch
        AppData.Volume=[];
    end
end



% --- Executes just before VolumeSlicer is made visible.
function VolumeSlicer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VolumeSlicer (see VARARGIN)

AppData = initAppData();
setappdata(0,'AppData',AppData);
drawSlice(handles,0);
% Choose default command line output for VolumeSlicer
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VolumeSlicer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%%% Add this line to the end of OpeningFcn
% uiwait;




% --- Executes on button press in btnSaveSeries.
function btnSaveSeries_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AppData=getappdata(0,'AppData');
[tx ty tz rx ry rz movInNorm] = getTransformationValues(handles);
defaultDir='';
AppData.save_path = uigetdir(defaultDir, 'Select Dicom Folder');
axes(handles.axes1)
saveSlices(AppData.Volume,AppData.xd,AppData.yd,AppData.zd,AppData.save_path);

AppData.prev_rot = [rx ry rz];
AppData.prev_trans = [tx ty tz movInNorm];
drawSlice(handles,0)

setappdata(0,'AppData',AppData);



% saveSlices(volPath,freezedSlices{1,2},freezedSlices{1,3},freezedSlices{1,4},freezedSlices{1,5},vol_center,vec(1),vec(2),vec(3),0 ,0,0,movInNorm,handles.axes1,handles.axes2,'D:\CT DS\CARDIX\LA_4CH');


% --- Executes on slider movement.
function sldr_rx_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on slider movement.
function sldr_ry_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_ry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on slider movement.
function sldr_rz_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_rz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on slider movement.
function sldr_tx_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on slider movement.
function sldr_ty_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_ty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on slider movement.
function sldr_tz_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_tz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes on button press in btnFreezSlice.
function btnFreezSlice_Callback(hObject, eventdata, handles)
% hObject    handle to btnFreezSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AppData=getappdata(0,'AppData');

[tx ty tz rx ry rz movInNorm] = getTransformationValues(handles);
AppData.freezedSlices{1,1} = [tx ty tz rx ry rz movInNorm];
AppData.freezedSlices{1,2} = AppData.corners;
AppData.freezedSlices{1,3} = AppData.xd;
AppData.freezedSlices{1,4} = AppData.yd;
AppData.freezedSlices{1,5} = AppData.zd;
AppData.freezedSlices{1,6} = AppData.vol_center;
AppData.freezedSlices{1,7} = AppData.prev_rot;
AppData.freezedSlices{1,8} = AppData.prev_trans;


setappdata(0,'AppData',AppData);


% --- Executes on key press with focus on btnFreezSlice and none of its controls.
function btnFreezSlice_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to btnFreezSlice (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in btnShowVol.
function btnShowVol_Callback(hObject, eventdata, handles)
% hObject    handle to btnShowVol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

drawSlice(handles,1)


% --- Executes on slider movement.
function sldrMoveInNorm_Callback(hObject, eventdata, handles)
% hObject    handle to sldrMoveInNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawSlice(handles,0)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


function f=drawFreezedSlices(handles)

AppData=getappdata(0,'AppData');

for i=1:size(AppData.freezedSlices,1)
    vec=AppData.freezedSlices{i,1};
    
    if~(isempty(AppData.Volume) || size(AppData.Volume,1)==0 || size(AppData.Volume,2)==0 || size(AppData.Volume,3)==0)
        axes(handles.axes1)
        try, delete(AppData.fsurfh); catch, end
        hold on
        [AppData.fsurfh ] = getslice3(AppData.Volume,AppData.freezedSlices{i,2},AppData.freezedSlices{i,3}, AppData.freezedSlices{i,4},AppData.freezedSlices{i,5},AppData.freezedSlices{i,6});
        
        if(AppData.VolShowed)
            axes(handles.axes2)
            try, delete(AppData.fvolSurf); catch, end
            hold on
            
            AppData.fvolSurf = surface('XData',AppData.freezedSlices{i,3}./AppData.downsamplingRate,'YData',AppData.freezedSlices{i,4}./AppData.downsamplingRate,'ZData',AppData.freezedSlices{i,5}./AppData.downsamplingRate,'FaceColor',[0 1 0]);
            AppData.fvolSurf.EdgeColor = [0.1 0.2 0.6];
            
        end
        
    else
        disp(['Invalid volume!'])
    end
    
    
end
setappdata(0,'AppData',AppData);



function f = drawSlice(handles,showVol)

AppData=getappdata(0,'AppData');

% showVol=0;
[tx ty tz rx ry rz movInNorm] = getTransformationValues(handles);
set(handles.edt_tx,'String',num2str(tx));
set(handles.edt_ty,'String',num2str(ty));
set(handles.edt_tz,'String',num2str(tz));
set(handles.edt_rx,'String',num2str(rx));
set(handles.edt_ry,'String',num2str(ry));
set(handles.edt_rz,'String',num2str(rz));
set(handles.edt_mn,'String',num2str(movInNorm));
% volPath = get(handles.edtVolPath,'String');


if~(isempty(AppData.Volume) || size(AppData.Volume,1)==0 || size(AppData.Volume,2)==0 || size(AppData.Volume,3)==0)
    axes(handles.axes1)
    
    %     try, delete(AppData.surfh); catch, end
    hold off
    [AppData.surfh AppData.xd AppData.yd AppData.zd AppData.corners AppData.vol_center] = getslice3(AppData.Volume,AppData.corners,...
        AppData.xd, AppData.yd,AppData.zd,AppData.vol_center,tx-AppData.prev_trans(1),ty-AppData.prev_trans(2),...
        tz-AppData.prev_trans(3),rx-AppData.prev_rot(1),ry-AppData.prev_rot(2),rz-AppData.prev_rot(3),movInNorm-AppData.prev_trans(4));
    
    if(showVol)
        AppData.VolShowed=1;
        axes(handles.axes2)
        try, set(axes2, 'renderer', 'opengl'); catch, end
        set(handles.txtWait,'String','Please, wait for volume visualization!')
        pause(0.01)
        visualizeVolume(AppData.Volume,AppData.downsamplingRate);
        set(handles.txtWait,'String','')
        view(3)
        pause(0.01)
    end
    
    if(AppData.VolShowed)
        axes(handles.axes2)
        hold on
        try, delete(AppData.volSurf); catch, end
        
        AppData.volSurf = surface('XData',AppData.xd./AppData.downsamplingRate,'YData',AppData.yd./AppData.downsamplingRate,'ZData',AppData.zd./AppData.downsamplingRate,'FaceColor',[0 1 0]);
        AppData.volSurf.EdgeColor = [0.1 0.9 0.2];
        
    end
    
else
    disp(['Invalid volume!'])
end
AppData.prev_rot = [rx ry rz];
AppData.prev_trans = [tx ty tz movInNorm];
setappdata(0,'AppData',AppData);

drawFreezedSlices(handles)



function [tx ty tz rx ry rz movInNorm] = getTransformationValues(handles)

rx=(get(handles.sldr_rx,'value')-0.5)*360;

ry=(get(handles.sldr_ry,'value')-0.5)*360;

rz=(get(handles.sldr_rz,'value')-0.5)*360;

tx=(get(handles.sldr_tx,'value')-0.5)*600;

ty=(get(handles.sldr_ty,'value')-0.5)*600;

tz=(get(handles.sldr_tz,'value')-0.5)*600;

movInNorm=(get(handles.sldrMoveInNorm,'value')-0.5)*500;


% --- Executes on button press in btnRealVolSlice.
function btnRealVolSlice_Callback(hObject, eventdata, handles)
% hObject    handle to btnRealVolSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AppData=getappdata(0,'AppData');
AppData.downsamplingRate = 1;
drawSlice(handles,0)
setappdata(0,'AppData','AppData');


% --- Executes on button press in btnExchangeSlices.
function btnExchangeSlices_Callback(hObject, eventdata, handles)
% hObject    handle to btnExchangeSlices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AppData=getappdata(0,'AppData');

tmp = AppData.corners;
tmp_xd = AppData.xd;
tmp_yd = AppData.yd;
tmp_zd = AppData.zd;
tmp_vol_center = AppData.vol_center;
tmp_prev_rot = AppData.prev_rot;
tmp_prev_trans = AppData.prev_trans;
try, delete(AppData.volSurf); catch, end
try, delete(AppData.fvolSurf); catch, end

% tmp_volSurf = AppData.volSurf;
%
%
% AppData.volSurf=AppData.fvolSurf;
% AppData.fvolSurf = tmp_volSurf;

vec = AppData.freezedSlices{1,1};
AppData.corners=AppData.freezedSlices{1,2};
AppData.xd = AppData.freezedSlices{1,3};
AppData.yd = AppData.freezedSlices{1,4};
AppData.zd = AppData.freezedSlices{1,5};
AppData.vol_center = AppData.freezedSlices{1,6};
AppData.prev_rot = AppData.freezedSlices{1,7};
AppData.prev_trans = AppData.freezedSlices{1,8};

AppData.freezedSlices{1,2}=tmp;
AppData.freezedSlices{1,3}=tmp_xd;
AppData.freezedSlices{1,4}=tmp_yd;
AppData.freezedSlices{1,5}=tmp_zd;
AppData.freezedSlices{1,6} = tmp_vol_center;
AppData.freezedSlices{1,7} = tmp_prev_rot;
AppData.freezedSlices{1,8} = tmp_prev_trans;

[tx ty tz rx ry rz movInNorm] = getTransformationValues(handles)
AppData.freezedSlices{1,1} = [tx ty tz rx ry rz movInNorm];

set(handles.edt_tx,'String',num2str(vec(1)));
set(handles.sldr_tx,'value',vec(1)/600+.5);

set(handles.edt_ty,'String',num2str(vec(2)));
set(handles.sldr_ty,'value',vec(2)/600+.5);

set(handles.edt_tz,'String',num2str(vec(3)));
set(handles.sldr_tz,'value',vec(3)/600+.5);

set(handles.edt_rx,'String',num2str(vec(4)));
set(handles.sldr_rx,'value',vec(4)/360+.5);

set(handles.edt_ry,'String',num2str(vec(5)));
set(handles.sldr_ry,'value',vec(5)/360+.5);

set(handles.edt_rz,'String',num2str(vec(6)));
set(handles.sldr_rz,'value',vec(6)/360+.5);

set(handles.edt_mn,'String',num2str(vec(7)));
set(handles.sldrMoveInNorm,'value',vec(7)/500+.5);
setappdata(0,'AppData',AppData);
drawSlice(handles,0)


function edt_mn_Callback(hObject, eventdata, handles)
% hObject    handle to edt_mn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_mn as text
%        str2double(get(hObject,'String')) returns contents of edt_mn as a double
mn=get(handles.edt_mn,'String');
set(handles.sldrMoveInNorm,'value',str2num(mn)/500+.5);
drawSlice(handles,0)


function edt_rx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_rx as text
%        str2double(get(hObject,'String')) returns contents of edt_rx as a double
rx=get(handles.edt_rx,'String');
set(handles.sldr_rx,'value',str2num(rx)/360+.5);
drawSlice(handles,0)

function edt_ry_Callback(hObject, eventdata, handles)
% hObject    handle to edt_ry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_ry as text
%        str2double(get(hObject,'String')) returns contents of edt_ry as a double
ry=get(handles.edt_ry,'String');
set(handles.sldr_ry,'value',str2num(ry)/360+.5);
drawSlice(handles,0)


function edt_rz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_rz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_rz as text
%        str2double(get(hObject,'String')) returns contents of edt_rz as a double
rz=get(handles.edt_rz,'String');
set(handles.sldr_rz,'value',str2num(rz)/360+.5);
drawSlice(handles,0)



function edt_tx_Callback(hObject, eventdata, handles)
% hObject    handle to edt_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_tx as text
%        str2double(get(hObject,'String')) returns contents of edt_tx as a double
tx=get(handles.edt_tx,'String');
set(handles.sldr_tx,'value',str2num(tx)/300+.5);
drawSlice(handles,0)


function edt_ty_Callback(hObject, eventdata, handles)
% hObject    handle to edt_ty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_ty as text
%        str2double(get(hObject,'String')) returns contents of edt_ty as a double
ty=get(handles.edt_ty,'String');
set(handles.sldr_ty,'value',str2num(ty)/300+.5);
drawSlice(handles,0)

function edt_tz_Callback(hObject, eventdata, handles)
% hObject    handle to edt_tz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edt_tz as text
%        str2double(get(hObject,'String')) returns contents of edt_tz as a double
tz=get(handles.edt_tz,'String');
set(handles.sldr_tz,'value',str2num(tz)/300+.5);
drawSlice(handles,0)



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popup_path.
function popup_path_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popup_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on key press with focus on popup_path and none of its controls.
function popup_path_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popup_path (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in btn_dicom_path.
function btn_dicom_path_Callback(hObject, eventdata, handles)
% hObject    handle to btn_dicom_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AppData=getappdata(0,'AppData');
defaultDir='';
if~(isempty(AppData.volPath))
    defaultDir=AppData.volPath;
end
AppData.volPath = uigetdir(defaultDir, 'Select Dicom Folder');
save('lastPath.mat','volPath');

AppData.IsDicomFiles = 1;

setappdata(0,'AppData',AppData);
initAppData()

% --- Executes on button press in btn_mat_select.
function btn_mat_select_Callback(hObject, eventdata, handles)
% hObject    handle to btn_mat_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

AppData=getappdata(0,'AppData');
defaultDir='';
if~(isempty(AppData.volPath))    defaultDir=AppData.volPath; end

[filename, AppData.volPath] = uigetfile('*.mat', 'Select the Mat Volume File',defaultDir);

if isequal(filename,0)
    disp('User selected Cancel')
else
    disp(['User selected ', fullfile(AppData.volPath, filename)])
end
AppData.volPath = fullfile(AppData.volPath, filename);
% AppData.Volume =loadVolume(AppData.volPath);
volPath = AppData.volPath;
save('lastPath.mat','volPath');
AppData.IsDicomFiles = 0;

setappdata(0,'AppData',AppData);
initAppData()


function Volume =loadVolume(volPath)

vol=load(volPath);

% Get the field names of the structure.
fields = fieldnames(vol, '-full');
commandLine = sprintf('Volume = vol.%s;', fields{1});
eval(commandLine);
clear vol commandLine fields;
if(size(Volume,1)<=0 || size(Volume,2)<=0 || size(Volume,3)<=0)
    disp('Invalid volume!')
    Volume = [];
end



function edtDownsamplingRate_Callback(hObject, eventdata, handles)
% hObject    handle to edtDownsamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDownsamplingRate as text
%        str2double(get(hObject,'String')) returns contents of edtDownsamplingRate as a double
AppData=getappdata(0,'AppData');
AppData.downsamplingRate = str2num(handles.edtDownsamplingRate.String);
setappdata(0,'AppData',AppData);

% --- Executes during object creation, after setting all properties.
function edtDownsamplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDownsamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
