unit uApiComboboxHelper;

interface
uses
  System.SysUtils,
  Vcl.StdCtrls,
  uObjectBaseApi,
  Data.DBXJson,
  uJsonObjectHelper;

type
  TApiComboboxHelper = class Helper for TComboBox
  public
   procedure LoadFromSubobject(pList: TCommonListApi; pSubObjectName, pFieldDescription: string);
   function SelectedObject: TJSONObject;
  end;

implementation

{ TApiComboboxHelper }

procedure TApiComboboxHelper.LoadFromSubobject(pList: TCommonListApi; pSubObjectName, pFieldDescription: string);
var
  lObj: TJSONObject;
begin
  Items.Clear;
  for lObj in pList do
  begin
    Items.AddObject(lObj.AsJSONObject(pSubObjectName).AsString(pFieldDescription), lObj.AsJSONObject(pSubObjectName));
  end;
end;

function TApiComboboxHelper.SelectedObject: TJSONObject;
begin
  Result:= nil;
  if (ItemIndex > -1) then
  begin
    Result:= (Items.Objects[ItemIndex] as TJSONObject);
  end;
end;

end.
