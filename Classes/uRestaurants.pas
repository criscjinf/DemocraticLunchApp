unit uRestaurants;

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
  TRestaurants = class(TAPIListObject)
  private
  protected
    function GetEndpoint: string; override;
  public
  end;


implementation
{ TRestaurants }

function TRestaurants.GetEndpoint: string;
begin
  Result:= CS_ENDPOINT_RESTAURANTS;
end;

end.
