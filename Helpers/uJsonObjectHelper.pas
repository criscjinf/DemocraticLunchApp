unit uJsonObjectHelper;

interface
uses
  System.SysUtils,
  Data.DBXJSON;

type
  TJsonObjectHelper =  class Helper for TJsonObject
  private
  public
    function AsString(pFieldName: string): string;
    function AsInteger(pFieldName: string): Integer;
    function AsBoolean(pFieldName: string): Boolean;
    function AsJSONObject(pFieldName: string): TJSONObject;
    function AsJSONArray(pFieldName: string): TJSONArray;
  end;

implementation

{ TJsonObjectHelper }

function TJsonObjectHelper.AsJSONArray(pFieldName: string): TJSONArray;
begin
  Result:= TJSONArray(Get(pFieldName).JsonValue);
end;

function TJsonObjectHelper.AsJSONObject(pFieldName: string): TJSONObject;
begin
  Result:= TJSONObject(Get(pFieldName).JsonValue);
end;

function TJsonObjectHelper.AsBoolean(pFieldName: string): Boolean;
begin
  Result:= TJSONString(Get(pFieldName).JsonValue).Value = 'True';
end;

function TJsonObjectHelper.AsInteger(pFieldName: string): Integer;
begin
  Result:= TJSONNumber(Get(pFieldName).JsonValue).AsInt;
end;

function TJsonObjectHelper.AsString(pFieldName: string): string;
begin
  Result:= TJSONString(Get(pFieldName).JsonValue).Value;
end;

end.
