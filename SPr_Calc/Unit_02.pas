Unit Unit_02;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Controls, Vcl.Buttons,
  Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls, ShellApi, Shlobj,
  Vcl.Forms, Vcl.Dialogs, Vcl.DBCtrls, Vcl.Mask,
  ScControls, ScGPExtControls, Vcl.Samples.Spin;

Type
  TFrm_02 = Class(TForm)
    Panel1: TPanel;
    PnlToolbar: TPanel;
    Memo1: TMemo;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure Memo1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure BitBtn3Click(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure Panel1Resize(Sender: TObject);
  Private
    { Déclarations privées }
  Public
    { Déclarations publiques }
  End;

Var
  Frm_02: TFrm_02;
  Tlis: TStringList;

Implementation

{$R *.dfm}

USES
  Vcl.Themes, Unit_ux, Sun_function;

{ ............................................................................ }
Procedure TFrm_02.BitBtn1Click(Sender: TObject);
Var
  Idx: Integer;
Begin
  Idx := 0;
  ListBox1.Clear;
  Repeat
    If (Memo1.Lines[Idx].Length = 20) And
      (IsStrANumber(Memo1.Lines[Idx]) = True) Then
    Begin
      ControleRib(Memo1.Lines[Idx]);
      Tlis.Add(Memo1.Lines[Idx]);
      ListBox1.Items.Add(Format(' %d', [Idx]) + '  ' + Status);
    End
    Else ListBox1.Items.Add(Format(' %d', [Idx]) + '  ' + 'ERR');
    Memo1.Lines[Idx] := Memo1.Lines[Idx] + ' / ' + IntToStr(Idx);
    Idx := Idx + 1;
  Until Memo1.Lines.Count = Idx;
  Memo1.Selstart := 0;
  Memo1.Perform(EM_SCROLLCARET, 0, 0);
  BitBtn3.Enabled := True;
  BitBtn1.Enabled := False;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.BitBtn2Click(Sender: TObject);
Begin
  Memo1.Clear;
  ListBox1.Clear;
  BitBtn1.Enabled := True;
  BitBtn3.Enabled := False;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.BitBtn3Click(Sender: TObject);
Begin
  Memo1.Text := Tlis.Text;
  BitBtn3.Enabled := False;
  BitBtn1.Enabled := True;
  ListBox1.Clear;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.FormCreate(Sender: TObject);
Begin
  Tlis := TStringList.Create;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.FormDestroy(Sender: TObject);
Begin
  Tlis.Free;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.Memo1Click(Sender: TObject);
Var
  Linea: Integer;
Begin
  With (Sender As TMemo) Do
  Begin
    Linea := Perform(EM_LINEFROMCHAR, Selstart, 0);
    Selstart := Perform(EM_LINEINDEX, Linea, 0);
    SelLength := Length(Lines[Linea]);
  End;
  ListBox1.ItemIndex := Linea;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure TFrm_02.Panel1Resize(Sender: TObject);
Begin
  Memo1.Left := (Panel1.Width - Memo1.Width) Div 2;
  ListBox1.Left := (Panel1.Width - ListBox1.Width) Div 2;
  BitBtn1.Left := Memo1.Left;
  BitBtn3.Left := (Panel1.Width - BitBtn3.Width) Div 2;
  BitBtn2.Left := Memo1.Width + Memo1.Left - BitBtn2.Width;
End; { _______________________________________________________________________ }

End.
