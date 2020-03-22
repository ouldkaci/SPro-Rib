unit ExecWait;

interface

uses
  Classes, Windows, SysUtils, Forms, ShellAPI;

function ExecAppWait(AppName, Params: string): Boolean ;

implementation

{ Execute an external application APPNAME.
  Pass optional parameters in PARAMS, separated by spaces.
  Wait for completion of the application.
  Returns FALSE if the application could not be launched.
}
function ExecAppWait(AppName, Params: string): Boolean;
var
  { Structure containing and receiving info about the application that
    you want to launch }
  ShellExInfo: TShellExecuteInfo;
begin
  { Initialize ShellExInfo }
  FillChar(ShellExInfo, SizeOf(ShellExInfo), 0); // fill with empty values
  with ShellExInfo do begin            // set desired values
    cbSize := SizeOf(ShellExInfo);
    fMask  := see_Mask_NoCloseProcess;
    Wnd    := Application.Handle;
    lpFile := PChar(AppName);
    nShow  := sw_ShowNormal;
    lpParameters := PChar(Params);
  end;

  { If no error, ShellExecuteEx will return TRUE, else FALSE }
  Result := ShellExecuteEx(@ShellExInfo);

  { If no error, wait in this loop until the process ends }
  if Result then
    while WaitForSingleObject(ShellExInfo.HProcess, 100) = WAIT_TIMEOUT do begin
      Application.ProcessMessages; // give processor time to other tasks
      if Application.Terminated then
        Break;
    end;
end;

end.
