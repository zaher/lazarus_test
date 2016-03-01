unit GenericDemo;
{$IFDEF FPC}
{$MODE delphi}
{$ENDIF}
{$M+}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, DateUtils, Types, Contnrs;

type

  { GItems }

  { GDemo }

  GDemo<T{$ifndef FPC}: class{$endif}> = class(TObject)
  private
  public
    procedure DoSomthing(O: T);
  end;

{
  FreePascal:

    TMyG = class(specialize GDemo<TMyObject>)

  Delphi:

    TMyG = class(GDemo<TMyObject>)
}
implementation

{ GDemo }

procedure GDemo<T>.DoSomthing(O: T);
begin
   O.Name := O.Name + ' Tested';
end;

end.
