program Adobe_Reader;

uses
  Vcl.Forms,
  Adobe_u in 'Adobe_u.pas' {Adobe_};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAdobe_, Adobe_);
  Application.Run;
end.
