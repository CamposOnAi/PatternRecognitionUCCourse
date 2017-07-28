function varargout = pcaChoice(varargin)
% PCACHOICE MATLAB code for pcaChoice.fig
%      PCACHOICE, by itself, creates a new PCACHOICE or raises the existing
%      singleton*.
%
%      H = PCACHOICE returns the handle to a new PCACHOICE or the handle to
%      the existing singleton*.
%
%      PCACHOICE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCACHOICE.M with the given input arguments.
%
%      PCACHOICE('Property','Value',...) creates a new PCACHOICE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcaChoice_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcaChoice_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcaChoice

% Last Modified by GUIDE v2.5 26-Mar-2016 23:00:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcaChoice_OpeningFcn, ...
                   'gui_OutputFcn',  @pcaChoice_OutputFcn, ...
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


% --- Executes just before pcaChoice is made visible.
function pcaChoice_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcaChoice (see VARARGIN)

% Choose default command line output for pcaChoice
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pcaChoice wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcaChoice_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%eigValues must be in base workspace
eigval = evalin('base','eigValues');
total = sum(eigval);
percentage = (100.* eigval)./total;
cumPercentage = percentage(1);
for i=2:length(percentage)
   cumPercentage(i) = cumPercentage(i-1) + percentage(i); 
end

table = horzcat(eigval,percentage);
table = horzcat(table,cumPercentage');
set(hObject,'Data',table);
