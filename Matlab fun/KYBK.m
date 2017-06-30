function [Header,Data] = KYBK(varargin)
% Updated MAY2017
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
p = inputParser;
%% check varargin
addParameter(p,'ticker','',@ischar);
addParameter(p,'field','',@ischar);
addParameter(p,'startdt','',ValArg);
addParameter(p,'enddt','',ValArg);
addParameter(p,'clause','',@ischar);
addParameter(p,'apikey',DefApi,@ischar);
addParameter(p,'proc',DefProc,@ischar);

parse(p,varargin{:})


%% create request
arg = fieldnames(p.Results);
val = p.Results;
if isnumeric(val.startdt); val.startdt = num2str(val.startdt);end;
if isnumeric(val.enddt); val.startdt = num2str(val.enddt);end;

Header=KYHEAD('field',val.field);
if strcmp(val.field,'holdings') || strcmp(val.field,'MSHOLDING') || strcmp(val.field,'K/holdings')
    textcol=['%D%q%q%q%n'];
end


options=weboptions;
options.RequestMethod ='post';
options.Timeout = 60;

DataScan = textscan(webread(UrlPath,...
    arg{1},val.(arg{1}),...
    arg{2},val.(arg{2}),...
    arg{3},val.(arg{3}),...
    arg{4},val.(arg{4}),...
    arg{5},val.(arg{5}),...
    arg{6},val.(arg{6}),...
    arg{7},val.(arg{7}),...
    options),textcol,'Delimiter',',','TreatAsEmpty',{'\N','"\N"'});


if strcmp(val.field,'holdings') || strcmp(val.field,'MSHOLDING') || strcmp(val.field,'K/holdings')
    Data=table([DataScan{:,1}],[strrep(DataScan{:,2},'\N','N/D')],...
        [strrep(DataScan{:,3},'\N','N/D')],[strrep(DataScan{:,4},'\N','N/D')],[DataScan{:,5}]...
        ,'VariableNames',Header);
    %DataTable(:,1) = datenum(DataScan{:,1});
    %Data(:,2) = strrep(DataScan{:,2},'\N','');
    %Data(:,3) = strrep(DataScan{:,3},'\N','');
    %Data(:,4) = strrep(DataScan{:,4},'\N','');
    %Data(:,5) = DataScan{:,5};
end
%table([5;6;5],['M';'M';'M'],...
%    'VariableNames',{'Age' 'Gender'},...
%    'RowNames',{'Thomas' 'Gordon' 'Percy'})
end


