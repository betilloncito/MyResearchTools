function varargout = ExtractData_FileType_1_2(filename,path,fileType)
NowDir = cd;
cd(path);

Data = importdata(filename);
cd(NowDir);

if(fileType==3)% edit code so the headers are extracted automatically from file
%     header = [{'Freq(Hz)'} {'Gain(dB)'}];
    header = Data.colheaders;

elseif(fileType==2)% edit code so the headers are extracted automatically from file
    header = [{'Freq(Hz)'} {'Gain(dB)'}];
else
    header = Data.textdata;
end

%header should be a cell array
%Data should be a structure that should at least have the field Data.data
varargout = {Data,header};