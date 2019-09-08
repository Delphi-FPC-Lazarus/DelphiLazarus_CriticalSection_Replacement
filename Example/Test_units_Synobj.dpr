program Test_units_Synobj;

//FastMM4 in '..\..\_Share\extern\FastMM\FastMM4.pas',
//FastMM4Messages in '..\..\_Share\extern\FastMM\FastMM4Messages.pas',

uses
  Vcl.Forms,
  unit1 in 'unit1.pas' {frmTest},
  synobj_unit in '..\synobj_unit.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown:= true;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
