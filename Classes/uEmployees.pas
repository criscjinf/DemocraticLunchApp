unit uEmployees;

interface
uses
  Classes,
  System.SysUtils,
  System.Generics.Collections,
  DateUtils,
  uObjectBaseApi,
  uJsonObjectHelper,
  uApiDemocraticLunchConstants,
  Data.DBXJSON;

type
  TEmployees = class(TAPIListObject)
  private
  protected
    function GetEndpoint: string; override;
  public
  end;


implementation
{ TEmployees }

function TEmployees.GetEndpoint: string;
begin
  Result:= CS_ENDPOINT_EMPLOYEES;
end;

end.
