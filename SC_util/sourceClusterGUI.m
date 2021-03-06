function varargout = sourceClusterGUI(varargin)
% SOURCECLUSTERGUI MATLAB code for sourceClusterGUI.fig
%      SOURCECLUSTERGUI, by itself, creates a new SOURCECLUSTERGUI or raises the existing
%      singleton*.
%
%      H = SOURCECLUSTERGUI returns the handle to a new SOURCECLUSTERGUI or the handle to
%      the existing singleton*.
%
%      SOURCECLUSTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOURCECLUSTERGUI.M with the given input arguments.
%
%      SOURCECLUSTERGUI('Property','Value',...) creates a new SOURCECLUSTERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sourceClusterGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sourceClusterGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sourceClusterGUI

% Last Modified by GUIDE v2.5 22-Aug-2016 22:44:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sourceClusterGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @sourceClusterGUI_OutputFcn, ...
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


% --- Executes just before sourceClusterGUI is made visible.
function sourceClusterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sourceClusterGUI (see VARARGIN)

% Choose default command line output for sourceClusterGUI
handles.output = hObject;

handles.cellFilters = varargin{1};
if length(varargin) > 1
    nClusters = varargin{2};
else
    nClusters = 4;
end
handles.sO = clusterSourceTypes(handles.cellFilters,nClusters);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sourceClusterGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sourceClusterGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderSet = get(hObject,'Value');
sliderMod = sigmf([-.01 0] + sliderSet,[10 1/2]);
handles.filtIDs = find(handles.theseProbs >= sliderMod(2));
theseFilts = handles.cellFilters(:,handles.filtIDs);
minusFilts = handles.cellFilters(:,handles.theseProbs >= sliderMod(1));
adjIm = repmat(reshape(full(sum(theseFilts,2)),512,512),1,1,3);
adjIm(:,:,2) = reshape(full(sum(minusFilts,2)),512,512);
imshow(adjIm*3,'Parent',handles.axes1),
title(handles.axes1,...
    sprintf('%d Filters Selected at Prob: %0.4f',length(handles.filtIDs),sliderMod(2))),
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
gID = get(hObject,'Value');
handles.theseProbs = handles.sO.gmProbs(:,handles.sO.sigRank(gID));
handles.filtIDs = find(handles.sO.idx == handles.sO.sigRank(gID));
theseFilts = handles.cellFilters(:,handles.filtIDs);
imshow(reshape(full(sum(theseFilts,2)),512,512)*3,'Parent',handles.axes1),
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','guiClusterIDs',handles.filtIDs);