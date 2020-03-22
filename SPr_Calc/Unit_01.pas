Unit Unit_01;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  IniFiles, ShellApi, Shlobj, Vcl.ComCtrls, Vcl.Mask, ScGPExtControls,
  Vcl.Samples.Spin;

Type
  TFrm_01 = Class(TForm)
    Panel1: TPanel;
    PnlToolbar: TPanel;
    Edbanque: TEdit;
    Edcompte: TEdit;
    Edagence: TEdit;
    Edclerib: TEdit;
    Edcontrol: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BtnCalcRib: TBitBtn;
    BtnEpre: TBitBtn;
    StatusBar1: TStatusBar;
    BtnNss: TBitBtn;
    MaskEdNss: TMaskEdit;
    EdNss: TEdit;
    Label6: TLabel;
    Edcle: TEdit;
    SpBClear: TSpeedButton;
    Ednomanque: TLabel;
    Procedure EdbanqueChange(Sender: TObject);
    Procedure EdbanqueEnter(Sender: TObject);
    Procedure BtnCalcRibClick(Sender: TObject);
    Procedure BtnEpreClick(Sender: TObject);
    Procedure BtnNssClick(Sender: TObject);
    Procedure SpBClearClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure EKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
  Private
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Var
  Frm_01: TFrm_01;

  { __________________________________________________________________________ }
Implementation

Uses
  Sun_function, Unit_ux, USMainView;
{$R *.dfm}

{ ............................................................................ }
Procedure TFrm_01.BtnCalcRibClick(Sender: TObject);
Begin
  If (Edbanque.Text = '') Then Edbanque.Text := '007';
  If Length(Edbanque.Text) < 3 Then
      Edbanque.Text := AddChar(Edbanque.Text, 3, '0');

  If Edagence.Text = '' Then Edagence.Text := '99999';
  If Length(Edagence.Text) < 5 Then
      Edagence.Text := AddChar(Edagence.Text, 5, '0');
  If (Length(Edcompte.Text) < 10) Then
      Edcompte.Text := AddChar(Edcompte.Text, 10, '0');

  Edclerib.Text := CleRIb(Edbanque.Text, Edagence.Text, Edcompte.Text,
    Edclerib.Text);
  Edcle.Text := CleRip(AddChar(Edcompte.Text, 10, '0'));
  StatusBar1.Panels[0].Text := Status;
  Begin
  End;
  Edclerib.SelectAll;
  Edclerib.CopyToClipboard;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.BtnEpreClick(Sender: TObject);
Begin
  ControleRib(Edcontrol.Text);
  StatusBar1.Panels[0].Text := Status;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.BtnNssClick(Sender: TObject);
Begin
  EdNSS.Text := Inttostr(NSScontrole(MaskEdNss.Text));
  IF (EdNSS.Text = '99') OR (Strtoint(EdNSS.Text) < 0) THEN EdNSS.Text := 'ER';
  StatusBar1.Panels[0].Text := Status;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.EdbanqueChange(Sender: TObject);
Begin
  Try
    IF FileExists(IniDir) THEN
    BEGIN
      IniFile := TINIFile.Create(IniDir);
      Ednomanque.Caption := IniFile.ReadString('Paramètres_Listes des Banaque',
        Edbanque.Text, '');
    END;
  Finally
    IniFile.Free;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.EdbanqueEnter(Sender: TObject);
Begin
  Edbanque.Clear;
  Edagence.Clear;
  Edcompte.Clear;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.EKeyDown(Sender: TObject; Var Key: Word; Shift: TShiftState);
Begin
  If Key = VK_RETURN Then
      PostMessage(Screen.ActiveForm.Handle, WM_NEXTDLGCTL, 0, 0);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.FormCreate(Sender: TObject);
Begin
  Frm_MainForm.ImlIcons.Getbitmap(8, SpBClear.Glyph);
  StatusBar1.Panels[0].Width:=Panel1.Width;
  Ednomanque.Font.Size := 8;
  SpBClear.Click;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_01.SpBClearClick(Sender: TObject);
Begin
  Effacetout(Frm_01);
  StatusBar1.Panels[0].Text:='';
End; { _______________________________________________________________________ }

End.
