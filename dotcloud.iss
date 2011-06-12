[Setup]
AppName=DotCloud for Windows
AppVersion=0.3.1
OutputBaseFilename=dotcloud-0.3.1
OutputDir=setup
DefaultDirName={pf}\DotCloud
ChangesEnvironment=yes

[Tasks]
Name: modifypath; Description: "Add DotCloud's path to path environment variable (recommended)";

[Files]
Source: "bin\*"; DestDir: "{app}"; Flags: recursesubdirs;

[Dirs]
Name: "{code:UserDir}\.dotcloud"

[UninstallDelete]
Type: filesandordirs; Name: "{code:UserDir}\.dotcloud"

[Code]
function UserDir(Param: String): String;
begin
  Result := GetEnv('USERPROFILE');
end;

var
  apiKeyPage: TInputQueryWizardPage;

procedure InitializeWizard;
begin
  apiKeyPage := CreateInputQueryPage(wpSelectTasks,
    'DotCloud API Key',
    'You can find it at http://www.dotcloud.com/account/settings',
    'Optionally you can specify your DotCloud API Key (not required)');
  apiKeyPage.Add('API Key:', False);
end;

function NextButtonClick(CurrentPageID: Integer) : Boolean;
var
  ResultCode: Integer;
  DotCloudConfPath: String;
begin
  Result := True;
  if CurrentPageID = wpFinished then
  begin
    if apiKeyPage.Values[0] <> '' then
    begin
      DotCloudConfPath := UserDir('') + '\.dotcloud\' + 'dotcloud.conf';
      SaveStringToFile(DotCloudConfPath, '{' + #13#10, false);
      SaveStringToFile(DotCloudConfPath, '    "url": "https://api.dotcloud.com/", ' + #13#10, true);
      SaveStringToFile(DotCloudConfPath, '    "apikey": "'+ apiKeyPage.Values[0] +'"' + #13#10, true);
      SaveStringToFile(DotCloudConfPath, '}', true);
    end;
  end;
end;

function ModPathDir(): TArrayOfString;
var
  Dir:	TArrayOfString;
begin
  setArrayLength(Dir, 1)
  Dir[0] := ExpandConstant('{app}');
  Result := Dir;
end;

#include "modpath.iss"
