unit Convert;

interface

uses
  SysUtils;

Const
  QuoiEntier = 'Dinar algeriens';

Const
  QuoiDecimales = 'Ct'; // 'Centime';

var
  Txt, PartieEntiere, PartieDecimale, TxtEntier: String;
  TxtUnites: array [0 .. 19] of String = (
    '',
    'un',
    'deux',
    'trois',
    'quatre',
    'cinq',
    'six',
    'sept',
    'huit',
    'neuf',
    'dix',
    'onze',
    'douze',
    'treize',
    'quatorze',
    'quinze',
    'seize',
    'dix-sept',
    'dix-huit',
    'dix-neuf'
  );
  TxtDizaines: Array [0 .. 10] of String = (
    '',
    '',
    'vingt',
    'trente',
    'quarante',
    'cinquante',
    'soixante',
    'soixante',
    'quatre-vingt',
    'quatre-vingt',
    'Cent'
  );
  TxtMilliers: Array [0 .. 4] of String = (
    ' ',
    ' ',
    'mille',
    'Million',
    'Milliard'
  );

Procedure Centaine(Valeur: integer);
function NombreTexte(Chiffre: Currency): String;
function iif(a: boolean; b, c: String): String;
function StrRight(s: string; nb: integer): string;
function StrLeft(s: string; nb: integer): string;
function Addzeros_(CONST Source: STRING; Len: integer; Letr: Char): STRING;

implementation

{ ----------------------------------------------- }
FUNCTION Addzeros_(CONST Source: STRING; Len: integer; Letr: Char): STRING;
VAR
  I: integer;
BEGIN
  Result := Source;
  FOR I := 1 TO (Len - Length(Source)) DO
    Result := Letr + Result;
END; { ... }

function iif(a: boolean; b, c: String): String;
begin
  if a then
    iif := b
  else
    iif := c
end;

function StrRight(s: string; nb: integer): string;
begin
  StrRight := iif(nb >= Length(s), s, copy(s, Length(s) - nb + 1, nb));
end;

function StrLeft(s: string; nb: integer): string;
begin
  StrLeft := iif(nb >= Length(s), s, copy(s, 1, nb));
end;

Procedure Centaine(Valeur: integer);
var
  CentaineNb, DizaineNb, UnitesNb: integer;
  Lien: String;
begin
  // Extraction des trois chiffres
  CentaineNb := Valeur div 100;
  DizaineNb := (Valeur - CentaineNb * 100) div 10;
  UnitesNb := Valeur - CentaineNb * 100 - DizaineNb * 10;
  // Pour les valeurs 10 à 19, 70 à 79 et 90 à 99
  If (DizaineNb = 1) Or (DizaineNb = 7) Or (DizaineNb = 9) Then
    UnitesNb := UnitesNb + 10;
  // Le séparateur : -, et ou espace
  Case UnitesNb of
    1:
      Lien := ' et ';
    11:
      If DizaineNb = 7 Then
        Lien := ' et '
      Else
        Lien := '-';
  Else
    Lien := '-';
  end;
  If UnitesNb = 0 Then
    Lien := '';
  If DizaineNb = 1 Then
    Lien := '';

  // Les dizaines en lettres
  If DizaineNb > 0 Then
    Txt := TxtDizaines[DizaineNb] + Lien + TxtUnites[UnitesNb] + ' '
  Else
    Txt := TxtUnites[UnitesNb] + ' ';

  // Les centaines en lettres
  if CentaineNb = 1 then
    Txt := ' cent ' + Txt
  else if CentaineNb > 1 then
    If (DizaineNb > 0) Or (UnitesNb > 0) Then
      Txt := TxtUnites[CentaineNb] + ' Cent ' + Txt
    Else
      Txt := TxtUnites[CentaineNb] + ' Cents' + Txt;
end;

function NombreTexte(Chiffre: Currency): String;
var
  j, I: integer;
  TxtDecimales, Valeur, reel: String;
  TrancheNb: Array [1 .. 5] of String;
begin
  reel := FormatFloat('###0.00', Chiffre);
  PartieEntiere := inttostr(trunc(strtofloat(reel)));
  PartieDecimale :=
    FloatToStr(round((strtofloat(reel) - strToInt64(PartieEntiere)) * 100));
  for I := 1 to 5 do
    TrancheNb[I] := '';
  j := 1;
  While (Length(PartieEntiere) > 0) do
  begin
    TrancheNb[j] := StrRight(PartieEntiere, 3);
    PartieEntiere := StrLeft(PartieEntiere, Length(PartieEntiere) -
      Length(TrancheNb[j]));
    j := j + 1;
  end;
  // ------------>>>>>>>>>> Conversion en texte de chaque tranche de la partie entière
  TxtEntier := '';
  For I := j DownTo 1 do
  begin
    If TrancheNb[I] <> '' Then
    begin
      Centaine(strtoint(TrancheNb[I]));
      If Txt <> ' ' Then
      begin
        if (Txt = 'un ') and (I = 2) then
          Txt := '';
        TxtEntier := TxtEntier + Txt + TxtMilliers[I];
      end;
      // ------------>>>>>>>>>>> Ajout du s à million et milliard
      If (I >= 3) And (Txt <> 'un') And (Txt <> ' ') Then
        TxtEntier := TxtEntier + 's '
      Else
        TxtEntier := TxtEntier + ' ';
    end;
    If StrRight(TxtEntier, 2) = '  ' Then
      TxtEntier := StrLeft(TxtEntier, Length(TxtEntier) - 1);
  end;
  If StrLeft(TxtEntier, 1) = ' ' Then
    TxtEntier := StrRight(TxtEntier, Length(TxtEntier) - 1);

  If (StrRight(TxtEntier, 3) = 'ns ') Or (StrRight(TxtEntier, 3) = 'ds ') Then
    TxtEntier := TxtEntier + 'de ';

  // ----Si le nombre égale zéro
  If (TxtEntier = '  ') Or (TxtEntier = ' ') Or (TxtEntier = '') Then
    TxtEntier := 'zero ';

  // ----Introduction du s à l'unité de mesure si la valeur du nombre dépasse 1,99
  TxtEntier := TxtEntier + QuoiEntier +
    iif(strtoint(iif(Valeur = '', '0', Valeur)) > 1.99, 's', '');

  // ---->>>> Conversion en texte de la partie décimale du nombre
  TxtDecimales := '';
  If PartieDecimale <> '' Then
  begin
    Txt := '';
    // Centaine(strtoint(PartieDecimale));
    if trim(Txt) = '' then
      Txt := Addzeros_(PartieDecimale,2,'0');
    TxtDecimales := ' & ' + Txt + ' ' + QuoiDecimales + iif(Txt <> '', 's', '');
  end;
  TxtEntier[1] := chr(ord(TxtEntier[1]) - 32);
  Result := TxtEntier + TxtDecimales
end;

end.
