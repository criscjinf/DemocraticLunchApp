unit uFrameVote;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uApiConsumption,
  uObjectBaseApi, Data.DBXJSON, uJsonObjectHelper, uApiDemocraticLunchConstants,
  uApiComboboxHelper, uVoting;

type
  TframeVote = class(TFrame)
    cbbRestaurants: TComboBox;
    lblRestaurant: TLabel;
    lblWelcome: TLabel;
    procedure cbbRestaurantsClick(Sender: TObject);
  private
    FVoting      : TVoting;
    FApi         : TApiConsumption;
    FVoteList    : TCommonListApi;
    FEmployerID  : string;
    FEnableNext  : TProc<Boolean>;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadVoting;
    function Vote: Boolean;
    property EmployerID     : string          read FEmployerID     write FEmployerID;
    property EnableNext     : TProc<Boolean>  read FEnableNext     write FEnableNext;
    property VoteList       : TCommonListApi  read FVoteList       write FVoteList;
  end;

implementation

{$R *.dfm}

{ TframeVote }

constructor TframeVote.Create(AOwner: TComponent);
begin
  inherited;
  FVoting:= TVoting.GetInstance;
  FApi   := TApiConsumption.GetInstance;
end;

procedure TframeVote.cbbRestaurantsClick(Sender: TObject);
begin
  if Assigned(FEnableNext) then
  begin
    EnableNext(cbbRestaurants.ItemIndex > -1);
  end;
end;

procedure TframeVote.LoadVoting;
begin
  cbbRestaurants.LoadFromSubobject(FVoteList, CS_FIELD_RESTAURANT, CS_FIELD_NAME);
end;

function TframeVote.Vote: Boolean;
var
  lObj: TJSONObject;
begin
  Result:= False;
  lObj:= cbbRestaurants.SelectedObject;
  if Assigned(lObj) then
  begin
    Result:= FVoting.Vote(EmployerID, lObj.AsString(CS_FIELD_ID));
  end;
end;

end.
