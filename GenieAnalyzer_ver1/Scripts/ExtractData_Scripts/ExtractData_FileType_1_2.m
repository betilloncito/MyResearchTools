function varargout = ExtractData_FileType_1_2(filename,path,fileType)
NowDir = cd;
cd(path);

Data = importdata(filename);
cd(NowDir);

if(fileType==2)% edit code so the headers are extracted automatically from file
    header = [{'Freq(Hz)'} {'Gain(dB)'}];
else
    header = Data.textdata;
end

varargout = {Data,header};