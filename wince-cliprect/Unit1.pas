unit Unit1; 

{$mode objfpc}{$H+}
{.$DEFINE CORRECT}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, LCLIntf, ExtCtrls, Menus;

type

  { TMyControl }

  TMyControl = class(TGraphicControl)
  private
    FFlag: Boolean;
    procedure SetFlag(const AValue: Boolean);
  protected
    SmallBox: TRect;
    procedure InvalidateRect(vRect: TRect);
  public
    Logs: string;
    n: Integer;
    constructor Create(AOwner: TComponent); override;
    property Flag: Boolean read FFlag write SetFlag;
    procedure Paint; override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    LogEdit: TMemo;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  private
    procedure Log(s:string);
  public
    MyControl: TMyControl;
  end;

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TMyControl }

procedure TMyControl.InvalidateRect(vRect: TRect);
begin
  if Parent <> nil then //no parent then no paint
  begin
    OffsetRect(vRect, Left, Top); //Because it use the Canvas of parent
    LCLIntf.InvalidateRect(Parent.Handle, @vRect, False);
  end;
end;

constructor TMyControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SmallBox := Rect(20, 20, 40, 40);
end;

procedure TMyControl.SetFlag(const AValue: Boolean);
begin
  if FFlag =AValue then exit;
  FFlag := AValue;
  InvalidateRect(SmallBox);//Refresh the SmallBox only
end;

function PrintRect(R: TRect): string;
begin
  Result := 'L:' + IntToStr(R.Left)+',';
  Result := Result + 'T:' + IntToStr(R.Top)+',';
  Result := Result + 'R:' + IntToStr(R.Right)+',';
  Result := Result + 'B:' + IntToStr(R.Bottom);
end;

//do not ask me the about function names :D
procedure L2D(vCanvas:TCanvas; var R: TRect);
var
  p: TPoint;
begin
  GetWindowOrgEx(vCanvas.Handle, @p);
  OffsetRect(R, -p.x,-p.y);
end;

procedure D2L(vCanvas:TCanvas; var R: TRect);
var
  p: TPoint;
begin
  GetWindowOrgEx(vCanvas.Handle, @p);
  OffsetRect(R, p.x, p.y);
end;

procedure MyExcludeClipRect(vCanvas: TCanvas; vRect: TRect);
begin
  {$ifdef CORRECT}
  {$ifdef WINCE}
  D2L(vCanvas, vRect);
  {$ENDIF}
  {$ENDIF}
  ExcludeClipRect(vCanvas.Handle, vRect.Left, vRect.Top, vRect.Right, vRect.Bottom);
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  MyControl.Flag := not MyControl.Flag;
  Application.ProcessMessages;
  LogEdit.Text := Trim(MyControl.Logs);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  MyControl.Logs := '';
  LogEdit.Text := '';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  LogEdit.Text := Trim(MyControl.Logs);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  MyControl.Refresh;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  t: Integer;
begin
  t := 10;
  MyControl:=TMyControl.Create(Self);
  MyControl.Parent := Self;
  MyControl.BoundsRect := Rect(10, t, 10 + 60, t + 60);
  MyControl.Visible := True;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  //Info:SHINITDLGINFO;
  //r:TRect;
  h, w: Integer;
  IsWindowsMobile :Boolean;
begin
  IsWindowsMobile := False;
  {$ifdef WINCE}
  {Info.hDlg := handle;
  Info.dwMask := SHIDIM_FLAGS;
  Info.dwFlags := SHIDIF_SIZEDLGFULLSCREEN;//SHIDIF_FULLSCREENNOMENUBAR;
  SHInitDialog(@Info);
  SHFullScreen(Handle, SHFS_HIDESIPBUTTON);}

  {SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  if Menu <> nil then
  begin
    r.Bottom := r.Bottom - GetSystemMetrics(SM_CYMENU) - GetSystemMetrics(SM_CYBORDER) * 2;//menu and its border
  end;
  BoundsRect := r;}

  h := GetSystemMetrics(SM_CYFULLSCREEN);
  if (Menu = nil) then
  begin
    if IsWindowsMobile then
      h := h + GetSystemMetrics(SM_CYMENU) + GetSystemMetrics(SM_CYBORDER)
    else
      h := h + GetSystemMetrics(SM_CYMENU) + GetSystemMetrics(SM_CYBORDER);
  end
  else
  begin
    if IsWindowsMobile then
      h := h - GetSystemMetrics(SM_CYBORDER)
    else
      h := h - GetSystemMetrics(SM_CYBORDER) * 2;
  end;
  w := GetSystemMetrics(SM_CXFULLSCREEN) + GetSystemMetrics(SM_CXBORDER) * 2;
  Top := 0;
  Left := 0;
  ClientHeight := h;
  ClientWidth := w;
  {$endif}
end;

procedure TForm1.FormShow(Sender: TObject);
begin

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Log(s: string);
begin
  LogEdit.Lines.Add(S);
end;

procedure TMyControl.Paint;
var
  c: TColor;
  CR: TRect;
begin
  inherited;

  n := n + 1;

  //Paint the small box
  Canvas.Pen.Color := clBlack;
  if Flag then
    c := clRed
  else
    c := clGreen;

  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := c;
  Canvas.Rectangle(SmallBox);

  //Now we paint the rect of ClipRect
  CR := Canvas.ClipRect;
  {$ifdef CORRECT}
  {$ifdef WINCE}
  L2D(Canvas, CR);
  {$ENDIF}
  {$ENDIF}
  {Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clLime;
  Canvas.Pen.Style := psSolid;
  Canvas.Rectangle(CR);}

  MyExcludeClipRect(Canvas, SmallBox); //Reduce the flicker

  //Paint background
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBlue;
  Canvas.FillRect(ClientRect);

  //Now we paint again
  Canvas.Brush.Style := bsClear;
  Canvas.Brush.Color := clGray;
  Canvas.Pen.Color := clLime;
  Canvas.Pen.Style := psSolid;
  InflateRect(CR, -5, -5);
  Canvas.Rectangle(CR);

  Logs := Logs +  #13#10 + IntToStr(n)+ '-' + PrintRect(CR);
  //(Parent as TForm1).Log(PrintRect(CR)); //make AV in wince
end;

end.

