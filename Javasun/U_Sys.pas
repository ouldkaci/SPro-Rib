Unit U_Sys;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Registry, TlHelp32,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IniFiles, Shellapi, Shlobj;

Type
  Tu_unit = Class(TStrings)
  Protected

  Private
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Function IsAppInRun(RunName: String): Boolean;
Procedure DelAppFromRun(RunName: String);
Procedure DoAppToRun(RunName, AppName: String);
Function GetSpecialFolderPath(CSIDLFolder: Integer): String;
Function DelteDirectory(SDir: String): Boolean;
Function ProcessExists(ExeFileName: String): Boolean;
Function ExeRunning(NomApplication: String; StopProcess: Boolean): Boolean;

Var
  IniDir: String;
  Inific: TIniFile;
  Javasundir: String;
  Adobe_u: String;

Implementation

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

// Check if the application is in the registry...
Function IsAppInRun(RunName: String): Boolean;
Var
  Reg: TRegistry;
Begin
  Reg := TRegistry.Create;
  With Reg Do
  Begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    Result := ValueExists(RunName);
    CloseKey;
    Free;
  End;
End; { _______________________________________________________________________ }

// Remove the application from the registry...
Procedure DelAppFromRun(RunName: String);
Var
  Reg: TRegistry;
Begin
  Reg := TRegistry.Create;
  With Reg Do
  Begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    If ValueExists(RunName)
    Then DeleteValue(RunName);
    CloseKey;
    Free;
  End;
End; { _______________________________________________________________________ }

// Applications under the key "Run" will be executed
// each time the user logs on.
// Add the application to the registry...
Procedure DoAppToRun(RunName, AppName: String);
Var
  Reg: TRegistry;
Begin
  Reg := TRegistry.Create;
  With Reg Do
  Begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    WriteString(RunName, AppName);
    CloseKey;
    Free;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function GetSpecialFolderPath(CSIDLFolder: Integer): String;
Var
  FilePath: Array [0 .. MAX_PATH] Of Char;
Begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, FilePath);
  Result := FilePath;
End; { _______________________________________________________________________ }

Function DelteDirectory(SDir: String): Boolean;
Var
  IIndex: Integer;
  SearchRec: TSearchRec;
  SFileName: String;
Begin
  SDir := SDir + '\*.*';
  IIndex := FindFirst(SDir, FaAnyFile, SearchRec);
  While IIndex = 0 Do
  Begin
    SFileName := ExtractFileDir(SDir) + '\' + SearchRec.Name;
    If SearchRec.Attr = FaDirectory
    Then
    Begin
      If (SearchRec.Name <> '') And (SearchRec.Name <> '.') And
        (SearchRec.Name <> '..')
      Then DelteDirectory(SFileName);
    End Else Begin
      If SearchRec.Attr <> FaArchive
      Then FileSetAttr(SFileName, FaArchive);
      DeleteFile(SFileName);
    End;
    IIndex := FindNext(SearchRec);
  End;
  FindClose(SearchRec);
  RemoveDir(ExtractFileDir(SDir));
  Result := True;
End; { _______________________________________________________________________ }

Function ProcessExists(ExeFileName: String): Boolean;
Var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
Begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.DwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  While Integer(ContinueLoop) <> 0 Do
  Begin
    If ((UpperCase(ExtractFileName(FProcessEntry32.SzExeFile))
      = UpperCase(ExeFileName)) Or (UpperCase(FProcessEntry32.SzExeFile)
      = UpperCase(ExeFileName)))
    Then
    Begin
      Result := True;
    End;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  End;
  CloseHandle(FSnapshotHandle);
End; { _______________________________________________________________________ }

Function ExeRunning(NomApplication: String; StopProcess: Boolean): Boolean;
// Teste si une application est en cours d'exécution
// StopProcess indique si on termine l'application 'NomApplication'

// Code proposé par Thunder_nico

Var
  ProcListExec: TProcessentry32;
  PrhListExec: Thandle;
  Continu: Boolean;
  IsStarted: Boolean;
  HandleProcessCourant: Cardinal;
  PathProcessCourant: String;
  ProcessCourant: String;

Begin
  // Liste des applications en cours d'exécution
  // Initialisation des variables et récuperation de la liste des process
  ProcListExec.DwSize := Sizeof(ProcListExec);
  Continu := True;
  IsStarted := False;

  Try
    // Récupére la liste des process en cours d'éxécution au moment de l'appel
    PrhListExec := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
    If (PrhListExec <> INVALID_HANDLE_VALUE)
    Then
    Begin
      // On se place sur le premier process
      Process32First(PrhListExec, ProcListExec);

      // Tant que le process recherché n'est pas trouvé et qu'il reste
      // des process dans la liste, on parcourt et analyse la liste
      While Continu Do
      Begin
        ProcessCourant := Uppercase(ExtractFileName(ProcListExec.SzExeFile));
        ProcessCourant := ChangeFileExt(ProcessCourant, '');
        IsStarted := (ProcessCourant = Uppercase(NomApplication));
        If IsStarted
        Then
        Begin
          HandleProcessCourant := ProcListExec.Th32ProcessID;
          PathProcessCourant := ExtractFilepath(ProcListExec.SzExeFile);
          Continu := False;
        End
        Else // Recherche le process suivant dans la liste
            Continu := Process32Next(PrhListExec, ProcListExec);
      End;

      If StopProcess
      Then
        If IsStarted
        Then
        Begin // Termine le process en indiquant le code de sortie zéro
          TerminateProcess(OpenProcess(PROCESS_TERMINATE, False,
            HandleProcessCourant), 0);
          Sleep(500);
          // Laisse le temps au process en cours de suppression de s'arrêter
        End;
    End;
  Finally
    CloseHandle(PrhListExec); // Libère les ressources
    Result := IsStarted;
  End;
End;

function lancerContrôlerapplicationext(Runapp:string):boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  CommandLine: {$IFDEF UNICODE}WideString{$ELSE}string{$ENDIF};

begin
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);

  if CreateProcess(nil, PChar(Runapp), nil, nil, FALSE, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    repeat
      Application.ProcessMessages;
    until WaitForSingleObject(ProcessInfo.hProcess, 200) <> WAIT_TIMEOUT;

    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    result:=true;
  end
  else
  //RaiseLastOSError;
   result:=false;
end;

End.
