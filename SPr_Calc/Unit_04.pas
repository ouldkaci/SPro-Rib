Unit Unit_04;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, ShlObj, Shellapi,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  ScControls, ScDBControls, Vcl.Buttons, ScGPExtControls, System.AnsiStrings;

Type
  TFrm_04 = Class(TForm)
    Panel1: TPanel;
    PnlToolbar: TPanel;
    Memo_Lettres: TMemo;
    CbBox_: TComboBox;
    Edt_Numeric: TscGPNumericEdit;
    // procedure BitBtn1Click(Sender: TObject);
    Procedure SdsChange(Sender: TObject);
    Procedure Panel1Resize(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    { Déclarations privées }
  Var
    Lettres: STRING; // Mémoire de chiffres a convetire en lettres
  Public
    { Déclarations publiques }
  End;

Var
  Frm_04: TFrm_04;

Implementation

{$R *.dfm}

USES
  Vcl.Themes, Unit_ux, Sun_function, Convert;

{ ............................................................................ }
Procedure TFrm_04.FormCreate(Sender: TObject);
Begin

End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_04.Panel1Resize(Sender: TObject);
Begin
  Memo_Lettres.Left := (Panel1.Width - Memo_Lettres.Width) Div 2;
  Edt_Numeric.Left := Memo_Lettres.Left;
  CbBox_.Left := Memo_Lettres.Left;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_04.SdsChange(Sender: TObject);
Begin
  IF Edt_Numeric.Text <> '' THEN
  Begin
    Lettres := NombreTexte(Edt_Numeric.Value);
    Case IndexStr(CbBox_.Text, ['Défaut', 'Majuscule *.', 'Minuscule *.',
      'Majuscule Premier mots', 'Majuscule chaque Mots']) Of
      0: Memo_Lettres.Text := Lettres; // bobby
      1: Memo_Lettres.Text := UpperCase(Lettres); // tommy
      2: Memo_Lettres.Text := LowerCase(Lettres); // somename
      3: Memo_Lettres.Text := Canonical(Lettres);
      4: Memo_Lettres.Text := ProperCase(Lettres);
      -1: ShowMessage('Not Present'); // not present in array
    Else ShowMessage('Default Option'); // present, but not handled above
    End;
  END;
  Memo_Lettres.Text := DeleteRepeatedSpacesoptimized(Memo_Lettres.Text);
End; { _______________________________________________________________________ }

End.
