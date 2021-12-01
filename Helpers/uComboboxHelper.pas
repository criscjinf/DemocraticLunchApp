unit uComboboxHelper;

interface
uses
  System.SysUtils,
  Vcl.StdCtrls;

type
  TComboboxHelper = class Helper for TComboBox
  public
   function AddValue(pId: Integer; pDescription: string): Integer;
   function SelectedID(): Integer;
  end;

implementation

{ TComboboxHelper }

function TComboboxHelper.AddValue(pId: Integer; pDescription: string): Integer;
begin
  Result:= Items.IndexOf(pDescription);
  if (Result = -1) then
  begin
     Items.AddObject(pDescription, TObject(pId));
  end else
  begin
    Items.Objects[Result]:= TObject(pId);
  end;
end;

function TComboboxHelper.SelectedID: Integer;
begin
  Result:= -1;
  if (ItemIndex > -1) then
  begin
    Result:= Integer(Items.Objects[ItemIndex]);
  end;
end;

end.
