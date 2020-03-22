// ---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

// ---------------------------------------------------------------------------

Program SPr_Calc;



{$R *.dres}

uses
  Vcl.Forms,
  ShlObj,
  Shellapi,
  uSMainView in 'uSMainView.pas' {Frm_MainForm},
  Vcl.Themes,
  Vcl.Styles,
  Unit_01 in 'Unit_01.pas' {Frm_01},
  Unit_02 in 'Unit_02.pas' {Frm_02},
  Unit_03 in 'Unit_03.pas' {Frm_03},
  Unit_04 in 'Unit_04.pas' {Frm_04};

{$R *.res}

Begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Office Light');
  Application.Title := '';
  Application.CreateForm(TFrm_MainForm, Frm_MainForm);
  Application.CreateForm(TFrm_01, Frm_01);
  Application.CreateForm(TFrm_02, Frm_02);
  Application.CreateForm(TFrm_03, Frm_03);
  Application.CreateForm(TFrm_04, Frm_04);
  Application.Run;

End.
