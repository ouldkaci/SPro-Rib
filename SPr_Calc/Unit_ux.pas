{ Cette unité a été développée par Ouldaci Rabah (2020) }
{ Il peut être utilisé librement dans votre propre développement. }
{ Merci pour votre intérêt. }
Unit Unit_ux;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.Sysutils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  Wintypes, Winprocs, Extctrls, Stdctrls, Buttons, Strutils, Shellapi,
  Inifiles, Dateutils, Math, Vcl.Mask, Shlobj;

{ Menus, , Registry,Imglist, Activex, Comobj, Shlobj,
  , Mask, Comctrls, Themes, Styles,  Spin,
  System.Uitypes, Zip, Jpeg, System.Types, }
{ Ip }{ Idstack,Idbasecomponent, Idcomponent, Idipwatch; }
{ ............................................................................ }
Var
  Status, Info, Check: String;
  Path_exe: String;
  Valargent: Currency;
  Lettres: String; // Mémoire de chiffres a convetire en lettres
  Dtvalue: String;
  List: Tstringlist;

  { .......................................................................... }
Type
  Tfrm = Class(Tform)
  Protected
    { Déclarations Protégées }
  Private
    { Déclarations Privées }
  Public
    { Déclarations Publiques }
  End;

  { .......................................................................... }
Procedure Paramstr_region;
Procedure Paramstr_form(Frm: Tform; W, H: Longint);
Function Isnumber(N: String): Boolean;
Function Isstranumber(Const S: String): Boolean;
Function Addchar(Const Source: String; Len: Integer; Letr: Char): String;

Function Controlerib(Rib: String): Boolean;
Function Clerib(Banque: String; Agence: String; Compte: String;
  Rib: String): String;
Function Clerip(Compte: String): String;
Function Calcirg(Simposabl: Currency; Base: Integer): Currency;
Function Nsscontrole(Nss: String): Integer; // Extended;
Procedure Effacetout(Fenetre: Tform);

Function Propercase(Sbuffer: String): String;
Function Titlecase(Const S: String): String;
Function Canonical(Const S: String): String;
Function Capitalizewords(Const S: String): String;
Function Deleterepeatedspaces(Const S: String): String;
Function Deleterepeatedspacesoptimized(Const Oldtext: String): String;

// Function TextToCurrency(Const s: String): currency;
Procedure Winabout(Const Appname, Stuff: String);
Function Getharddiskserial(Const Driveletter: Char): String;
Function Appversion(Const Filename: String): String;
Function Getversion(Exename: String): String;

{ ............................................................................ }
{ ............................................................................ }

Implementation

{ ............................................................................ }
Procedure Paramstr_region;
Var
  Formatdz: Tformatsettings;
Begin
  // Create New Setting And Configure For The Algeria
  // Créer un nouveau paramètre et configurer pour l'Algérie
  With Formatsettings Do Formatdz := Tformatsettings.Create;
  Formatdz.Decimalseparator := '.';
  Formatdz.Thousandseparator := ' ';
  Formatdz.Currencydecimals := 2;
  Formatdz.Dateseparator := '/';
  Formatdz.Shortdateformat := 'dd/mm/yyyy';
  Formatdz.Longdateformat := 'dd/mm/yyyy';
  Formatdz.Timeseparator := ':';
  Formatdz.Timeamstring := 'Am';
  Formatdz.Timepmstring := 'Pm';
  Formatdz.Shorttimeformat := 'hh:nn';
  Formatdz.Longtimeformat := 'hh:nn:ss';
  Formatdz.Currencystring := 'DZD';
  // Assign The App Region Settings To The Newly Created
  // Attribuer les paramètres de la région à la nouvelle création
  Formatsettings := Formatdz;
  Application.Updateformatsettings := True;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Paramstr_form(Frm: Tform; W, H: Longint);
Begin
 // Frm.Width :=  Screen.Width Div 4; //
 // Frm.Height :=  Screen.Height Div 16 * 10;

   Frm.Font.Name := 'Segoe UI';
  Frm.Font.Size := 10;

  // Frm.BorderStyle := bsToolWindow;
  Frm.Scaled := True;
  Frm.Autoscroll := False;
  Frm.Bordericons := Frm.Bordericons - [Bimaximize];
  // Frm.Position := Poscreencenter;

  If (Screen.Width <> W) Then
  Begin
    Frm.Height := Longint(Frm.Height) * Longint(Screen.Height) Div H;
    Frm.Width := Longint(Frm.Width) * Longint(Screen.Width) Div W;
    Frm.Scaleby(W, H);
  End;
  Frm.Constraints.Maxheight := Frm.Height;
  Frm.Constraints.Maxwidth := Frm.Width;
  Frm.Constraints.Minheight := Frm.Height;
  Frm.Constraints.Minwidth := Frm.Width;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Isstranumber(Const S: String): Boolean;
Var
  P: Pchar;
Begin
  P := Pchar(S);
  Result := False;
  While P^ <> #0 Do
  Begin
    If Not(P^ In ['0' .. '9']) Then Exit;
    Inc(P);
  End;
  Result := True;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Isnumber(N: String): Boolean;
Var
  I: Integer;
Begin
  Result := True;
  If Trim(N) = '' Then Exit(False);
  If (Length(Trim(N)) > 1) And (Trim(N)[1] = '0') Then Exit(False);
  For I := 1 To Length(N) Do
  Begin
    If Not(N[I] In ['0' .. '9']) Then
    Begin
      Result := False;
      Break;
    End;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Addchar(Const Source: String; Len: Integer; Letr: Char): String;
Var
  I: Integer;
Begin
  Result := Source;
  For I := 1 To (Len - Length(Source)) Do Result := Letr + Result;
End; { _______________________________________________________________________ }

{ ............................................................................ }
{ code }
Function Calcirg(Simposabl: Currency; Base: Integer): Currency;
Var
  Irg: Currency;
Begin
  Irg := 0;
  If Simposabl <= 15000 Then Irg := 0
  Else If Simposabl >= 120010 Then
      Irg := (Simposabl - 120000) / 10 * 3.5 + 29500
  Else If Simposabl >= 30010 Then Irg := (Simposabl - 30000) / 10 * 3 + 2500
  Else If Simposabl >= 28760 Then Irg := (Simposabl - 28750) / 10 * 2 + 2250
  Else If Simposabl >= 22510 Then Irg := (Simposabl - 22500) / 10 * 1.2 + 1500
  Else If Simposabl >= 15010 Then Irg := (Simposabl - 15000) / 10 * 2;
  Irg := (Irg * Base) / 30;
  Result := Irg;
  // Result:=FloatToStrf(Irg,ffCurrency,8,2);
  // Result:=FormatFloat('0.00',irg);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Clerib(Banque: String; Agence: String; Compte: String;
  Rib: String): String;
Begin
  Status := '';
  Banque := Addchar(Banque, 3, '0');
  Agence := Addchar(Agence, 5, '0');
  Compte := Addchar(Compte, 10, '0');
  Rib := Inttostr(97 - (Strtoint64(Agence + Compte) * 100) Mod 97);
  Rib := Banque + Agence + Compte + Addchar(Rib, 2, '0');
  Result := Rib;
  If Compte = '0000000000' Then Status := 'Operations incomplet'
  Else Status := 'Operations Calc.Rib effectué';
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Clerip(Compte: String): String;
Var
  Som, I: Integer;
Begin
  // Status:='';
  Som := 0;
  For I := 1 To Length(Compte) Do Som := Som + (Strtoint(Compte[I]) * (14 - I));
  Result := Addchar(Inttostr(Som Mod 100), 2, '0');
  If Compte = '0000000000' Then
    // Status:='*** Operations incomplet  ***'
  Else
    // Status:='*** Operations Cle.Rip effectué avec succès ***';
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Controlerib(Rib: String): Boolean;
Var
  Cle: String;
Begin
  If Length(Rib) < 20 Then
      Status := 'Relevé d''Identité Bancaire incomplet'
  Else
  Begin
    Cle := Rib;
    Rib := Addchar(Inttostr(97 - Strtoint64(Midbstr(Rib, 4, 15)) *
      100 Mod 97), 2, '0');
    If Rib = Rightstr(Cle, 2) Then Result := True;
    If Result = True Then
        Status := 'Relevé d''identité Bancaire conforme'
    Else Status := 'Numéro de compte est irrégulier'
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Nsscontrole(Nss: String): Integer; // Extended;
Var
  I, Somme, Som: Integer;
Begin
  If (Nss <> '') And (Length(Nss) = 12) Then
  Begin
    Somme := 0;
    For I := 1 To Length(Nss) - 2 Do
    Begin
      If I Mod 2 = 1 Then Som := Strtoint(Nss[I]) * 2
      Else Som := Strtoint(Nss[I]) * 1;
      Somme := Somme + Som;
    End;
    Result := 99 - Somme;
    If Result = Strtoint(Rightstr(Nss, 2)) Then
    Begin
      Status := 'Numéro de sécurité social est Conforme';
    End Else Begin
      Status := 'Numéro de sécurité social Irrégulier';
    End;
  End Else Begin
    Result := 99; // Extended; 0.1E99
    Status := 'Numéro de sécurité social inexistant';
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Effacetout(Fenetre: Tform);
Var
  I: Integer;
