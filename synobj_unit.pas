{
  Erweiterte CriticalSection Klasse

  02/2016 XE10 x64 Test
  xx/xxxx FPC Ubuntu

  --------------------------------------------------------------------
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  THE SOFTWARE IS PROVIDED "AS IS" AND WITHOUT WARRANTY

  Author: Peter Lorenz
  Is that code useful for you? Donate!
  Paypal webmaster@peter-ebe.de
  --------------------------------------------------------------------

}

{$I ..\share_settings.inc}

unit synobj_unit;

interface

uses Classes, SyncObjs, SysUtils;

type EventonLog=procedure(sLogAdd:string);

type TExtCriticalSection = class(TObject)
  private
   FCriticalSection:SyncObjs.TCriticalSection;

   fsDebugName:string;

   fbIsActive:Boolean;

   fbLog:Boolean;
   fiLog:integer;
   faLog:array[0..99] of String;
   fonLog:EventonLog;

   procedure _dolog(const sLogAdd:String);
   function _getlog:string;
  public
   constructor Create(const sName:String);
   destructor Destroy; override;

   function TryEnter(DebugID:Cardinal=0):Boolean;
   procedure Enter(DebugID:Cardinal=0);
   procedure Acquire(DebugID:Cardinal=0);

   procedure Leave(DebugID:Cardinal=0);
   procedure Release(DebugID:Cardinal=0);

   property IsActive:Boolean read fbIsActive;

   property onLog:EventonLog read fonLog write fonLog;
   property DoLog:Boolean read fbLog write fbLog;
   property GetLog:String read _getlog;
end;

implementation

// ==========================================================================

constructor TExtCriticalSection.Create(const sName:String);
var i:Integer;
begin
 inherited Create;

 FCriticalSection:= SyncObjs.TCriticalSection.Create;
 fsDebugName:= sName;
 fbIsActive:= false;

 fbLog:= false;
 fiLog:= 0;
 for i:= low(faLog) to high(faLog) do
  faLog[i]:= '';

 fonLog:= nil;
end;

destructor TExtCriticalSection.Destroy;
begin
  FreeAndNil(FCriticalSection);
  inherited;
end;

// ==========================================================================

function TExtCriticalSection.TryEnter(DebugID:Cardinal=0):Boolean;
begin
  // fbActive kann hier durchaus true sein da die Criticalsection aktiv sein kann
  Result:= FCriticalSection.TryEnter;                               // wenn Criticalsection aktiv wird dies übergangen, Result false

  fbIsActive:= Result;                                              // Flag nur innerhalb der criticalsetion setzen!
  if fbLog then
   if result then
    _dolog('TryEnter (done)'+inttohex(DebugID,8))                   // Log
   else
    _dolog('TryEnter (fail)'+inttohex(DebugID,8))                   // Log
end;

procedure TExtCriticalSection.Enter(DebugID:Cardinal=0);
begin
  // fbActive kann hier durchaus true sein da die Criticalsection aktiv sein kann
  if fbLog then _dolog('Enter (request)'+inttohex(DebugID,8));      // Log
  FCriticalSection.Enter;                                           // Enter ruft intern die Methode Acquire auf, wartet auf Freigabe (bei Aufruf aus gleichem Thread wird sofort eine neue Criticalsection aufgemacht)
  assert(not fbIsActive, 'TExtCriticalSection() still active!');

  fbIsActive:= true;                                                // Flag nur innerhalb der criticalsetion setzen!
  if fbLog then _dolog('Enter (done)'+inttohex(DebugID,8));         // Log
end;

procedure TExtCriticalSection.Acquire(DebugID:Cardinal=0);
begin
  // fbActive kann hier durchaus true sein da die Criticalsection aktiv sein kann
  if fbLog then _dolog('Aquire (request)'+inttohex(DebugID,8));     // Log
  FCriticalSection.Acquire;                                         // wartet auf Freigabe (bei Aufruf aus gleichem Thread wird sofort eine neue Criticalsection aufgemacht)
  assert(not fbIsActive, 'TExtCriticalSection() still active!');

  fbIsActive:= true;                                                // Flag nur innerhalb der criticalsetion setzen!
  if fbLog then _dolog('Aquire (done)'+inttohex(DebugID,8));        // Log
end;

// ==========================================================================

procedure TExtCriticalSection.Leave(DebugID:Cardinal=0);
begin
  assert(fbIsActive, 'TExtCriticalSection() not active!');

  fbIsActive:= false;                                               // Flag nur innerhalb der criticalsetion setzen!
  if fbLog then _dolog('Leave'+inttohex(DebugID,8));                // Log

  FCriticalSection.Leave;                                           // Leave ruft intern die Methode Release auf, wartet auf Freigabe

end;

procedure TExtCriticalSection.Release(DebugID:Cardinal=0);
begin
  assert(fbIsActive, 'TExtCriticalSection() not active!');

  fbIsActive:= false;                                               // Flag nur innerhalb der criticalsetion setzen!
  if fbLog then _dolog('Release'+inttohex(DebugID,8));              // Log

  FCriticalSection.Release;
end;

// ==========================================================================

procedure TExtCriticalSection._dolog(const sLogAdd:String);
begin
 faLog[fiLog]:= formatdatetime('hh:nn:ss', time) + '> ' + sLogAdd;
 inc(fiLog);

 if fiLog > high(faLog) then fiLog:= low(faLog);

 if assigned(fonLog) then
  fonLog(sLogAdd);
end;

function TExtCriticalSection._getlog:string;
var i:integer;
    s:string;
begin
  Result:= '';
  s:= '';
  for i:= Low(faLog) to high(faLog) do
  begin
    s:= s + faLog[i] + #13;
  end;
  Result:= s;
end;

// ==========================================================================

end.
