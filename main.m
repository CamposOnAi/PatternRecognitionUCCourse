function varargout = main(varargin)
% Kruskal Wallis no dataset raw
% Grafico de co variancia entre features
% Opcao para percentagem de train/validation/test

% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 25-May-2016 17:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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
%clear
startup;

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = evalin('base','data');
target = evalin('base','target');

distance = get(handles.popupmenu2,'Value');

% No feature scaling or scale after PCA 
if get(handles.radiobutton5,'Value') == 1 %Scale after PCA
    scaleOption = get(handles.listbox1,'Value');
    data = scaleData(data,scaleOption);
    fillWorkspace(data,'scaledData');
elseif get(handles.radiobutton6,'Value') == 1% No scaling
    fillWorkspace(data,'scaledData');
end %endIf
%Feature Reduction on scaled data
finalDimChar = get(handles.edit1,'String');
finalDim = str2double(finalDimChar);
if get(handles.radiobutton2,'Value') == 1 %Apply PCA
    [reducedData,~,~] = myPCA(data,finalDim);
elseif get(handles.radiobutton3,'Value') == 1 %Apply LDA
    [reducedData,~] = lda([target data],0:size(data,2)-1,finalDim);
else
    reducedData = data;
end

% É PRECISO MEXER DAQUI PARA BAIXO, inserir else if e classificadores
indexSelected = get(handles.listbox4,'Value');

if indexSelected == 1 %Min Dist Classifier
    percTrain = get(handles.edit4,'String');
    percTrain= str2num(percTrain);
    percTest = get(handles.edit5,'String');
    percTest= str2num(percTest);
    valRatio = 0;

    [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);
    minDistClass(trainSet,trainTarget,testSet,testTarget,distance,true);
    
elseif  indexSelected == 2 %Bayes Classifier
    percTrain = get(handles.edit4,'String');
    percTrain= str2num(percTrain);
    percTest = get(handles.edit5,'String');
    percTest= str2num(percTest);

    valRatio = 0;

    [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);

    perct = nayveBayes(trainSet,trainTarget,testSet,testTarget,true);
    
    set(handles.text21,'String',strcat('Accuracy: ',num2str(perct)));
        
elseif indexSelected == 3 % KNN
    percTrain = get(handles.edit4,'String');
    percTrain= str2num(percTrain);
    percTest = get(handles.edit5,'String');
    percTest= str2num(percTest);

    valRatio = 0;

    [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);
    
    neighborChar = get(handles.edit1,'String');
    neighbor = str2double(neighborChar);
    [trainedClassifier, validationAccuracy,perct] = kNearN([trainSet trainTarget],testSet,testTarget,neighbor,true);
    set(handles.text21,'String',strcat('Accuracy: ',num2str(perct)));
    
elseif indexSelected == 4 % SVM
    percTrain = get(handles.edit4,'String');
    percTrain= str2num(percTrain);
    percTest = get(handles.edit5,'String');
    percTest= str2num(percTest);

    valRatio = 0;

    [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);

    [trainedClassifier, validationAccuracy,perct] = linearSVM([trainSet trainTarget],testSet,testTarget,true);
    set(handles.text21,'String',strcat('Accuracy: ',num2str(perct)));
    
end %EndIF


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


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
data = evalin('base','rawData');
indexes = get(hObject,'Value');
fillWorkspace(data(:,indexes),'data');

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%FROM: http://www.mathworks.com/matlabcentral/answers/19529-how-to-pass-arrays-to-and-from-a-gui
%x=evalin('base','X');
%where x is my variable in GUI, 'base' assumes WorkSpace and X is a variable that will be read from workspace to the GUI. Similarly, you can pass the variable to the workspace:

%assignin('base', 'X', x)
%where x is the GUI variable and X is a future variable in workspace.
%features = ['a';'b';'c'];    
%TODO: Dynamically populate this with names from excel
%    set(hObject,'String',cellstr(features));
%    set(hObject,'Max', length(features));

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');    
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
data = evalin('base','data');
if get(hObject,'Value') == 1 %PCA
    if get(handles.radiobutton4,'Value') == 1 %Scale before
        %Get scaling option
        scaleOption = get(handles.listbox1,'Value');
        data = scaleData(data,scaleOption);
        fillWorkspace(data,'scaledData');
    end %endIf
    %Do Kaiser criteria analysis
    fillWorkspace(eigenAnalysis(data),'eigValues');
    pcaChoice;
