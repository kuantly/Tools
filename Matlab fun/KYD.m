function Data = KYD(varargin)


ValArg = @(x) isnumeric(x) || ischar(x);
%ValArg = @(x) isnumeric(x) || ischar(x);
cred_str=KYLogin;

%-------------------------------
split_str =char(strsplit(cred_str,',')');
apikey= strtrim(split_str(2,length('apikey=')+1:end));
UrlPath= strtrim(split_str(3,length('address=')+1:end));
%apikey=cred_str(pos_api+length('apikey='):pos_url);
%-------------------------------
%% create InputParser
DefApi = apikey;
DefProc= mfilename;

p = inputParser;

%% add parameter
addParameter(p,'ticker','',@ischar);
addParameter(p,'field','',@ischar);
addParameter(p,'startdt','',ValArg);
addParameter(p,'outccy','',@ischar);
addParameter(p,'adjust','',@ischar);
addParameter(p,'apikey',DefApi,@ischar);
addParameter(p,'proc',DefProc,@ischar);

parse(p,varargin{:})
%% create request
arg = fieldnames(p.Results);
val = p.Results;
if isnumeric(val.startdt); val.startdt = datestr(val.startdt,'yyyy-mm-dd');end;

%UrlPath ='http://93.51.156.93/kweb/tools/export_csv_all_test.php';
%UrlPath=cred_str(strfind(cred_str,'address=')+length('address='):end);
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
    options),'%q','Delimiter',',','TreatAsEmpty',{'\N'},'emptyvalue',NaN);

Data(1,1) = strrep(DataScan{1,1},'\N','N/D');

end