function varargout = ExtractData_FileType_1_3(filename,path,fileType)
NowDir = cd;
cd(path);

Data = importdata(filename);
cd(NowDir);

if(fileType==3)
    header = 'Freq(Hz) Gain(dB)';
else
    header = Data.textdata;
end

varargout = {Data,header};