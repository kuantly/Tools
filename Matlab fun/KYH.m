function Data = KYH(varargin)

%KYH restituisce la serie storica del campo Field per il Ticker 

ValArg = @(x) isnumeric(x) || ischar(x);
cred_str=KYLogin;
%-------------------------------
split_str =char(strsplit(cred_str,',')');
apikey= strtrim(split_str(2,length('apikey=')+1:end));
UrlPath= strtrim(split_str(3,length('address=')+1:end));
%-------------------------------
%% create InputParser
DefApi = apikey;
DefProc= mfilename;
DefNcol = '2';
p = inputParser;
%addRequired(p,'ticker',@ischar);
%addRequired(p,'field',@ischar);
%% check varargin

addParameter(p,'ticker','',@ischar);
addParameter(p,'field','',@ischar);
addParameter(p,'startdt','',ValArg);
addParameter(p,'enddt','',ValArg);
addParameter(p,'adjust','',@ischar);
addParameter(p,'outccy','',@ischar);
addParameter(p,'caltype','',@ischar)
addParameter(p,'ncol',DefNcol,ValArg);
addParameter(p,'apikey',DefApi,@ischar);
addParameter(p,'proc',DefProc,@ischar);

parse(p,varargin{:})
%% create request
arg = fieldnames(p.Results);
val = p.Results;
if isnumeric(val.ncol); val.ncol = num2str(val.ncol); end;
if isnumeric(val.startdt); val.startdt = datestr(val.startdt,'yyyy-mm-dd');end;
if isnumeric(val.enddt); val.enddt = datestr(val.enddt,'yyyy-mm-dd');end;


options=weboptions;
options.RequestMethod ='post';
options.Timeout = 60;
DataScan = textscan(webread(UrlPath,arg{1},val.(arg{1}),...
    arg{2},val.(arg{2}),...
    arg{3},val.(arg{3}),...
    arg{4},val.(arg{4}),...
    arg{5},val.(arg{5}),...
    arg{6},val.(arg{6}),...
    arg{7},val.(arg{7}),...
    arg{8},val.(arg{8}),...
    arg{9},val.(arg{9}),...
    arg{10},val.(arg{10}),...
    options),'%D %n','Delimiter',',','TreatAsEmpty',{'\N'});
switch val.ncol
    case '0'
        Data(:,1) = datenum(DataScan{:,1});
    case '1'
        Data(:,1) = DataScan{:,2};
    case '2'
        Data(:,1) = datenum(DataScan{:,1});
        Data(:,2) = DataScan{:,2};
    otherwise
        msg ='ncol argument out of range';
        error(msg)
end

end


