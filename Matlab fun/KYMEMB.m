function Data = KYMEMB(varargin)

%KYH restituisce la serie storica del campo Field per il Ticker 

%ValArg = @(x) isnumeric(x) || ischar(x);
%flds e source da fare
ValideField=[{'ticker'};{'subindex'};{'provider'};{'flds'};{'source'}];
ValArg = @(x) ismember(x,ValideField);
cred_str=KYLogin;
%-------------------------------
split_str =char(strsplit(cred_str,',')');
apikey= strtrim(split_str(2,length('apikey=')+1:end));
UrlPath= strtrim(split_str(3,length('address=')+1:end));
%-------------------------------
%% create InputParser
DefApi = apikey;
DefProc= mfilename;
DefField= 'ticker';
p = inputParser;
%% check varargin
addParameter(p,'userlist','',@ischar);
addParameter(p,'field',DefField,ValArg);
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
    arg{4},val.(arg{4}),...
    options),'%q %q %q %q','Delimiter',',','TreatAsEmpty',{'\N'});
switch val.field
    case 'ticker'
        Data(:,1) = strrep(DataScan{:,1},'\N','N/D');
    case 'subindex'
        Data(:,1) = strrep(DataScan{:,3},'\N','N/D');
    case 'provider'
        Data(:,1) = strrep(DataScan{:,4},'\N','N/D');
        case 'flds'
        Data(:,1) = 'Only in future release'
    case 'source'
        Data(:,1) = 'Only in future release'
    otherwise
        msg ='ncol argument out of range';
        error(msg)
end



%Data = DataScan{:,:};

end


