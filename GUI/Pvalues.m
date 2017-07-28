function varargout = Pvalues(varargin)
% PVALUES MATLAB code for Pvalues.fig
%      PVALUES, by itself, creates a new PVALUES or raises the existing
%      singleton*.
%
%      H = PVALUES returns the handle to a new PVALUES or the handle to
%      the existing singleton*.
%
%      PVALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PVALUES.M with the given input arguments.
%
%      PVALUES('Property','Value',...) creates a new PVALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pvalues_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pvalues_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pvalues

% Last Modified by GUIDE v2.5 18-Apr-2016 04:12:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pvalues_OpeningFcn, ...
                   'gui_OutputFcn',  @Pvalues_OutputFcn, ...
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


% --- Executes just before Pvalues is made visible.
function Pvalues_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pvalues (see VARARGIN)

% Choose default command line output for Pvalues
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Pvalues wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pvalues_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
data = evalin('base','data');
target = evalin('base','target');


p = Kruscal(data, target);

set(hObject,'Data',p');