Begin
  For I := 0 To Fenetre.Componentcount - 1 Do
  Begin
    // if (Fenetre.Components[i] is TEdit) then (Fenetre.Components[i] as TEdit).Text:= '';
    If (Fenetre.Components[I] Is Tedit) Then
      (Fenetre.Components[I] As Tedit).Clear;
    // if (Fenetre.Components[i] is TEdit) then (Fenetre.Components[i] as TEdit).Font.Style:=[fsBold];
    If (Fenetre.Components[I] Is Tlabelededit) Then
      (Fenetre.Components[I] As Tlabelededit).Clear;
    If (Fenetre.Components[I] Is Tbuttonededit) Then
      (Fenetre.Components[I] As Tbuttonededit).Clear;
    If (Fenetre.Components[I] Is Tmemo) Then
      (Fenetre.Components[I] As Tmemo).Clear;
    If (Fenetre.Components[I] Is Tmaskedit) Then
      (Fenetre.Components[I] As Tmaskedit).Clear;
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Texttocurrency(Const S: String): Currency;
Var
  I, K: Integer;
  Numerals: Set Of Char;
  Temp: String;
Begin
  Numerals := ['0' .. '9', '-', '+', Formatsettings.Decimalseparator,
    Formatsettings.Thousandseparator];
  I := 1;
  While (I <= Length(S)) And Not(S[I] In Numerals) Do Inc(I);
  Exclude(Numerals, '-');
  Exclude(Numerals, '+');
  K := I + 1;
  While (K <= Length(S)) And (S[K] In Numerals) Do
  Begin
    If S[K] = Formatsettings.Decimalseparator Then
    Begin
      Exclude(Numerals, '.'); // FormatSettings.DecimalSeparator
      Exclude(Numerals, ',');
      Exclude(Numerals, ' '); // FormatSettings.ThousandSeparator
    End;
    Inc(K);
  End; { While }
  If (I <= Length(S)) Then
  Begin
    Temp := Copy(S, I, K - I);
    For I := Length(Temp) Downto 1 Do
      If Temp[I] = Formatsettings.Thousandseparator Then Delete(Temp, I, 1);
    Result := Strtofloat(Temp)
  End
  Else Raise Econverterror.Createfmt('%s is not a valid currency value!', [S]);
End; { TextToCurrency }

{ ............................................................................ }
Function Propercase(Sbuffer: String): String;
Var
  Ilen, Iindex: Integer;
Begin
  Ilen := Length(Sbuffer);
  Sbuffer := Uppercase(Midstr(Sbuffer, 1, 1)) +
    Lowercase(Midstr(Sbuffer, 2, Ilen));
  For Iindex := 0 To Ilen Do
  Begin
    If Midstr(Sbuffer, Iindex, 1) = ' ' Then
        Sbuffer := Midstr(Sbuffer, 0, Iindex) +
        Uppercase(Midstr(Sbuffer, Iindex + 1, 1)) +
        Lowercase(Midstr(Sbuffer, Iindex + 2, Ilen));
  End;
  Result := Sbuffer;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Deleterepeatedspacesoptimized(Const Oldtext: String): String;
Var
  Po, Pr: Pchar;
Begin
  Setlength(Result, Length(Oldtext));
  Pr := Pointer(Result);
  Po := Pointer(Oldtext);
  While (Po^ <> '') Do
  Begin
    Pr^ := Po^;
    Inc(Pr);
    If (Po^ <> ' ') Then
    Begin
      Inc(Po);
      Continue;
    End;
    Repeat // Skip additional spaces
        Inc(Po);
    Until (Po^ = '') Or (Po^ <> ' ');
  End;
  Setlength(Result, Pr - Pointer(Result));
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Deleterepeatedspaces(Const S: String): String;
Var
  I, J, State: Integer;
Begin
  Setlength(Result, Length(S));
  J := 0;
  State := 0;
  For I := 1 To Length(S) Do
  Begin
    If S[I] = ' ' Then Inc(State)
    Else State := 0;
    If State < 2 Then Result[I - J] := S[I]
    Else Inc(J);
  End;
  If J > 0 Then Setlength(Result, Length(S) - J);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Capitalizewords(Const S: String): String;
Var
  I: Integer;
  Lastwasalphanum: Boolean;
Begin
  Result := Ansilowercase(S);
  Lastwasalphanum := False;
  For I := 1 To Length(Result) Do
  Begin
    If Ischaralphanumeric(Result[I]) Then
    Begin
      { Nous avons une lettre ou un chiffre, est-ce le premier ou le caractère
        devant pas une lettre ou un chiffre? }
      If Not Lastwasalphanum Then
      Begin
        { Majuscule le caractère. L'utilisation de la fonction API prend
          soin des caractères internationaux, ce que fait UpCase
          pas gérer. Si nous avons un nombre, il restera inchangé. }
        Charupperbuff(@Result[I], 1);
        Lastwasalphanum := True;
      End; { If }
    End { If }
    Else Lastwasalphanum := False;
  End; { For }
End; { CapitalizeWords }

{ ............................................................................ }
Function Downcase(Ch: Char): Char;
Begin
  If Ch In ['A' .. 'Z'] Then Result := Chr(Ord(Ch) - Ord('A') + Ord('a'))
  Else Result := Ch;
End; { _______________________________________________________________________ }

{ ............................................................................ }
// Convertir un identifiant en forme canonique, c'est-à-dire en majuscule initial
// caractère suivi de tous les caractères minuscules.
Function Canonical(Const S: String): String;
Var
  I: Integer;
Begin
  Setlength(Result, Length(S));
  If Length(S) > 0 Then Result[1] := Upcase(S[1]);
  For I := 2 To Length(S) Do Result[I] := Downcase(S[I]);
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Titlecase(Const S: String): String;
Var
  I: Integer;
Begin
  If S = '' Then Result := ''
  Else
  Begin
    Result := Uppercase(S[1]);
    For I := 2 To Length(S) Do
      If S[I - 1] = ' ' Then Result := Result + Uppercase(S[I])
      Else Result := Result + Lowercase(S[I]);
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Procedure Winabout(Const Appname, Stuff: String);
Var
{$Ifdef Ver80}
  Szapp, Szstuff: Array [0 .. 255] Of Char;
{$Endif}
  Wnd: Hwnd;
  Icon: Hicon;
Begin
  If Application.Mainform <> Nil Then Wnd := Application.Mainform.Handle
  Else Wnd := 0;
  Icon := Application.Icon.Handle;
  If Icon = 0 Then Icon := Loadicon(0, Idi_application);
{$Ifndef Ver80}
  Shellabout(Wnd, Pchar(Appname), Pchar(Stuff), Icon);
{$Else}
  Strplcopy(Szapp, Appname, Sizeof(Szapp) - 1);
  Strplcopy(Szstuff, Stuff, Sizeof(Szstuff) - 1);
  Shellabout(Wnd, Szapp, Szstuff, Icon);
{$Endif}
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Getversion(Exename: String): String;
Var
  S: String;
  Taille: Dword;
  Buffer: Pchar;
  Pversionpc: Pchar;
  Versionl: Dword;
Begin
  Result := '';
  S := Exename;
  Taille := Getfileversioninfosize(Pchar(S), Taille);
  If Taille > 0 Then
    Try

      Buffer := Allocmem(Taille);

      Getfileversioninfo(Pchar(S), 0, Taille, Buffer);

      If Verqueryvalue(Buffer, Pchar('\StringFileInfo\040C04E4\FileVersion'),
        Pointer(Pversionpc), Versionl) Then
      Begin
        Result := Pversionpc;
      End;

    Finally
      Freemem(Buffer, Taille);
    End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Appversion(Const Filename: String): String;
Var
  Dwhandle: Thandle;
  Dwsize: Dword;
  Lpdata, Lpdata2: Pointer;
  Uisize: Uint;
Begin
  Result := '';
  Dwsize := Getfileversioninfosize(Pchar(Filename), Dwsize);
  If Dwsize <> 0 Then
  Begin
    Getmem(Lpdata, Dwsize);
    If Getfileversioninfo(Pchar(Filename), Dwhandle, Dwsize, Lpdata) Then
    Begin
      Uisize := Sizeof(Tvsfixedfileinfo);
      Verqueryvalue(Lpdata, '', Lpdata2, Uisize);
      With Pvsfixedfileinfo(Lpdata2)^ Do
          Result := Format('%d.%02d.%02d.%02d', [Hiword(Dwproductversionms),
          Loword(Dwproductversionms), Hiword(Dwproductversionls),
          Loword(Dwproductversionls)]);
    End;
    Freemem(Lpdata, Dwsize);
  End;
End; { _______________________________________________________________________ }