end

% --- Executes during object creation, after setting all properties.
function radiobutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',0);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
acceptedFileTypes = {'*.xls';'*.mat'};
[file,directory ] = uigetfile(acceptedFileTypes,'Select the MATLAB code file');
fullpath = [directory file];
if file ~= 0 % a value of 0 means the user cancelled the menu
    set(handles.text8,'String',file);
    %Reading dataset and grabbing features
    [data,features,target] = readDataset(fullpath);
    %Fill list box
    set(handles.listbox2,'String',features);
    set(handles.listbox2,'Max',length(features));%Allow multiple selection
    
    fillWorkspace(data,'data');    
    fillWorkspace(data,'rawData');
    fillWorkspace(target,'target');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
value = get(hObject,'Value');
rawData = evalin('base','rawData');
if value == 1
    fillWorkspace(rawData,'data');
end


% --- Executes during object creation, after setting all properties.
function radiobutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Value',0);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plots;
%h = get(Plots.handles,'axes1');
%set(box,'Parent', axes1);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pvalues;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data = evalin('base','rawData');
target = evalin('base','target');
tresh = get(handles.edit6,'String');
tresh= str2num(tresh);
clusters = 20;
ind = Automize(data, target,tresh, clusters);
set(handles.listbox2,'Value',ind);
fillWorkspace(data(1:end,ind),'data');



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


data = evalin('base','data');
target = evalin('base','target');

distance = get(handles.popupmenu2,'Value');

% No feature scaling or scale after PCA 
if get(handles.radiobutton5,'Value') == 1 %Scale after PCA
    scaleOption = get(handles.listbox1,'Value');
    data = scaleData(data,scaleOption);
    fillWorkspace(data,'scaledData');
elseif get(handles.radiobutton6,'Value') == 1% No scaling
    fillWorkspace(data,'scaledData');
end %endIf
%Feature Reduction on scaled data
finalDimChar = get(handles.edit1,'String');
finalDim = str2double(finalDimChar);
if get(handles.radiobutton2,'Value') == 1 %Apply PCA
    [reducedData,~,~] = myPCA(data,finalDim);
elseif get(handles.radiobutton3,'Value') == 1 %Apply LDA
    [reducedData,~] = lda([target data],0:size(data,2)-1,finalDim);
else
    reducedData = data;
end

percTrain = get(handles.edit4,'String');
percTrain= str2num(percTrain);
percTest = get(handles.edit5,'String');
percTest= str2num(percTest);

index_selected = get(handles.listbox4,'Value');
if index_selected == 1

    for i =1:30
        valRatio = 0;

        [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);

        [a{i},b{i}] = minDistClass(trainSet,trainTarget,testSet,testTarget,distance,false);
    end

    allC = [];
    c = 0;
    for i=1:30
        [conf,~,~,~] = confusion(a{i},b{i});
        allC = [allC (1-conf)];
        c = c + (1-conf); 
    end
    c = c/30;

    if max(allC) - min(allC) > 0.15
       fprintf('Max: %2f, min: %2f, mode: %2f\n',max(allC),min(allC),allC(15));
    end
elseif index_selected == 2
    c = 0;
    for i =1:30
        valRatio = 0;

        [trainSet,testSet,trainTarget,testTarget] = trainValidateTest(reducedData,target, percTrain, percTest, valRatio);

        c = c + nayveBayes(trainSet,trainTarget,testSet,testTarget,false);
    end
    c=c/30;
end
fprintf('Avg accuracy: %2f\n',c);


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4
indexSelected = get(handles.listbox4,'Value');
if indexSelected == 1
    set(handles.popupmenu2,'Visible','on');
    set(handles.edit7,'Visible','off');
    set(handles.pushbutton7,'Visible','on');
    set(handles.text21,'Visible','off');
    
elseif indexSelected == 3
    set(handles.edit7,'Visible','on');
    set(handles.popupmenu2,'Visible','off');    
    set(handles.pushbutton7,'Visible','off');
    set(handles.text21,'Visible','on');
else
    set(handles.popupmenu2,'Visible','off');    
    set(handles.pushbutton7,'Visible','off');
    set(handles.text21,'Visible','on');
    set(handles.edit7,'Visible','off');
end %EndIF





% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Visible','off');



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'Visible','off');


% --- Executes during object creation, after setting all properties.
function text21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'Visible','off');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('report.pdf');
