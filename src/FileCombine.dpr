program FileCombine;

uses
  EMemLeaks,
  Vcl.Forms,
  Form.FileCombineMain in 'Form.FileCombineMain.pas' {FormFileCombineMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'FileCombine v1.0';
  Application.CreateForm(TFormFileCombineMain, FormFileCombineMain);
  Application.Run;
end.
