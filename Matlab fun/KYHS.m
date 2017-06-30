function Data = KYHS(varargin)

%KYH restituisce la serie storica del campo Field per il Ticker 

%ValArg = @(x) isnumeric(x) || ischar(x);
cred_str=KYLogin;
%-------------------------------
split_str =char(strsplit(cred_str,',')');
apikey= strtrim(split_str(2,length('apikey=')+1:end));
UrlPath= strtrim(split_str(3,length('address=')+1:end));
%-------------------------------
%% create InputParser
DefApi = apikey;
DefProc= mfilename;
DefStat= 'obs';
p = inputParser;
%addRequired(p,'ticker',@ischar);
%addRequired(p,'field',@ischar);
%% add parameter
addParameter(p,'ticker','',@ischar);
addParameter(p,'field','',@ischar);
addParameter(p,'stat',DefStat,@ischar);
addParameter(p,'apikey',DefApi,@ischar);
addParameter(p,'proc',DefProc,@ischar);

parse(p,varargin{:})
%% create request
arg = fieldnames(p.Results);
val = p.Results;


options=weboptions;
options.RequestMethod ='post';
options.Timeout = 60;

switch val.stat
    case 'obs'
        format='%f';
    case 'rows'
        format='%f';
    case 'unirows'
        format='%f';
    otherwise
        format='%D';
end

DataScan = textscan(webread(UrlPath,arg{1},val.(arg{1}),...
    arg{2},val.(arg{2}),...
    arg{3},val.(arg{3}),...
    arg{4},val.(arg{4}),...
    arg{5},val.(arg{5}),...
    options),format,'Delimiter',',','TreatAsEmpty',{'\N'},'emptyvalue',NaN);

Data(1,1) = DataScan{1,1};

end