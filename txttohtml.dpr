program txttohtml;

uses
  Forms,
  TTHUnit in 'TTHUnit.pas' {Form1},
  AboutUnit in 'AboutUnit.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
