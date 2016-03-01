unit mainunit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  GenericDemo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

Type
  TMyObject = class(TObject)
  public
    Name: string;
  end;

  TMyDemo = class(specialize GDemo<TMyObject>);

procedure TForm1.Button1Click(Sender: TObject);
var
  O: TMyObject;
  M: TMyDemo;
begin
  O := TMyObject.Create;
  M := TMyDemo.Create;
  try
    O.Name := 'Demo1';
    M.DoSomthing(O);
    Edit1.Text := O.Name;
  finally
    O.Free;
    M.Free;
  end;
end;

end.

