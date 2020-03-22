program Javasun;

uses
  Vcl.Forms,
  Java_u in 'Java_u.pas' {Java};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TJava, Java);
  Application.Run;
end.
