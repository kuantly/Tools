function [string_out]=KYLogin(username,apikey)
% Create the .kuantly folder
userhome = getuserdir();
kuantly_credentials_folder   = fullfile(userhome,'.kuantly');
kuantly_credentials_file = fullfile(kuantly_credentials_folder, '.credentials');


% get credentials with no arguments
if nargin == 0
    fileIDCred = fopen(kuantly_credentials_file, 'r');
    if(fileIDCred == -1)
        fclose('all');
        %error('kuantly:KYLogin', ...
       %['There was an error reading your credentials file at '...
       % kuantly_credentials_file]);
    end
    creds_string_array = fread(fileIDCred, '*char');
    string_out =  sprintf('%s',creds_string_array);
    fclose('all');
end

if nargin == 2
    if ~exist(kuantly_credentials_folder, 'dir')
    [status, mess, messid] = mkdir(kuantly_credentials_folder);
    end
    fileIDCred = fopen(kuantly_credentials_file, 'w');
    creds_string=['username=',username,',apikey=',apikey,',address=http://apps.kuantly.com/export/get_csv.php'];
    fprintf(fileIDCred,'%s',creds_string);
    fclose(fileIDCred);
    string_out = 'Credentials saved';
end
end