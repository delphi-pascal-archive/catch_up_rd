program CatchUp;

uses
  Forms,
  Main in 'Main.pas' {FAnim},
  CatchMe in 'CatchMe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFAnim, FAnim);
  Application.Run;
end.
