{ replace all occurence of "MyObject" with your object name }
unit {Unit_name};

interface

uses
  Windows, Messages, SysUtils, Classes;

type
  TMyObject = class(TObject)
  private
    { Private declarations }
  public
    constructor Create;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  MyObject: TMyObject;

implementation

{ Object constructor }
constructor TMyObject.Create;
begin
  inherited Create;
  { enter your code here }
end;

destructor TMyObject.Destroy;
begin
  { enter your code here }
  inherited;
end;

end.
