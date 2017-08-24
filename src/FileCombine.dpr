program FileCombine;

uses
  EMemLeaks,
  Vcl.Forms,
  Form.FileCombineMain in 'Form.FileCombineMain.pas' {FormFileCombineMain},
  ListView.EmptyMessage in 'ListView.EmptyMessage.pas',
  Sort.StringCompare in 'Sort.StringCompare.pas',
  Sort.StringList in 'Sort.StringList.pas',
  Sort.ListView in 'Sort.ListView.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'FileCombine v1.0';
  Application.CreateForm(TFormFileCombineMain, FormFileCombineMain);
  Application.Run;
end.
