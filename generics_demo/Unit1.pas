unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, GenericDemo;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


Type
  TMyObject = class(TObject)
  public
    Name: string;
  end;

  TMyDemo = class(GDemo<TMyObject>);

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
