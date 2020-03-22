// and your program will not be started twice:

Unit Sun_function;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Shlobj, Registry,
  StdCtrls, StrUtils, ExtCtrls, ComCtrls, ShellApi, IniFiles;

{ ............................................................................ }
Var
  { ... Frm Main }
  IniDir: String;
  IniFile: TINIFile;
  DTacces: TDate;
  Dtvalue: String;
  List: Tstringlist;
  MMethodenvent: String;
  // Fichier:string;

  { .......................................................................... }
  // function SpecialFolder(Folder: Integer): String;
Function GetSpecialFolderPath(CSIDLFolder: Integer): String;
Function Inputcombo(Const Acaption, Aprompt: String): TDate;
Function FileVerInfo(Const Arquivo: String): String;
Procedure ShowTaskBar(Show: Boolean);
Procedure DelAppFromRun(RunName: String);
Function IsAppInRun(RunName: String): Boolean;
procedure DoAppToRun(RunName, AppName: string);
Implementation

//  Applications under the key "Run" will be executed
//  each time the user logs on.
// Add the application to the registry...
procedure DoAppToRun(RunName, AppName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    WriteString(RunName, AppName);
    CloseKey;
    Free;
  end;
end;
// Check if the application is in the registry...
function IsAppInRun(RunName: string): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
    Result := ValueExists(RunName);
    CloseKey;
    Free;
  end;
end;
// Remove the application from the registry...
procedure DelAppFromRun(RunName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_CURRENT_USER;
    OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    if ValueExists(RunName) then DeleteValue(RunName);
    CloseKey;
    Free;
  end;
end;
{ ............................................................................ }
Procedure ShowTaskBar(Show: Boolean);
Var
  Taskbar: HWND;
Begin
  Taskbar := FindWindow('Shell_TrayWnd', Nil);
  If (Taskbar <> 0) Then
  Begin
    If Show Then ShowWindow(Taskbar, SW_SHOW)
    Else ShowWindow(Taskbar, SW_HIDE);
    UpdateWindow(Taskbar);
  End;
End;  { Procedure Barre des tâches windows}

{ ............................................................................ }
Function GetSpecialFolderPath(CSIDLFolder: Integer): String;
Var
  FilePath: Array [0 .. MAX_PATH] Of Char;
Begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, FilePath);
  Result := FilePath;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function FileVerInfo(Const Arquivo: String): String;
Var
  Major, Minor, Release, Build: Integer;
  Zero: DWORD; { a variavel que recebe zero }
  TamanhoVersao: DWORD;
  PDadosVersao: Pointer;
  PInfoFixaArquivo: PVSFixedFileInfo;
  TamanhoFixoInfoArquivo: UINT; // Inteiro de 32 bits;
Begin
  { Pergunta ao windows tamanho do buffer para alocar a informa??o sobre a
    vers?o }
  TamanhoVersao := GetFileVersionInfoSize(PChar(Arquivo), Zero);
  { Se n?o h informa??es sobre a vers?o }
  If TamanhoVersao = 0 Then
  Begin
    Result := '';
    ShowMessage('Sem informa??es sobre a vers?o');
    Exit;
  End;
  { Aloca memria para guardar as informa?oes da vers?o }
  PDadosVersao := AllocMem(TamanhoVersao);
  Try
    { Carrega recurso da vers?o do executvel }
    If GetFileVersionInfo(PChar(Arquivo), 0, TamanhoVersao, PDadosVersao)
      = False Then
        Raise Exception.Create('Impossvel obter informa??es da vers?o');
    { Pega a por??o fixa sobre a vers?o no buffer }
    If VerQueryValue(PDadosVersao, '\', Pointer(PInfoFixaArquivo),
      TamanhoFixoInfoArquivo) = False Then
    Begin
      { Sem informa??es fixas nos recursos do arquivo }
      ShowMessage('Sem informa??es fixas sobre a vers?o');
      Result := '';
      Exit;
    End;
    { Extrai as informa??es fixas do resource do arquivo }
    Major := PInfoFixaArquivo^.DwFileVersionMS Shr 16;
    Minor := PInfoFixaArquivo^.DwFileVersionMS And $ffff;
    Release := PInfoFixaArquivo^.DwFileVersionLS Shr 16;
    Build := PInfoFixaArquivo^.DwFileVersionLS And $ffff;
  Finally
    FreeMem(PDadosVersao);
  End;
  Result := IntToStr(Major) + '.' + IntToStr(Minor) + '.' + IntToStr(Release) +
    '.' + IntToStr(Build);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Inputcombo(Const Acaption, Aprompt: String): TDate; { B3 }
  Function Getcharsize(Canvas: Tcanvas): Tpoint;
  Var
    I: Integer;
    Buffer: Array [0 .. 51] Of Char;
  Begin
    For I := 0 To 25 Do Buffer[I] := Chr(I + Ord('A'));
    For I := 0 To 25 Do Buffer[I + 26] := Chr(I + Ord('A'));
    Gettextextentpoint(Canvas.Handle, Buffer, 52, Tsize(Result));
    Result.X := Result.X Div 52;
  End;

Var
  Form: TForm;
  Prompt: Tlabel;
  Combo: TDateTimePicker;
  Dialogunits: Tpoint;
  Buttontop, Buttonwidth, Buttonheight: Integer;
Begin
  // Result := '';
  Form := TForm.Create(Application);
  With Form Do
    Try
      Canvas.Font := Font;
      Dialogunits := Getcharsize(Canvas);
      Borderstyle := Bsdialog;
      Caption := Acaption;
      Clientwidth := Muldiv(180, Dialogunits.X, 4);
      Position := Poscreencenter;
      Prompt := Tlabel.Create(Form);
      With Prompt Do
      Begin
        Parent := Form;
        Caption := Aprompt;
        Left := Muldiv(8, Dialogunits.X, 4);
        Top := Muldiv(8, Dialogunits.Y, 8);
        Constraints.Maxwidth := Muldiv(164, Dialogunits.X, 4);
        Wordwrap := True;
      End;
      Combo := TDateTimePicker.Create(Form);
      With Combo Do
      Begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := Muldiv(164, Dialogunits.X, 4);
    //  Combo.Date:=0+2;
      End;
      Buttontop := Combo.Top + Combo.Height + 15;
      Buttonwidth := Muldiv(50, Dialogunits.X, 4);
      Buttonheight := Muldiv(14, Dialogunits.Y, 8);
      With Tbutton.Create(Form) Do
      Begin
        Parent := Form;
        Caption := 'Ok';
        Modalresult := Mrok;
        Default := True;
        Setbounds(Muldiv(38, Dialogunits.X, 4), Buttontop, Buttonwidth,
          Buttonheight);
      End;
      With Tbutton.Create(Form) Do
      Begin
        Parent := Form;
        Caption := 'Annuler ';
        Modalresult := Mrcancel;
        Cancel := True;
        Setbounds(Muldiv(92, Dialogunits.X, 4), Combo.Top + Combo.Height + 15,
          Buttonwidth, Buttonheight);
        Form.Clientheight := Top + Height + 13;
      End;
      If Showmodal = Mrok Then
      Begin
        Result := Combo.Date;
      End;
    Finally
      Form.Free;
    End;
End; { _______________________________________________________________________ }

{ ............................................................................ }

Initialization

Finalization

End.
