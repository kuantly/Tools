function Data = KYHEAD(varargin)

%KYH restituisce la serie storica del campo Field per il Ticker 

cred_str=KYLogin;
%-------------------------------
split_str =char(strsplit(cred_str,',')');
apikey= strtrim(split_str(2,length('apikey=')+1:end));
UrlPath= strtrim(split_str(3,length('address=')+1:end));
%-------------------------------
%% create InputParser
DefApi = apikey;
DefProc= mfilename;
p = inputParser;

%% add parameter
addParameter(p,'field','',@ischar);
addParameter(p,'apikey',DefApi,@ischar);
addParameter(p,'proc',DefProc,@ischar);

parse(p,varargin{:})
%% create request
arg = fieldnames(p.Results);
val = p.Results;

options=weboptions;
options.RequestMethod ='post';
options.Timeout = 60;
DataScan = textscan(webread(UrlPath,arg{1},val.(arg{1}),...
    arg{2},val.(arg{2}),...
    arg{3},val.(arg{3}),...
    options),'%s','Delimiter',',','TreatAsEmpty',{'\N'});

Data(:,1) = strrep(DataScan{:,1},'"','');

end