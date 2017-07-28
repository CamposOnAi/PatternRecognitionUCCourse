%Credits to  Star Strider from 
%http://www.mathworks.com/matlabcentral/answers/140773-how-to-access-all-m-files-in-different-subfolders
MyPath = userpath;
MyDir = MyPath(1:strfind(MyPath,';')-1);
MyWorkDir = genpath(MyDir);
addpath(MyWorkDir, '-end');