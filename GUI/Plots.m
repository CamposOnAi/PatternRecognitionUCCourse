function varargout = Plots(varargin)
% PLOTS MATLAB code for Plots.fig
%      PLOTS, by itself, creates a new PLOTS or raises the existing
%      singleton*.
%
%      H = PLOTS returns the handle to a new PLOTS or the handle to
%      the existing singleton*.
%
%      PLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTS.M with the given input arguments.
%
%      PLOTS('Property','Value',...) creates a new PLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plots

% Last Modified by GUIDE v2.5 11-Apr-2016 00:26:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plots_OpeningFcn, ...
                   'gui_OutputFcn',  @Plots_OutputFcn, ...
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


% --- Executes just before Plots is made visible.
function Plots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plots (see VARARGIN)

% Choose default command line output for Plots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

rawdata = evalin('base','rawData');
new_Data = standardization(sort(rawdata));
axes(handles.axes1);
boxplot(new_Data);

axes(handles.axes2);
Covariance = cov(new_Data);
imagesc(Covariance);
%colormap('hsv');
colorbar;
% UIWAIT makes Plots wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = get(handles.listbox1,'Value');
if value ==1
    types = 'single';
elseif value == 2
    types = 'complete';
elseif value == 3
    types = 'average';
elseif value == 4
    types = 'weighted';
elseif value == 5
    types = 'centroid';
elseif value == 6
    types = 'median';
else
    types = 'ward';
end

axes(handles.axes3);
rawData = evalin('base','rawData');
l = linkage(rawData', types);
dendrogram(l);
