unit uVoting;

interface
uses
  classes,
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  Data.DBXJSON,
  uObjectBaseApi,
  uJsonObjectHelper,
  uApiDemocraticLunchConstants,
  uApiConsumption;

type
  TVoting = class
  private
    FApi      : TApiConsumption;
    FVoting   : TJsonObject;
    FVoteList : TCommonListApi;
    FElected  : TJSONObject;
  protected
    constructor CreateInstance;
  public
    constructor Create;
    class function GetInstance: TVoting;
    function LoadCurrentVoting: Boolean;
    function StartNewVoting: Boolean;
    function ID: string;
    function VotingClosed: Boolean;
    function Vote(pEmployerID, pRestaurantID: string): Boolean;
    function ClosingDateTime: string;
    procedure Map(pStringJson: string);
    property RestaurantWinner : TJSONObject    read FElected;
    property VoteList         : TCommonListApi read FVoteList;
  end;

var _VotingInstance: TVoting;

implementation

{ TVoting }

procedure TVoting.Map(pStringJson: string);
var
  sJson: string;
begin
  sJson    := ReplaceStr(pStringJson, 'false,', '"False",');
  FVoting  := TJSONObject(TJSONObject.ParseJSONValue(sJson));
  FElected := FVoting.AsJSONObject(CS_FIELD_ELECTED);
  FVoteList.Map(FVoting.AsJSONArray(CS_FIELD_VOTE_LIST));
end;

function TVoting.ClosingDateTime: string;
begin
  Result:= FVoting.AsString(CS_FIELD_DATE_BR) + ' ' + FVoting.AsString(CS_FIELD_CLOSING_TIME);
end;

constructor TVoting.Create;
begin
  raise Exception.Create('Atenção! Esta classe não permite multiplas instancias, por favor utilize o método GetInstance');
end;

constructor TVoting.CreateInstance;
begin
  inherited Create;
  FVoteList:= TCommonListApi.Create;
  FElected := nil;
  FApi     := TApiConsumption.GetInstance;
end;

class function TVoting.GetInstance: TVoting;
begin
  if not Assigned(_VotingInstance) then
  begin
    _VotingInstance:= CreateInstance;
  end;
  Result:= _VotingInstance;
end;

function TVoting.ID: string;
begin
  Result:= '';
  if Assigned(FVoting) then
  begin
    Result:= FVoting.AsString(CS_FIELD_ID);
  end;
end;

function TVoting.Vote(pEmployerID, pRestaurantID: string): Boolean;
begin
  FApi.AddParam(CS_FIELD_RESTAURANT_ID, pRestaurantID);
  FApi.AddParam(CS_FIELD_EMPLOYER_ID, pEmployerID);
  Result:= FApi.Post(Format(CS_ENDPOINT_VOTE, [ID])) <> '';
end;

function TVoting.VotingClosed: Boolean;
begin
  Result:= True;
  if Assigned(FVoting) then
  begin
    Result:= FVoting.AsBoolean(CS_FIELD_VOTING_CLOSED);
  end;
end;

function TVoting.LoadCurrentVoting: Boolean;
var
  sVoting: string;
begin
  sVoting:= FApi.Get(CS_ENDPOINT_CURRENT_VOTING);
  if sVoting <> '' then
  begin
    Map(sVoting);
  end;
  Result:= ID <> '';
end;

function TVoting.StartNewVoting: Boolean;
var
  sVoting: string;
begin
  sVoting:= FApi.Post(CS_ENDPOINT_NEW_VOTING);
  if sVoting <> '' then
  begin
    Map(sVoting);
  end;
  Result:= ID <> '';
end;

initialization
   TVoting.GetInstance;

finalization
  FreeAndNil(_VotingInstance);

end.