{ ............................................................................ }
Function Getharddiskserial(Const Driveletter: Char): String;
Var
  Notused, Volumeflags, Volumeserialnumber: Dword;
  Volumeinfo: Array [0 .. Max_path] Of Char;
Begin
  Getvolumeinformation(Pchar(Driveletter + ':'), Volumeinfo, Sizeof(Volumeinfo),
    @Volumeserialnumber, Notused, Volumeflags, Nil, 0);
  // Result := Format('%sHDiskSerial = %8.8X', [VolumeInfo, VolumeSerialNumber]);
  Result := Format(Driveletter + '%s%8.8X', [Volumeinfo, Volumeserialnumber]);
End; { _______________________________________________________________________ }

End.
(*
  Function Cherchesylefile: Boolean;
  Function Styletolist(Cbox_Sty: Tlistbox): Boolean;
  { ... }
  Function Set_Longmonth(Mchiffre: Integer; Src2: String): String; { A1 }
  Function Get_Month(Sources, Destination: String): String; { A2 }
  Function Get_Customonth(Sources, Destination: String): String;
  Function Get_Months(Sources, Destination: String): String; { A3 }
  Function Set_Month(Mchiffre: Integer; Src2: String): String; { A4 }
  Function Set_Quarter(Sources_Mois: String): String; { A5 }    // Trimestre
  Function Addzeros(Const Source: String; Len: Integer): String; { A6 }
  Function Addvide(Const Source: String; Len: Integer): String; { A7 }
  Function Addvide2(Const Source: String; Len: Integer): String;
  Function Calcirg(Simposabl: Currency; Base: Integer): Real; { A8 }
  { ... }

  Function Inverssortfunc(List: Tstringlist; Index1, Index2: Integer): Integer;
  Function Inputcombo(Const Acaption, Aprompt: String; Const Alist: Tstrings)
  : String; { B3 }
  Procedure Setitemindex(Ix: Integer; Cb: Tcombobox); // { B4 }
  { ... }
  Procedure Requete(Adocon: Tadoconnection; Sqltxt: String;
  Msgshow: Boolean); { C1 }
  Procedure Doincrementalfilter(Dataset: Tdataset;
  Const Fieldname, Searchterm: String); { C2 }
  Procedure Doincrementalfiltercontient(Dataset: Tdataset;
  Const Fieldname, Searchterm: String); { C3 }
  Function Compactandrepair(Db: String): Boolean;
  { Db = Path To Access Database }{ C4 }
  Function Getfilelastaccesstime(Sfilename: String): Tdatetime; { C6 }
  Procedure Liste_Msg(Msgdbrid: Tdbgrid); { C6 }
  Procedure Changedbnavimage(Dbnav: Tdbnavigator); { C7 }
  Function Gridselectall(Grid: Tdbgrid): Longint; { C8 }
  Function Getadoversion: Double; { C9 }
  Procedure Applicationevents1exception(Adoconnection: Tadoconnection;
  E: Exception); { C10 }
  Procedure Fieldtstringlist(Dataset: Tadodataset;
  Fieldufirstname, Fieldulastname: String; Stringlist: Tstringlist); { C11 }
  Procedure Field_Tstringlist(Dataset: Tadodataset;
  Firstfield: String; Stringlist: Tstringlist);
  Function Getfieldtypename(Atype: Tfieldtype): String; { C12a }
  Function Getcreatetable(Dataset: Tdataset): Tstrings; { C12v }
  { ... }
  Function Createdesktopshelllink(Const Targetname: String): Boolean; { D1 }
  Function Getdesktopfolder: String; { D1 }
  Procedure Setanimation(Value: Boolean); { D2 }
  Function Gettaskbarsize: Trect; { D3 }
  Procedure Rescaleform(F: Tscrollingwincontrol); { D4 }
  Procedure Switchfullscreen(Frm: Tform); { D5 }
  Function Setscreenresolution(Width, Height: Integer): Longint; { D6 }

  Function Capturescreen: Tbitmap; { D8 }
  Function Getmanifest(Const Filename: String): Ansistring; { D9 }
  Function Getmenufontheight: Integer; { D10 }
  Function Getmenufontsize: Integer;
  Procedure Setmenufontsize(Fontsize: Integer);
  { ... }
  Procedure Winabout(Const Appname, Stuff: String); { E1 }
  Function Unzipfile(Archivename, Path: String): Boolean; { E2 }
  Function Zipfile(Archivename, Filename: String): Boolean; { E3 }
  { ... }
  Procedure Stringtofont(Sfont: String; Font: Tfont);
  Function Fonttostring(Font: Tfont): String;
  Function Computername(): String;
  Function Username(): String;
  Function Getip: String;
  Function Getlocalip: String;
  { ... }
  Function Rot13(Astr: String): String;
  Function Rot47(Const S: String): String;
  Function Stringtohex(S: String): String;
  Function Hextostring(H: String): String;
  Function Endecrypt(Const Value: String): String;
  Function Stringtohex_(Const Astring: String): String;
  Function Hextostring_(Const Aencodedstring: String): String;
  Procedure Setnumlockon;
  { ... }
  PROCEDURE CalculDate(FromDate, ToDate: TDateTime; VAR Years, Months, Days: Integer);
  Function EnLettres(N:Integer):String;

  { --------------------------------------------------------------------------- }
  PROCEDURE CalculDate(FromDate, ToDate: TDateTime; VAR Years, Months, Days: Integer);
  VAR
  FromY, FromM, FromD, // from date
  ToY, ToM, ToD: Word; // to date
  TmpDate: TDateTime;
  PreviousMonth: Byte;
  DaysInMonth: Byte;
  BEGIN
  DecodeDate(ToDate, ToY, ToM, ToD);
  DecodeDate(FromDate, FromY, FromM, FromD);
  Years := ToY - FromY;
  Months := ToM - FromM;
  Days := ToD - FromD;
  IF Days < 0 THEN
  BEGIN
  Dec(Months);
  PreviousMonth := ToM + (Byte(ToM = 1) * 12) - 1;
  CASE PreviousMonth OF
  1, 3, 5, 7, 8, 10, 12:
  DaysInMonth := 31;
  4, 6, 9, 11:
  DaysInMonth := 30;
  ELSE
  DaysInMonth := 28 + Byte(IsLeapYear(ToY));
  END;
  Days := DaysInMonth - Abs(Days);
  END;
  IF Months < 0 THEN
  BEGIN
  Dec(Years);
  Months := 12 - Abs(Months);
  END;
  END;



  { --------------------------------------------------------------------------- }



  Procedure Setnumlockon;
  Var
  Keystate: Tkeyboardstate;
  Begin
  Getkeyboardstate(Keystate);
  If Getkeystate(Vk_Numlock) = 0 Then
  Begin
  Keystate[Vk_Numlock] := 1;
  Setkeyboardstate(Keystate);
  End;
  End;
  { ---------------------------------------------------------------------------- }
  { Cherche Syle File   Style }
  { ---------------------------------------------------------------------------- }
  Function Cherchesylefile: Boolean;
  Var
  Searchresults: Tsearchrec;
  Searchdir: String;
  Fini: Tinifile;
  Stliststyle: Tstringlist;
  Begin
  Searchdir := Extractfilepath(Paramstr(0)) + 'Si_Thèmes' + Pathdelim;
  If Not Directoryexists(Searchdir)  Then
  Begin
  Createdir(Extractfilepath(Paramstr(0)) + 'Si_Thèmes');
  Createdir(Extractfilepath(Paramstr(0)) + 'Data');
  Try
  // Création D'un Nouveaux Dossier Pour Un Styles Par Défaut
  Fini := Tinifile.Create(Extractfilepath(Application.Exename) +
  'Data\Lcdata.Ini');
  Finally
  Fini.Writestring('Styles', 'Style', Tstylemanager.Activestyle.Name);
  End;
  End
  Else
  Try
  If Findfirst(Searchdir + '*.*', Faanyfile - Fadirectory,
  Searchresults) = 0 Then
  Repeat
  Try
  If Tstylemanager.Isvalidstyle(Searchdir + Searchresults.Name)
  = True Then
  Tstylemanager.Loadfromfile(Searchdir + Searchresults.Name);
  Except
  // Who Cares.. Try The Next One.
  Showmessage('Certain Fichier N’Ont Pas Été Chargé');
  End;
  Until Findnext(Searchresults) <> 0;
  Stliststyle := Tstringlist.Create;
  Stliststyle.Duplicates := Tduplicates.Dupignore;
  Stliststyle.Sorted := True;
  Finally
  Fini.Free;
  //  Stliststyle.Free;
  End;
  End; { ----------------------------------------------------------------------- }
  { ---------------------------------------------------------------------------- }
  { Syle File To Listebox   Style }
  { ---------------------------------------------------------------------------- }
  Function Styletolist(Cbox_Sty: Tlistbox): Boolean;
  Var
  Style_Count: String;
  Stliststyle: Tstringlist;
  Begin
  For Style_Count In Tstylemanager.Stylenames Do
  Stliststyle.Add(Style_Count);
  Cbox_Sty.Items.Beginupdate;
  Try
  Cbox_Sty.Items.Clear;
  For Style_Count In Stliststyle Do
  Cbox_Sty.Items.Add(Style_Count);
  // Combobox1.Sorted := True;
  { Select The Style That's Currently In Use In The Combobox }
  Cbox_Sty.Itemindex := Cbox_Sty.Items.Indexof
  (Tstylemanager.Activestyle.Name);
  Finally
  Cbox_Sty.Items.Endupdate;
  End;
  End; { ----------------------------------------------------------------------- }
  { **************************************************************************** }
  { **************************************************************************** }
  Function Set_Longmonth(Mchiffre: Integer; Src2: String): String;
  { --------- A1 }
  Const
  Tmois: Array [1 .. 12] Of String = ('Janvier', 'Fevrier', 'Mars', 'Avril',
  'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre',
  'Décembre');
  Var
  I: Integer;
  Begin
  For I := 1 To 12 Do
  Begin
  If Mchiffre = I Then
  Result := Tmois[I] + Src2;
  End;
  End; { ---------------------------------------------------------------------- A1 }
  { **************************************************************************** }
  Function Get_Month(Sources, Destination: String): String;
  { ------------------ A2 }
  Var
  Incr: Integer;
  Begin
  Destination := '';
  Incr := Strtoint(Sources);
  Case Incr Of
  1: //
  Result := 'Janvier ' + Destination;
  2: //
  Result := 'Fevrier ' + Destination;
  3: //
  Result := 'Mars ' + Destination;
  4: //
  Result := 'Avril ' + Destination;
  5: //
  Result := 'Mai ' + Destination;
  6: //
  Result := 'Juin ' + Destination;
  7: //
  Result := 'Juillet ' + Destination;
  8: //
  Result := 'Août ' + Destination;
  9: //
  Result := 'Septembre ' + Destination;
  10: //
  Result := 'Octobre ' + Destination;
  11: //
  Result := 'Novembre ' + Destination;
  12: //
  Result := 'Décembre ' + Destination;
  End;
  End; { --------------------------------------------------------------------- A2 }
  Function Get_Customonth(Sources, Destination: String): String;
  { ------------------ A2 }
  Var
  Incr: Integer;
  Begin
  Destination := '';
  Incr := Strtoint(Sources);
  Case Incr Of
  1: //
  Result := 'Janv ' + Destination;
  2: //
  Result := 'Fev ' + Destination;
  3: //
  Result := 'Mars ' + Destination;
  4: //
  Result := 'Avr ' + Destination;
  5: //
  Result := 'Mai ' + Destination;
  6: //
  Result := 'Juin ' + Destination;
  7: //
  Result := 'Juil ' + Destination;
  8: //
  Result := 'Août ' + Destination;
  9: //
  Result := 'Sept ' + Destination;
  10: //
  Result := 'Oct ' + Destination;
  11: //
  Result := 'Nov ' + Destination;
  12: //
  Result := 'Déc ' + Destination;
  End;
  End; { --------------------------------------------------------------------- A2 }
  { **************************************************************************** }
  Function Get_Months(Sources, Destination: String): String;
  { ---------------- A3 }
  Var
  Incr: Integer;
  Begin
  Destination := '';
  Incr := Strtoint(Sources);
  Case Incr Of
  01: //
  Result := 'Janvier ' + Destination;
  02: //
  Result := 'Fevrier ' + Destination;
  03: //
  Result := 'Mars ' + Destination;
  04: //
  Result := 'Avril ' + Destination;
  05: //
  Result := 'Mai ' + Destination;
  06: //
  Result := 'Juin ' + Destination;
  07: //
  Result := 'Juillet ' + Destination;
  08: //
  Result := 'Août ' + Destination;
  09: //
  Result := 'Septembre ' + Destination;
  10: //
  Result := 'Octobre ' + Destination;
  11: //
  Result := 'Novembre ' + Destination;
  12: //
  Result := 'Décembre ' + Destination;
  End;
  End; { --------------------------------------------------------------------- A3 }
  { **************************************************************************** }
  Function Set_Month(Mchiffre: Integer; Src2: String): String;
  { --------------- A4 }
  Const
  Tmois: Array [1 .. 12] Of String = ('Janv', 'Fev', 'Mars', 'Avr', 'Mai',
  'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc');
  Var
  I: Integer;
  Begin
  For I := 1 To 12 Do
  Begin
  If Mchiffre = I Then
  Result := Tmois[I] + '-' + Src2;
  End;
  End; { --------------------------------------------------------------------- A4 }
  { **************************************************************************** }
  Function Set_Quarter(Sources_Mois: String): String; { --------------------- A5 }
  Var
  Incr1: Integer;
  Begin
  Incr1 := Strtoint(Sources_Mois);
  Case Incr1 Of
  1, 2, 3: //
  Result := 'T1'; // +'-'Rightstr(Destannées,2);
  4, 5, 6: //
  Result := 'T2'; // +'-'Rightstr(Destannées,2);
  7, 8, 9: //
  Result := 'T3'; // +'-'Rightstr(Destannées,2);
  10, 11, 12: //
  Result := 'T4'; // +'-'Rightstr(Destannées,2);
  End;
  End; { --------------------------------------------------------------------- A5 }
  { **************************************************************************** }
  { **************************************************************************** }
  Function Addvide(Const Source: String; Len: Integer): String;
  { ------------ A7 }
  Var
  I: Integer;
  Begin
  Result := Source;
  For I := 1 To (Len - Length(Source)) Do
  Result := '  ' + Result;
  End; { --------------------------------------------------------------------- A7 }
  Function Addvide2(Const Source: String; Len: Integer): String;
  { ------------ A7 }
  Var
  I: Integer;
  Begin
  Result := Source;
  For I := 1 To (Len - Length(Source)) Do
  Result := Result + '  ';
  End; { --------------------------------------------------------------------- A7 }
  { **************************************************************************** }
  Function Calcirg(Simposabl: Currency; Base: Integer): Real;
  { -------------- A8 }
  Var
  Irg: Currency;
  Begin
  Irg := 0;
  If Simposabl <= 15000 Then
  Irg := 0
  Else If Simposabl >= 120010 Then
  Irg := (Simposabl - 120000) / 10 * 3.5 + 29500
  Else If Simposabl >= 30010 Then
  Irg := (Simposabl - 30000) / 10 * 3 + 2500
  Else If Simposabl >= 28760 Then
  Irg := (Simposabl - 28750) / 10 * 2 + 2250
  Else If Simposabl >= 22510 Then
  Irg := (Simposabl - 22500) / 10 * 1.2 + 1500
  Else If Simposabl >= 15010 Then
  Irg := (Simposabl - 15000) / 10 * 2;
  Irg := (Irg * Base) / 30;
  Result := Irg;
  // Result:=Floattostrf(Irg,Ffcurrency,8,2);
  // Result:=Formatfloat('0.00',Irg);
  End; { --------------------------------------------------------------------- A8 }
  { *                                                                          * }
  { *                                                                        B * }
  { *                                                                          * }

  { *                                                                          * }
  Function Inverssortfunc(List: Tstringlist; Index1, Index2: Integer)
  : Integer; { B2 }
  Var
  I1, I2: Integer;
  Begin
  I1 := Strtoint(List[Index1]);
  I2 := Strtoint(List[Index2]);
  If I1 > I2 Then
  Result := -1
  Else If I1 < I2 Then
  Result := 1
  Else
  Result := 0;
  End; { --------------------------------------------------------------------- B2 }
  { *                                                                          * }
  Function Inputcombo(Const Acaption, Aprompt: String; Const Alist: Tstrings)
  : String; { B3 }
  Function Getcharsize(Canvas: Tcanvas): Tpoint;
  Var
  I: Integer;
  Buffer: Array [0 .. 51] Of Char;
  Begin
  For I := 0 To 25 Do
  Buffer[I] := Chr(I + Ord('A'));
  For I := 0 To 25 Do
  Buffer[I + 26] := Chr(I + Ord('A'));
  Gettextextentpoint(Canvas.Handle, Buffer, 52, Tsize(Result));
  Result.X := Result.X Div 52;
  End;
  Var
  Form: Tform;
  Prompt: Tlabel;
  Combo: Tcombobox;
  Dialogunits: Tpoint;
  Buttontop, Buttonwidth, Buttonheight: Integer;
  Begin
  Result := '';
  Form := Tform.Create(Application);
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
  Combo := Tcombobox.Create(Form);
  With Combo Do
  Begin
  Parent := Form;
  Style := Csdropdownlist;
  // Utiliser Pour La Saisie En Combo
  // Pour La Possibilité De Saisie Dans Les Utilisations Combinées
  // Style: = Csdropdown;
  Items.Assign(Alist);
  Itemindex := 0;
  Left := Prompt.Left;
  Top := Prompt.Top + Prompt.Height + 5;
  Width := Muldiv(164, Dialogunits.X, 4);
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
  Result := Combo.Text;
  End;
  Finally
  Form.Free;
  End;
  End; { --------------------------------------------------------------------- B3 }
  { *                                                                          * }
  Procedure Setitemindex(Ix: Integer; Cb: Tcombobox);
  { ---------------------- B4 }
  Var
  Original: Tnotifyevent;
  Begin
  Original := Cb.Onchange;
  Cb.Onchange := Nil;
  Try
  Cb.Itemindex := Ix;
  Finally
  Cb.Onchange := Original;
  End;
  End; { --------------------------------------------------------------------- B4 }
  { **************************************************************************** }
  { Db = Path To Access Database   ------------------------------------------- }
  { *                                                                          * }
  Procedure Requete(Adocon: Tadoconnection; Sqltxt: String;
  Msgshow: Boolean); { C1 }
  Begin
  If Adocon.Connected = True Then
  Begin
  { Création D'un Tadoquery À La Volée }
  With Tadoquery.Create(Nil) Do
  Begin
  Try
  { Adoconnection1 Est Un Tadoconnection Connecté
  Sur La Base Dans Laquelle Se Trouve La Table Salaries_Encour }
  Connection := Adocon; // Adocon: Tadoconnection
  Sql.Text := Sqltxt; // Sqltxt:String
  Prepared := True;
  { Execsql Renvoie Le Nombre De Lignes Suppimées, On Peut L'utiliser
  Pour Afficher Un Message }
  Execsql;
  Except
  On E: Exception Do
  { Renvoie Le Message D'erreur }
  Messagedlg(E.Message, Mterror, [Mbok], 0);
  End;
  { Libère Le Tadoquery }
  Free;
  If Msgshow = True Then
  Showmessage('Opération Terminé');
  End;
  End;
  End; { --------------------------------------------------------------------- C1 }
  { *                                                                          * }
  Procedure Doincrementalfilter(Dataset: Tdataset;
  Const Fieldname, Searchterm: String); { C2 }
  Begin
  Dataset.Disablecontrols;
  Try
  Assert(Assigned(Dataset), 'No Dataset Is Assigned');
  If Searchterm = '' Then
  Dataset.Filtered := False
  Else
  Begin
  Dataset.Filter := Fieldname + ' Like ' + Quotedstr(Searchterm + '*');
  Dataset.Filtered := True;
  End;
  Finally
  Dataset.Enablecontrols;
  End;
  End; { --------------------------------------------------------------------- C2 }
  { *                                                                          * }
  Procedure Doincrementalfiltercontient(Dataset: Tdataset;
  Const Fieldname, Searchterm: String); { C3 }
  Begin
  Dataset.Disablecontrols;
  Try
  Assert(Assigned(Dataset), 'No Dataset Is Assigned');
  If Searchterm = '' Then
  Dataset.Filtered := False
  Else
  Begin
  Dataset.Filter := Fieldname + ' Like ' +
  Quotedstr('%' + Searchterm + '%');
  Dataset.Filtered := True;
  End;
  Finally
  Dataset.Enablecontrols;
  End;
  End; { --------------------------------------------------------------------- C3 }
  { *                                                                          * }
  Function Compactandrepair(Db: String): Boolean; { ------------------------- C4 }
  Var
  V: Olevariant;
  Begin
  Result := True;
  Try
  V := Createoleobject('Jro.Jetengine');
  Try
  V.Compactdatabase('Provider=Microsoft.Jet.Oledb.4.0;Data Source=' + Db,
  'Provider=Microsoft.Jet.Oledb.4.0;Data Source=' + Db +
  'X;Jet Oledb:Engine Type=5');
  Deletefile(Db);
  Renamefile(Db + 'X', Db);
  Finally
  V := Unassigned;
  End;
  Except
  Result := False;
  End;
  End; { --------------------------------------------------------------------- C4 }
  { *                                                                          * }
  Function Getfilelastaccesstime(Sfilename: String): Tdatetime;
  { ---------------C5 }
  Var
  Ffd: Twin32finddata;
  Dft: Dword;
  Lft: Tfiletime;
  H: Thandle;
  Begin
  // Get File Information
  H := Windows.Findfirstfile(Pchar(Sfilename), Ffd);
  If (Invalid_Handle_Value <> H) Then
  Begin
  // We're Looking For Just One File, So Close Our "Find"
  Windows.Findclose(H);
  // Convert The Filetime To Local Filetime
  Filetimetolocalfiletime(Ffd.Ftlastaccesstime, Lft);
  // Convert Filetime To Dos Time
  Filetimetodosdatetime(Lft, Longrec(Dft).Hi, Longrec(Dft).Lo);
  // Finally, Convert Dos Time To Tdatetime For Use In Delphi's
  // Native Date/Time Functions
  Result := Filedatetodatetime(Dft);
  End;
  End; { --------------------------------------------------------------------- C5 }
  { *                                                                          * }
  Procedure Liste_Msg(Msgdbrid: Tdbgrid);
  { ---------------------------------- C6 }
  Var
  Cbox: Tcheckbox;
  Proprietes: Tform;
  I: Integer;
  X: Integer;
  Begin
  X := 40;
  // Creer Des Zones De Texte// Cbox:=Tcheckbox.Create(Nil);//1  Double ?
  // Creer La Boitte De Dialog
  Proprietes := Createmessagedialog('Spécifiez Les Proprietés De Votre État   '
  + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 +
  #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13 + #13, Mtinformation,
  [Mbyes, Mbcancel]);
  // Modifier Les Propri?T?S De La Boitte De Dialog
  With Proprietes Do
  Try
  For I := 0 To Msgdbrid.Columns.Count - 1 Do
  Begin // Incremonter La Valeur Top
  X := X + 20; // Creer Checkbox
  Cbox := Tcheckbox.Create(Nil); // Verifier Si Le Champs N'est Pas Vide
  If Msgdbrid.Columns.Items[I].Fieldname <> '' Then
  Begin
  Cbox.Caption := Msgdbrid.Columns.Items[I].Title.Caption;
  // Dbgrid.Columns.Items[I].Fieldname; // Déffinir Les Parametres
  Cbox.Parent := Proprietes;
  Cbox.Left := 50;
  Cbox.Top := X;
  Cbox.Width := 200;
  Cbox.Checked := True;
  End;
  End; // Modifier Les Paramétres De Chaque Composant Checkbox
  If (Showmodal = Id_Yes) Then
  Begin // Couche = Colonne Visible Et Contraire
  For I := 0 To Controlcount - 1 Do
  Begin
  // Si Le Composant Est Un Checkbox
  If Controls[I] Is Tcheckbox Then
  // Mettre La Valeur Visible Selon La Propriété De Checkbox Correspond
  Msgdbrid.Columns.Items[I - 4].Visible :=
  (Controls[I] As Tcheckbox).Checked;
  End;
  End;
  Finally // Lib?Eer La Fiche Cree
  Proprietes.Free;
  End;
  End; { --------------------------------------------------------------------- C6 }
  { *                                                                          * }
  Procedure Changedbnavimage(Dbnav: Tdbnavigator);
  { ------------------------- C7 }
  Var
  I: Integer;
  Tempglyph: Tbitmap;
  Exepath: String;
  Begin
  Exepath := Extractfilepath(Application.Exename);
  Tempglyph := Tbitmap.Create;
  Try
  With Dbnav Do
  Begin
  For I := 0 To Controlcount - 1 Do
  Begin
  If Controls[I].Classname = 'Tnavbutton' Then
  Begin
  Case Tnavbutton(Controls[I]).Index Of
  0: //
  Tempglyph.Loadfromfile(Exepath + 'First.Bmp');
  1: //
  Tempglyph.Loadfromfile(Exepath + 'Previous.Bmp');
  2: //
  Tempglyph.Loadfromfile(Exepath + 'Next.Bmp');
  3: //
  Tempglyph.Loadfromfile(Exepath + 'Last.Bmp');
  4: //
  Tempglyph.Loadfromfile(Exepath + 'Insert.Bmp');
  5: //
  Tempglyph.Loadfromfile(Exepath + 'Delete.Bmp');
  6: //
  Tempglyph.Loadfromfile(Exepath + 'Edit.Bmp');
  7: //
  Tempglyph.Loadfromfile(Exepath + 'Post.Bmp');
  8: //
  Tempglyph.Loadfromfile(Exepath + 'Cancel.Bmp');
  9: //
  Tempglyph.Loadfromfile(Exepath + 'Refresh.Bmp');
  End;
  Tnavbutton(Controls[I]).Glyph := Tempglyph;
  End;
  End;
  End;
  Finally
  Tempglyph.Free;
  End;
  End; { --------------------------------------------------------------------- C7 }
  { *                                                                          * }
  { ************** Select All Fields In A Tdbgrid ****************************** }
  Function Gridselectall(Grid: Tdbgrid): Longint;
  { -------------------------- C8 }
  Begin
  Result := 0;
  Grid.Selectedrows.Clear;
  With Grid.Datasource.Dataset Do
  Begin
  First;
  Disablecontrols;
  Try
  While Not Eof Do
  Begin
  Grid.Selectedrows.Currentrowselected := True;
  Inc(Result);
  Next;
  End;
  Finally
  Enablecontrols;
  End;
  End;
  End; { --------------------------------------------------------------------- C8 }
  { *                                                                          * }
  Function Getadoversion: Double;
  Var
  Ado: Olevariant;
  Begin
  Try
  Ado := Createoleobject('Adodb.Connection');
  Result := Strtofloat(Ado.Version);
  Ado := Null;
  Except
  Result := 0.0;
  End;
  End; { --------------------------------------------------------------------- C9 }
  { Détecte  Qu'une Tadoconnection A Perdu La Communication Avec Le Serveur? }
  Procedure Applicationevents1exception(Adoconnection: Tadoconnection;
  E: Exception);
  Var
  Eo: Eoleexception;
  Begin
  If E Is Eoleexception Then
  Begin
  Eo := Eoleexception(E);
  // Connection Error (Disconnected)
  If Eo.Errorcode = E_Fail Then
  Begin
  Try
  Try
  Adoconnection.Close;
  Except
  ;
  End;
  Adoconnection.Open;
  Showmessage
  ('La Connexion À La Base De Données A Échoué Et A Été Rétablie. Veuillez Réessayer.!');
  Except
  On E: Exception Do
  Showmessagefmt
  ('La Connexion À La Base De Données A Échoué Définitivement.  ' +
  'Veuillez Réessayer Ultérieurement'#13'Message D''Erreur: %S',
  [E.Message]);
  End;
  End
  Else
  Showmessage(E.Message + ' ' + Inttostr(Eo.Errorcode));
  End
  Else
  Showmessage(E.Classname + #13 + E.Message);
  End; { --------------------------------------------------------------------- C10 }
  { *                                                                          * }
  Procedure Fieldtstringlist(Dataset: Tadodataset;
  Fieldufirstname, Fieldulastname: String; Stringlist: Tstringlist);
  Var
  Fieldfirst: Tfield;
  Fieldlast: Tfield;
  Begin
  Fieldfirst := Dataset.Fieldbyname(Fieldufirstname);
  Fieldlast := Dataset.Fieldbyname(Fieldulastname);
  Stringlist.Beginupdate;
  Try
  Dataset.Disablecontrols;
  Try
  Dataset.First;
  While Not Dataset.Eof Do
  Begin
  Stringlist.Add(Fieldfirst.Asstring + ' ' + Fieldlast.Asstring);
  Dataset.Next;
  End;
  Finally
  Dataset.Enablecontrols;
  End;
  Finally
  Stringlist.Endupdate;
  End;
  End; { --------------------------------------------------------------------- C11 }
  { *                                                                          * }
  Procedure Field_Tstringlist(Dataset: Tadodataset;
  Firstfield: String; Stringlist: Tstringlist);
  Var
  Fieldfirst: Tfield;
  Fieldlast: Tfield;
  Begin
  Fieldfirst := Dataset.Fieldbyname(Firstfield);
  //Fieldlast := Dataset.Fieldbyname(Fieldulastname);
  Stringlist.Beginupdate;
  Try
  Dataset.Disablecontrols;
  Try
  Dataset.First;
  While Not Dataset.Eof Do
  Begin
  Stringlist.Add(Fieldfirst.Asstring);
  Dataset.Next;
  End;
  Finally
  Dataset.Enablecontrols;
  End;
  Finally
  Stringlist.Endupdate;
  End;
  End; { --------------------------------------------------------------------- C11 }
  { *                                                                          * }
  Function Getcreatetable(Dataset: Tdataset): Tstrings;
  Var
  I: Integer;
  Str: String;
  Begin
  Result := Tstringlist.Create;
  Try
  For I := 0 To Dataset.Fieldcount - 1 Do
  Begin
  With Dataset.Fields[I] Do
  Begin
  Str := '   ' + Dataset.Fields[I].Fieldname + '    ' +
  Getfieldtypename(Datatype);
  // If Datatype = Ftstring Then
  Str := Str + '    (    ' + Inttostr(Size) + '    )    ';
  If Required Then
  Str := Str + '    Not    ';
  Str := Str + '    Null    ';
  End;
  If (I <> Dataset.Fieldcount - 1) Then
  Str := Str + ',';
  Result.Add(Str);
  End;
  Except
  Result.Free;
  Result := Nil;
  End;
  End; { --------------------------------------------------------------------- C12a }
  Function Getfieldtypename(Atype: Tfieldtype): String;
  Const
  Fieldtypes: Array [Tfieldtype] Of Pchar = ('?Unknown?', 'Char', 'Smallint',
  'Integer', 'Word', 'Boolean', 'Float', 'Currency', 'Bcd', 'Date', 'Time',
  'Datetime', 'Bytes', 'Varbytes', 'Autoinc', 'Blob', 'Memo', 'Graphic',
  'Blob', 'Blob', 'Blob', 'Blob', 'Cursor', 'Fixedchar', 'Widestring',
  'Largeint', 'Adt', 'Array', 'Reference', 'Dataset', 'Orablob', 'Oraclob',
  'Variant', 'Interface', 'Idispatch', 'Guid', '', '', '', '', '', '', '', '',
  '', '', '', '', '', '', '', '');
  Begin
  If Atype < Low(Fieldtypes) Then
  Atype := Low(Fieldtypes)
  Else If Atype > High(Fieldtypes) Then
  Atype := Low(Fieldtypes);
  Result := Uppercase(Strpas(Fieldtypes[Atype]));
  End; { --------------------------------------------------------------------- C12b }
  { **************************************************************************** }
  { **************************************************************************** }
  { ---------------------------------------------------------------------------- }
  { **************************************************************************** }
  { **************************************************************************** }
  Function Getdesktopfolder: String;
  { --------------------------------------- D1 }
  Var
  Pidlist: Pitemidlist;
  Buffer: Array [0 .. Max_Path - 1] Of Char;
  Begin
  Result := '';
  Shgetspecialfolderlocation(Application.Handle, Csidl_Desktop, Pidlist);
  If Assigned(Pidlist) Then
  If Shgetpathfromidlist(Pidlist, Buffer) Then
  Result := Buffer;
  End;
  { *                                                                          * }
  { ****************************/  D1  \**************************************** }
  Function Createdesktopshelllink(Const Targetname: String): Boolean;
  Var
  Iobject: Iunknown;
  Islink: Ishelllink;
  Ipfile: Ipersistfile;
  Pidl: Pitemidlist;
  Linkname: String;
  Infolder: Array [0 .. Max_Path - 1] Of Char;
  Begin
  Result := False;
  Iobject := Createcomobject(Clsid_Shelllink);
  Islink := Iobject As Ishelllink;
  Ipfile := Iobject As Ipersistfile;
  With Islink Do
  Begin
  Setdescription('Ouldkaci.Rabah@Ilasdz.Com ...');
  Setpath(Pchar(Targetname));
  Setworkingdirectory(Pchar(Extractfilepath(Targetname)));
  End;
  Shgetspecialfolderlocation(0, Csidl_Desktopdirectory, Pidl);
  Shgetpathfromidlist(Pidl, Infolder);
  Linkname := Includetrailingbackslash(Getdesktopfolder);
  Linkname := Linkname + Extractfilename(Targetname) + '.Lnk';
  If Not Fileexists(Linkname) Then
  If Ipfile.Save(Pwidechar(Linkname), False) = S_Ok Then
  Result := True;
  // End;
  { Procedure Tform1.Button1click(Sender: Tobject);
  Begin
  If Createdesktopshelllink('C:\Folder\Exefile.Exe') Then
  Showmessage('Link Has Been Created ...');
  End; }
  End; { --------------------------------------------------------------------- D1 }
  { *                                                                          * }
  Procedure Setanimation(Value: Boolean);
  { ---------------------------------- D2 }
  Var
  Info: Tanimationinfo;
  Begin
  Info.Cbsize := Sizeof(Tanimationinfo);
  Bool(Info.Iminanimate) := Value;
  Systemparametersinfo(Spi_Setanimation, Sizeof(Info), @Info, 0);
  End; { --------------------------------------------------------------------- D2 }
  { **************************************************************************** }
  Function Gettaskbarsize: Trect;
  { ------------------------------------------ D3 }
  Begin
  Systemparametersinfo(Spi_Getworkarea, 0, @Result, 0);
  End; { --------------------------------------------------------------------- D3 }
  { *                                                                          * }
  { *                                                                          * }
  Procedure Rescaleform(F: Tscrollingwincontrol);
  { -------------------------- D4 }
  Var
  M, D: Integer;
  Begin
  M := Screen.Width; // Multiplicateur = Définition Actuelle De L'écran
  D := 1280; // 1280 Diviseur       = Définition De L'écran À La Conception
  F.Scaleby(M, D);
  F.Realign;
  F.Width := Screen.Width;
  // F.Height := Screen.Workareaheight;
  F.Height := Gettaskbarsize.Height;
  F.Top := 0;
  F.Left := 0;
  End; { --------------------------------------------------------------------- D4 }
  { *                                                                          * }
  { *                                                                          * }
  Var { D5    ----------------------------------------------------------------- }
  Originalbounds: Trect;
  Originalwindowstate: Twindowstate;
  Screenbounds: Trect;
  Procedure Switchfullscreen(Frm: Tform);
  { ---------------------------------- D5 }
  Begin
  If Frm.Borderstyle <> Bsnone Then
  Begin
  // To Full Screen
  Originalwindowstate := Frm.Windowstate;
  Originalbounds := Frm.Boundsrect;
  Frm.Borderstyle := Bsnone;
  Screenbounds := Screen.Monitorfromwindow(Frm.Handle).Boundsrect;
  With Screenbounds Do
  Frm.Setbounds(Frm.Left, Frm.Top, Right - Frm.Left, Bottom - Frm.Top);
  End
  Else
  Begin
  // From Full Screen
  {$Ifdef Mswindows}
  Frm.Borderstyle := Bssizeable;
  {$Endif}
  If Originalwindowstate = Wsmaximized Then
  Frm.Windowstate := Wsmaximized
  Else
  With Originalbounds Do
  Frm.Setbounds(Frm.Left, Frm.Top, Right - Frm.Left, Bottom - Frm.Top);
  {$Ifdef Linux}
  Borderstyle := Bssizeable;
  {$Endif}
  End;
  End; { -------------------------------------------------------------------- D5 }
  { *                                                                          * }
  Function Setscreenresolution(Width, Height: Integer): Longint;
  { ----------- D6 }
  Var
  Devicemode: Tdevicemode;
  Begin
  With Devicemode Do
  Begin
  Dmsize := Sizeof(Tdevicemode);
  Dmpelswidth := Width;
  Dmpelsheight := Height;
  Dmfields := Dm_Pelswidth Or Dm_Pelsheight;
  End;
  Result := Changedisplaysettings(Devicemode, Cds_Updateregistry);
  End; { -------------------------------------------------------------------- D6 }
  { *                                                                          * }

  { *                                                                          * }
  Function Capturescreen: Tbitmap;
  { ----------------------------------------- D8 }
  Var
  Dc: Hdc;
  Bmp: Tbitmap;
  Cv: Tcanvas;
  Begin
  Bmp := Tbitmap.Create;
  Bmp.Width := Screen.Width;
  Bmp.Height := Screen.Height;
  Dc := Getdc(0);
  Cv := Tcanvas.Create;
  Cv.Handle := Dc;
  Bmp.Canvas.Copyrect(Rect(0, 0, Screen.Width, Screen.Height), Cv,
  Rect(0, 0, Screen.Width, Screen.Height));
  Result := Bmp;
  Cv.Free;
  Releasedc(0, Dc);
  End; { -------------------------------------------------------------------- D8 }
  { *                                                                          * }
  Function Getmanifest(Const Filename: String): Ansistring;
  { ---------------- D9 }
  Var
  Hmodule: Thandle;
  Resource: Tresourcestream;
  Begin
  Result := '';
  // Load The File To Read
  Hmodule := Loadlibraryex(Pchar(Filename), 0, Load_Library_As_Datafile);
  Try
  If Hmodule = 0 Then
  Raiselastoserror;
  // Check If Exist The Manifest Inside Of The File
  If Findresource(Hmodule, Makeintresource(1), Rt_Manifest) <> 0 Then
  Begin
  // Load The Resource
  Resource := Tresourcestream.Createfromid(Hmodule, 1, Rt_Manifest);
  Try
  Setstring(Result, Pansichar(Resource.Memory), Resource.Size);
  Finally
  Resource.Free;
  End;
  End;
  Finally
  Freelibrary(Hmodule);
  End;
  End; { -------------------------------------------------------------------- D9 }
  { *                                                                          * }
  Function Getmenufontheight: Integer;
  { ------------------------------------ D10 }
  Var
  Dc: Hdc;
  Saveobj: Hgdiobj;
  Size: Tsize;
  Begin
  Dc := Getdc(Hwnd_Desktop);
  Try
  Saveobj := Selectobject(Dc, Screen.Menufont.Handle);
  Gettextextentpoint32(Dc, '|', 1, Size);
  // The Character Doesn't Really Matter
  Result := Size.Cy;
  Selectobject(Dc, Saveobj);
  Finally
  Releasedc(Hwnd_Desktop, Dc);
  End;
  End; { ------------------------------------------------------------------- D10 }
  { *                                                                          * }
  { Returns Menu Font Size }
  Function Getmenufontsize: Integer;
  Var
  Ncm: Tnonclientmetrics;
  Pixelsperinch: Integer;
  Begin
  Ncm.Cbsize := Sizeof(Tnonclientmetrics);
  Systemparametersinfo(Spi_Getnonclientmetrics, Sizeof(Nonclientmetrics), @Ncm,
  Spif_Updateinifile);
  Pixelsperinch := Getdevicecaps(Getdc(0), Logpixelsy);
  Result := -Muldiv(Ncm.Lfmenufont.Lfheight, 72, Pixelsperinch);
  End;
  { *                                                                          * }
  { Set Menu Font Size }
  Procedure Setmenufontsize(Fontsize: Integer);
  Var
  Ncm: Tnonclientmetrics;
  Pixelsperinch: Integer;
  Begin
  Ncm.Cbsize := Sizeof(Tnonclientmetrics);
  Systemparametersinfo(Spi_Getnonclientmetrics,
  Sizeof(Nonclientmetrics), @Ncm, 0);
  Pixelsperinch := Getdevicecaps(Getdc(0), Logpixelsy);
  Ncm.Lfmenufont.Lfheight := -Muldiv(Fontsize, Pixelsperinch, 72);
  Systemparametersinfo(Spi_Setnonclientmetrics, Sizeof(Nonclientmetrics), @Ncm,
  Spif_Updateinifile);
  End;
  { *                                                                          * }
  { *                                                                          * }
  { *                                                                          * }
  Procedure Winabout(Const Appname, Stuff: String);
  { ------------------------ E1 }
  Var
  {$Ifdef Ver80}
  Szapp, Szstuff: Array [0 .. 255] Of Char;
  {$Endif}
  Wnd: Hwnd;
  Icon: Hicon;
  Begin
  If Application.Mainform <> Nil Then
  Wnd := Application.Mainform.Handle
  Else
  Wnd := 0;
  Icon := Application.Icon.Handle;
  If Icon = 0 Then
  Icon := Loadicon(0, Idi_Application);
  {$Ifndef Ver80}
  Shellabout(Wnd, Pchar(Appname), Pchar(Stuff), Icon);
  {$Else}
  Strplcopy(Szapp, Appname, Sizeof(Szapp) - 1);
  Strplcopy(Szstuff, Stuff, Sizeof(Szstuff) - 1);
  Shellabout(Wnd, Szapp, Szstuff, Icon);
  {$Endif}
  End; { -------------------------------------------------------------------- E1 }
  { *                                                                          * }
  Function Unzipfile(Archivename, Path: String): Boolean;
  { ------------------ E2 }
  Var
  Zip: Tzipfile;
  Begin
  Zip := Tzipfile.Create;
  Try
  Zip.Open(Archivename, Zmread);
  Zip.Extractall(Path);
  Zip.Close;
  Result := True;
  Except
  Result := False;
  End;
  Zip.Free;
  Showmessage('Restauration Terminée Avec Succes');
  End; { -------------------------------------------------------------------- E2 }
  { *                                                                          * }
  Function Zipfile(Archivename, Filename: String): Boolean;
  { ---------------- E3 }
  Var
  Zip: Tzipfile;
  Begin
  Zip := Tzipfile.Create;
  Try
  If Fileexists(Archivename) Then
  Deletefile(Archivename);
  Zip.Open(Archivename, Zmwrite);
  Zip.Add(Filename);
  Zip.Close;
  Result := True;
  Except
  Result := False;
  End;
  Freeandnil(Zip);
  Showmessage('Sauvegarde Terminée Avec Succes');
  End; { -------------------------------------------------------------------- E3 }
  { *                                                                          * }
  Const
  Csfsbold = '|Bold';
  Csfsitalic = '|Italic';
  Csfsunderline = '|Underline';
  Csfsstrikeout = '|Strikeout';
  //
  // Expected Format: //
  // "Arial", 9, [Bold], [Clred]
  //
  Procedure Stringtofont(Sfont: String; Font: Tfont);
  Var
  P: Integer;
  Sstyle: String;
  Begin
  With Font Do
  Begin
  // Get Font Name
  P := Pos(',', Sfont);
  Name := Copy(Sfont, 2, P - 3);
  Delete(Sfont, 1, P);
  // Get Font Size
  P := Pos(',', Sfont);
  Size := Strtoint(Copy(Sfont, 2, P - 2));
  Delete(Sfont, 1, P);
  // Get Font Style
  P := Pos(',', Sfont);
  Sstyle := '|' + Copy(Sfont, 3, P - 4);
  Delete(Sfont, 1, P);
  // Get Font Color
  Color := Stringtocolor(Copy(Sfont, 3, Length(Sfont) - 3));
  // Convert Str Font Style To
  // Font Style
  Style := [];
  If (Pos(Csfsbold, Sstyle) > 0) Then
  Style := Style + [Fsbold];
  If (Pos(Csfsitalic, Sstyle) > 0) Then
  Style := Style + [Fsitalic];
  If (Pos(Csfsunderline, Sstyle) > 0) Then
  Style := Style + [Fsunderline];
  If (Pos(Csfsstrikeout, Sstyle) > 0) Then
  Style := Style + [Fsstrikeout];
  End;
  End; { ---------------------------------------------------------------------- }
  // Output Format: //
  // "Aril", 9, [Bold|Italic], [Claqua]
  Function Fonttostring(Font: Tfont): String;
  Var
  Sstyle: String;
  Begin
  With Font Do
  Begin
  // Convert Font Style To String
  Sstyle := '';
  If (Fsbold In Style) Then
  Sstyle := Sstyle + Csfsbold;
  If (Fsitalic In Style) Then
  Sstyle := Sstyle + Csfsitalic;
  If (Fsunderline In Style) Then
  Sstyle := Sstyle + Csfsunderline;
  If (Fsstrikeout In Style) Then
  Sstyle := Sstyle + Csfsstrikeout;
  If ((Length(Sstyle) > 0) And ('|' = Sstyle[1])) Then
  Begin
  Sstyle := Copy(Sstyle, 2, Length(Sstyle) - 1);
  End;
  Result := Format('"%S", %D, [%S], [%S]',
  [Name, Size, Sstyle, Colortostring(Color)]);
  End;
  End; { ---------------------------------------------------------------------- }
  { *                                                                          * }
  { * Fonction Trouvant Le Nom De L'ordinateur                                 * }
  { *                                                                          * }
  Function Computername(): String;
  Var
  Mycomputername: Array [0 .. Max_Computername_Length] Of Char;
  Nsize: Dword;
  Begin
  Nsize := Sizeof(Mycomputername);
  Getcomputername(@Mycomputername, Nsize);
  Result := Mycomputername;
  End; { ---------------------------------------------------------------------- }
  { *                                                                          * }
  { * Fonction Trouvant Le Nom De L'utilisateur                                * }
  { *                                                                          * }
  Function Username(): String;
  Const
  Cnmaxusernamelen = 254;
  Var
  Username: String;
  Nsize: Dword;
  Begin
  Nsize := Cnmaxusernamelen - 1;
  Setlength(Username, Cnmaxusernamelen);
  Getusername(Pchar(Username), Nsize);
  Setlength(Username, Nsize - 1);
  Result := Username;
  End; { ---------------------------------------------------------------------- }
  (* Function Getip: String;
  // Winsok
  Begin
  With Tcustomipclient.Create(Nil) Do
  Begin   Result := Localhostaddr;
  Free;  End;
  End; { ----------------------------------------------------------------------  } *)

(*
  Function Getip: String;
  //Idstack
  Begin
  Tidstack.Incusage;
  Try
  Result := Gstack.Localaddress;
  Finally
  Tidstack.Decusage;
  End;
  End; { ---------------------------------------------------------------------- }
  Function Getlocalip: String;
  //Idbasecomponent, Idcomponent, Idipwatch;
  Var
  Ipw: Tidipwatch;
  Begin
  Ipw := Tidipwatch.Create(Nil);
  Try
  If Ipw.Localip <> '' Then
  Result := Ipw.Localip;
  Finally
  Ipw.Free;
  End;
  End; { ---------------------------------------------------------------------- }
  Function Rot13(Astr: String): String;
  Var
  I: Integer;
  C: Char;
  Begin
  For I := 1 To Length(Astr) Do
  Begin
  C := Astr[I];
  If (((C >= 'A') And (C <= 'M')) Or ((C >= 'A') And (C <= 'M'))) Then
  C := Chr(Ord(C) + 13)
  Else If (((C >= 'N') And (C <= 'Z')) Or ((C >= 'N') And (C <= 'Z'))) Then
  C := Chr(Ord(C) - 13);
  Result := Result + C;
  End;
  End; { ---------------------------------------------------------------------- }
  Function Rot47(Const S: String): String;
  Var
  I, J: Integer;
  Begin
  Result := S;
  For I := 1 To Length(S) Do
  Begin
  J := Ord(S[I]);
  If (J In [33 .. 126]) Then
  Begin
  Result[I] := Chr(33 + ((J + 14) Mod 94));
  End;
  End;
  End; { ---------------------------------------------------------------------- }
  { *                                                                          * }
  Function Stringtohex(S: String): String;
  Var
  I: Integer;
  Begin
  Result := '';
  For I := 1 To Length(S) Do
  Result := Result + Inttohex(Ord(S[I]), 2);
  End; { ---------------------------------------------------------------------- }
  Function Hextostring(H: String): String;
  Var
  I: Integer;
  Begin
  Result := '';
  For I := 1 To Length(H) Div 2 Do
  Result := Result + Char(Strtoint('$' + Copy(H, (I - 1) * 2 + 1, 2)));
  End; { ---------------------------------------------------------------------- }
  Function Endecrypt(Const Value: String): String;
  Var
  Charindex: Integer;
  Begin
  Result := Value;
  For Charindex := 1 To Length(Value) Do
  Result[Charindex] := Chr(Not(Ord(Value[Charindex])));
  End; { ---------------------------------------------------------------------- }
  Function Stringtohex_(Const Astring: String): String;
  Var
  Bufsize: Integer;
  Begin
  Bufsize := Length(Astring) * Sizeof(Char);
  Setlength(Result, Bufsize * 2);
  Bintohex(Pointer(Astring), Pchar(Result), Bufsize);
  End; { ---------------------------------------------------------------------- }
  Function Hextostring_(Const Aencodedstring: String): String;
  Var
  Bufsize: Integer;
  Begin
  Bufsize := Length(Aencodedstring) Div 2;
  Setlength(Result, Bufsize Div Sizeof(Char));
  Hextobin(Pchar(Aencodedstring), Pointer(Result), Bufsize);
  End; { ---------------------------------------------------------------------- }



  { ---------------------------------------------------------------------- }
  { ---------------------------------------------------------------------- }
  { ---------------------------------------------------------------------- }

  Function EnLettres(N:Integer):String;
  Const
  Unite: Array[1..16] of String=('un','deux','trois','quatre','cinq','six',
  'sept','huit','neuf','dix','onze','douze',
  'treize','quatorze','quinze','seize');
  Dizaine: Array[2..8] of String=('vingt','trente','quarante','cinquante',
  'soixante','','quatre-vingt');
  Coefs:Array[0..3] of String=('cent','mille','million','milliard');
  Var
  Temp: String;
  C,D,U: Byte;
  Coef: Byte;
  I: Word;
  Neg: Boolean;
  begin
  If N = 0 then
  begin
  Result := ' Zéro';
  Exit;
  end;
  Result := '';
  Neg := N <0;
  If Neg then N := -N;
  Coef := 0;
  Repeat
  U := N mod 10; N := N div 10; {Récupère unité et dizaine}
  D := N mod 10; N := N div 10; {Récupère dizaine}
  If D in [1,7,9] then
  begin
  Dec(D);
  Inc(U, 10);
  end;
  Temp := '';
  If D > 1 then
  begin
  Temp := ' ' + Dizaine[D];
  If (D < 8) and ((U = 1) or (U = 11)) then
  Temp := Temp + ' et';
  end;
  If U > 16 then
  begin
  Temp := Temp + ' ' + Unite[10];
  Dec(U,10);
  end;
  If U > 0 then Temp := Temp + ' ' + Unite[U];
  If (Result = '') and (D = 8) and (U = 0) then Result := 's';
  Result := Temp + Result;
  C := N mod 10; N := N div 10; {Récupère centaine}
  If C > 0 then
  begin
  Temp := '';
  If C > 1 then Temp := ' ' + Unite[C] + Temp;
  Temp := Temp + ' ' + Coefs[0];
  If (Result = '') and (C > 1) then Result := 's';
  Result := Temp + Result;
  end;
  If N > 0 then
  begin
  Inc(Coef);
  I := N mod 1000;
  If (I > 1) and (Coef > 1) then Result := 's' + Result;
  If I > 0 then Result := ' ' + Coefs[Coef] + Result;
  If (I= 1) and (Coef = 1) then Dec(N);
  end;
  until N = 0;
  If Neg then Result := 'Moins' + Result
  else
  Result[2] := UpCase (Result[2]);
  End; { ---------------------------------------------------------------------- }

  End. *)
