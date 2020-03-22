Unit Unit_03;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Samples.Spin, Vcl.StdCtrls, Vcl.Mask,
  ScGPExtControls, Vcl.Controls, Vcl.ExtCtrls, ShellApi, Shlobj,
  Vcl.Dialogs, Vcl.Forms, Vcl.Buttons;

Type
  TFrm_03 = Class(TForm)
    Panel1: TPanel;
    PnlToolbar: TPanel;
    Label7: TLabel;
    NEdimpo: TscGPNumericEdit;
    Label8: TLabel;
    EdIrg: TscGPNumericEdit;
    SEbase: TSpinEdit;
    Label9: TLabel;
    NEdCotis: TscGPNumericEdit;
    Label1: TLabel;
    NEdRetss: TscGPNumericEdit;
    Label2: TLabel;
    Btnexi: TBitBtn;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    Procedure Calc(Sender: TObject);
    Procedure NEdimpoExit(Sender: TObject);
    Procedure BtnexiClick(Sender: TObject);
    Procedure NEdCotisChange(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
  Private
    { Déclarations privées }

  Public
    { Déclarations publiques }

  End;

Var
  Frm_03: TFrm_03;

Implementation

{$R *.dfm}

USES
  Vcl.Themes, Unit_ux, Sun_function;

{ ............................................................................ }
Procedure TFrm_03.BtnexiClick(Sender: TObject);
Var
  Ids, Id, Vales: Integer;
  Memos: TStringList;
Begin
  Application.ProcessMessages;
  Formatsettings.CurrencyString := '';
  Id := 15000;
  Ids := 0;
  Vales := StrToInt(SpinEdit1.Text);
  Memos := TStringList.Create();
  // memos.Add('------- ------------ ------------' );
  Repeat
    Ids := Ids + 1;
    Memos.Add('|' + Addchar(IntToStr(Ids), 6, ' ') + '|' +
      Addchar(FloatToStrF(Id, FfCurrency, 10, 2), 12, ' ') + '|' +
      Addchar(FloatToStrF(CalcIrg(Id, 30), FfCurrency, 8, 2), 11, ' ') + '|');
    // memos.Add('------- ------------ ------------' );
    // if id >1000000 then   id:=id+10000 else
    // if id >=350000 then  id:=id+1000  else
    Id := Id + SEbase.Value;
  Until Id >= Vales;

  If SaveDialog1.Execute Then Memos.SaveToFile(SaveDialog1.FileName);
  Memos.Free
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_03.Calc(Sender: TObject);
Begin
  IF NEdimpo.Text <> '' THEN
    TRY
      ValArgent := StrToCurrDef(NEdimpo.Text, ValArgent);
      EdIrg.Text := CurrToStr(CalcIrg(ValArgent, SEbase.Value));
    EXCEPT
      EdIrg.Text := '';
    END;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_03.FormCreate(Sender: TObject);
Begin

End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_03.NEdCotisChange(Sender: TObject);
Begin
  NEdRetss.Value := NEdCotis.Value * 0.09;
  NEdimpo.Value := NEdCotis.Value * 0.91;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_03.NEdimpoExit(Sender: TObject);
Begin
  NEdCotis.Value := NEdimpo.Value / 0.91;
End; { _______________________________________________________________________ }

End.
