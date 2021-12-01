unit uObjectBaseApi;

interface
uses
  classes,
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  Data.DBXJSON,
  uApiConsumption;

type
  TCommonListApi = class(TObjectList<TJSONObject>)
  protected
  public
    procedure Map(pArray: TJSONArray);overload;
    procedure Map(pStringJson: string);overload;
  end;

  TAPIListObject = class(TCommonListApi)
  private
  protected
    FApi: TApiConsumption;
    function GetEndpoint: string; virtual; abstract;
    function parseResponse(pResponse: string): TJSONObject;
  public
    procedure AfterConstruction; override;
    procedure Delete(pID: string);
    procedure DeleteAll;
    function Load: Boolean; virtual;
    function New: TJSONObject;
    function Update(pID: string): TJSONObject;
    procedure AddParam(pKey: string; pValue: Variant);
  end;

implementation

procedure TCommonListApi.Map(pStringJson: string);
var
  sJson: string;
begin
  sJson:= ReplaceStr(pStringJson, ':false', ':"False"');
  sJson:= ReplaceStr(sJson, ':true', ':"True"');
  Map(TJSONArray(TJSONObject.ParseJSONValue(sJson)));
end;

procedure TCommonListApi.Map(pArray: TJSONArray);
var
  lItem: TJSONValue;
begin
  Clear;
  for lItem in pArray do
  begin
    Add(TJSONObject(lItem));
  end;
end;

{ TAPIListObject }

procedure TAPIListObject.AddParam(pKey: string; pValue: Variant);
begin
  FApi.AddParam(pKey, pValue);
end;

procedure TAPIListObject.AfterConstruction;
begin
  FApi:= TApiConsumption.GetInstance;
end;

procedure TAPIListObject.Delete(pID: string);
begin
  FApi.Delete(GetEndpoint, pID);
end;

procedure TAPIListObject.DeleteAll;
begin
  FApi.DeleteAll(GetEndpoint);
end;

function TAPIListObject.Load;
var
  sObj: string;
begin
  Result:= False;
  sObj:= FApi.Get(GetEndpoint);
  if sObj <> EmptyStr then
  begin
    Map(sObj);
    Result:= Count > 0;
  end;
end;

function TAPIListObject.New: TJSONObject;
begin
  Result:= parseResponse(FApi.Post(GetEndpoint));
end;

function TAPIListObject.parseResponse(pResponse: string): TJSONObject;
begin
  Result:= nil;
  if pResponse <> '' then
  begin
    Result:= TJSONObject(TJSONObject.ParseJSONValue(pResponse));
    Add(Result);
  end;
end;

function TAPIListObject.Update(pID: string): TJSONObject;
begin
  Result:= parseResponse(FApi.Put(GetEndpoint, pId));
end;

end.
