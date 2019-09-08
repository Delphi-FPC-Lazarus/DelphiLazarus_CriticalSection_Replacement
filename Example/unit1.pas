unit unit1;

interface

uses
  //System.SyncObjs,
  SynObj_unit,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmTest = class(TForm)
    tmrinf: TTimer;
    lblinf1: TLabel;
    lblinf2: TLabel;
    btnStart: TButton;
    btnStop: TButton;
    lblinf3: TLabel;
    lblinf4: TLabel;
    ListBoxLog: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure tmrinfTimer(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

type
  TStresstest = class(TThread)
  private
    fmode:integer;
    fcount1:integer;
    fcount2:integer;
  protected
    procedure Execute; override;
  public
    property mode:integer read fmode write fmode;
    property count1:integer read fcount1 write fcount1;
    property count2:integer read fcount2 write fcount2;
end;

var
  frmTest: TfrmTest;

  fcs:TExtCriticalSection;

  Stresstest1:TStresstest;
  Stresstest2:TStresstest;
  Stresstest3:TStresstest;
  Stresstest4:TStresstest;

implementation

{$R *.dfm}

// ---------------------------------------------------------------------

procedure Test1(DebugID:Cardinal);
begin
  try
    fcs.Enter(DebugID);
    //sleep(1000);
  finally
    fcs.Release;
  end;
end;

procedure Test2(DebugID:Cardinal);
begin
  try
    fcs.Enter(DebugID);
    //sleep(1000);
  finally
    fcs.Release;
  end;
end;

// ---------------------------------------------------------------------

procedure TStresstest.Execute;
begin
  FreeOnTerminate:= false;
  fmode:= 0;
  fcount1:= 0;
  fcount2:= 0;
  while not Terminated do
  begin
    if (fmode > 0) then
    begin
     if fmode = 1 then
     begin
       test1(ThreadID);
       inc(fcount1);
     end;
     if fmode = 2 then
     begin
       test2(ThreadID);
       inc(fcount2);
     end;
     //sleep(1);
    end
    else
    begin
     sleep(10);
    end;
  end;
end;

// ---------------------------------------------------------------------

procedure Log(sLogAdd:String);
begin
  frmTest.ListBoxLog.Items.Add(sLogAdd);
end;

// ---------------------------------------------------------------------

procedure TfrmTest.FormCreate(Sender: TObject);
begin
 Stresstest1:= TStresstest.Create;
 Stresstest2:= TStresstest.Create;
 Stresstest3:= TStresstest.Create;
 Stresstest4:= TStresstest.Create;
end;

procedure TfrmTest.btnStartClick(Sender: TObject);
begin
 Stresstest1.mode:= 1;
 Stresstest2.mode:= 2;
 Stresstest3.mode:= 1;
 Stresstest4.mode:= 2;

 tmrinf.Enabled:= true;
end;

procedure TfrmTest.btnStopClick(Sender: TObject);
begin
 Stresstest1.mode:= 0;
 Stresstest2.mode:= 0;
 Stresstest3.mode:= 0;
 Stresstest4.mode:= 0;
end;

procedure TfrmTest.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 Stresstest1.Terminate;
 Stresstest2.Terminate;
 Stresstest3.Terminate;
 Stresstest4.Terminate;
end;

procedure TfrmTest.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Stresstest1);
  FreeAndNil(Stresstest2);
  FreeAndNil(Stresstest3);
  FreeAndNil(Stresstest4);
end;

procedure TfrmTest.tmrinfTimer(Sender: TObject);
begin
  lblinf1.Caption:= format('%d : %d %d', [Stresstest1.ThreadID, Stresstest1.count1, Stresstest1.count2]);
  lblinf2.Caption:= format('%d : %d %d', [Stresstest2.ThreadID, Stresstest2.count1, Stresstest2.count2]);
  lblinf3.Caption:= format('%d : %d %d', [Stresstest3.ThreadID, Stresstest3.count1, Stresstest3.count2]);
  lblinf4.Caption:= format('%d : %d %d', [Stresstest4.ThreadID, Stresstest4.count1, Stresstest4.count2]);
end;

initialization
  fcs:= TExtCriticalSection.create('Stresstest');
  //fcs.DoLog:= true; // Debuglog (bremst!)
  //fcs.onLog:= Log;  // Debuglog in Echtzeit ausgeben (bremst noch mehr)

finalization
  FreeAndNil(fcs);
end.
