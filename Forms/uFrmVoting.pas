unit uFrmVoting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmBase, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, uCustomEditHelper,
  uApiConsumption, uObjectBaseApi, Data.DBXJSON,
  uJsonObjectHelper, uApiDemocraticLunchConstants, Vcl.DBCtrls,
  uFrameVote, uVoting,
  uEmployees, Vcl.AppEvnts,
  uLogInformation;

type
  TFrmVoting = class(TFrmBase)
    pnlButtons: TPanel;
    btnNext: TButton;
    pgcVoting: TPageControl;
    tsStart: TTabSheet;
    lblCPF: TLabel;
    lblName: TLabel;
    lblEmail: TLabel;
    edtCPF: TMaskEdit;
    edtName: TEdit;
    edtEmail: TEdit;
    tsVote: TTabSheet;
    frameVote1: TframeVote;
    lblERROR: TLabel;
    tsFinal: TTabSheet;
    pnlFinalMsg: TPanel;
    lblMsg: TLabel;
    tsNewtVoting: TTabSheet;
    lblNewVoting: TLabel;
    appEvents: TApplicationEvents;
    grpInfo: TGroupBox;
    lblCaptionData: TLabel;
    lblData: TLabel;
    procedure appEventsException(Sender: TObject; E: Exception);
    procedure btnNextClick(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
    procedure edtNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FApi            : TApiConsumption;
    FEmployees      : TEmployees;
    FSelectedEmploy : TJsonObject;
    FVoting         : TVoting;
    FVote           : TFunc<Boolean>;
    procedure SelectEmployer(pCpf: string = '');
    procedure EnableCtrls(pEnabled: Boolean = False);
    function RegisterUpdateEmployer: Boolean;
    procedure EditValidateError(pEdit: TCustomEdit; pCaption, pMsg: string);
    function ValidateEmployer: Boolean;
    procedure NextStep;
    function ValidateVotingDate: Boolean;
    procedure UnselectEmployer;
    procedure HideTabControls;
    procedure LoadCurrentVoting;
    procedure ConfigureFrameVote;
    function StartNewVoting: Boolean;
    procedure UpdateVotingData;
  public
    procedure EnableNext(pEnabled: Boolean);
    property Vote: TFunc<Boolean> read FVote write FVote;
  end;

var
  FrmVoting: TFrmVoting;

implementation


{$R *.dfm}

procedure TFrmVoting.appEventsException(Sender: TObject; E: Exception);
begin
  TLogInformation.SaveLog(Sender, E);
  TLogInformation.ShowLogInformation(E);
end;

procedure TFrmVoting.EditValidateError(pEdit: TCustomEdit; pCaption, pMsg: string);
begin
  Application.MessageBox(PWideChar(pMsg), PWideChar(pCaption), MB_OK + MB_ICONWARNING);
  pEdit.SelectAll;
  pEdit.SetFocus;
end;

function TFrmVoting.ValidateVotingDate: Boolean;
const
  CS_MSG_VOTE = 'Voto já registrado! Por favor %s, aguarde o resultado no seu e-mail';
begin
  Result := ((not Assigned(FSelectedEmploy)) or (not FSelectedEmploy.AsBoolean(CS_FIELD_LOCKED)));
  if not Result then
  begin
    Application.MessageBox(PWideChar(Format(CS_MSG_VOTE, [FSelectedEmploy.AsString(CS_FIELD_NAME)])),
      'Atenção!',
      MB_OK + MB_ICONWARNING);
  end;
end;

function TFrmVoting.ValidateEmployer: Boolean;
begin
  Result := edtCPF.ValidateCpf(EditValidateError) and
    edtName.ValidateText('Nome', EditValidateError) and
    edtEmail.ValidateEmail(EditValidateError) and
    ValidateVotingDate;
end;

function TFrmVoting.RegisterUpdateEmployer(): Boolean;
begin
  Result := ValidateEmployer;
  if Result then
  begin
    FEmployees.AddParam(CS_FIELD_CPF, edtCPF.Text);
    FEmployees.AddParam(CS_FIELD_NAME, edtName.Text);
    FEmployees.AddParam(CS_FIELD_EMAIL, edtEmail.Text);
    if Assigned(FSelectedEmploy) then
    begin
      FSelectedEmploy:= FEmployees.Update(FSelectedEmploy.AsString(CS_FIELD_ID));
    end else
    begin
      FSelectedEmploy:= FEmployees.New;
    end;
  end;
end;

function TFrmVoting.StartNewVoting: Boolean;
begin
  try
    Result:= FVoting.StartNewVoting;
    if Result then
    begin
      UpdateVotingData;
    end;
  except
    on e: ApiException do
    begin
      Application.MessageBox(PWideChar('Verifique se existem restaurantes cadastrados'),
        'Erro ao abrir votação',
        MB_OK +MB_ICONERROR);
    end;
  end;
end;

procedure TFrmVoting.NextStep;
var
  bContinue: Boolean;
begin
  case pgcVoting.ActivePageIndex of
    0: bContinue := StartNewVoting;
    1: begin
         bContinue := RegisterUpdateEmployer;
         ConfigureFrameVote;
       end;
    2: bContinue := Vote;
  else
    bContinue := True;
  end;

  if bContinue then
  begin
    if (pgcVoting.ActivePageIndex < pgcVoting.PageCount - 1) then
    begin
      btnNext.Caption:= 'Continuar >>';
      pgcVoting.ActivePageIndex := pgcVoting.ActivePageIndex + 1;
    end else
    begin
      btnNext.Caption:= 'Finalizar >>';
      pgcVoting.ActivePage:= tsStart;
      edtCPF.Clear;
      SelectEmployer();
    end;
  end;
  EnableNext(pgcVoting.ActivePage = tsFinal);
end;

procedure TFrmVoting.btnNextClick(Sender: TObject);
begin
  NextStep;
end;

procedure TFrmVoting.EnableCtrls(pEnabled: Boolean);
begin
  edtName.Enabled := pEnabled;
  edtEmail.Enabled := pEnabled;
end;

procedure TFrmVoting.UnselectEmployer;
begin
  FSelectedEmploy:= nil;
  FEmployees.Clear;
  edtName.Clear;
  edtEmail.Clear;
  frameVote1.EmployerID:= '';
  EnableNext(False);
end;

procedure TFrmVoting.SelectEmployer(pCpf: string);
begin
  lblERROR.Visible:= False;
  if pCpf <> EmptyStr then
  begin
    FEmployees.AddParam(CS_FIELD_CPF, pCpf);
    if FEmployees.Load then
    begin
      FSelectedEmploy       := FEmployees.First;
      edtName.Text          := FSelectedEmploy.AsString(CS_FIELD_NAME);
      edtEmail.Text         := FSelectedEmploy.AsString(CS_FIELD_EMAIL);
      frameVote1.EmployerID := FSelectedEmploy.AsString(CS_FIELD_ID);
      EnableNext(True);
    end else
    begin
      lblERROR.Visible:= true;
      UnselectEmployer;
    end;
  end
  else
  begin
    UnselectEmployer;
  end;
end;

procedure TFrmVoting.edtCPFExit(Sender: TObject);
begin
  if edtCPF.Text <> edtCPF.EditMask then
  begin
    if edtCPF.ValidateCpf(EditValidateError) then
    begin
      SelectEmployer(edtCPF.Text);
      EnableCtrls(True);
      edtName.SetFocus;
    end
    else
    begin
      edtCPF.Clear;
      EnableCtrls;
      SelectEmployer;
    end;
  end;

end;

procedure TFrmVoting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FEmployees);
end;

procedure TFrmVoting.UpdateVotingData;
begin
  lblData.Caption:= FVoting.ClosingDateTime();
end;

procedure TFrmVoting.LoadCurrentVoting;
begin
  if FVoting.LoadCurrentVoting then
  begin
    pgcVoting.ActivePage:= tsStart;
    UpdateVotingData;
  end else
  begin
    pgcVoting.ActivePage:= tsNewtVoting;
    btnNext.Enabled:= True;
  end;
end;

procedure TFrmVoting.FormCreate(Sender: TObject);
begin
  inherited;
  FApi        := TApiConsumption.GetInstance;
  FApi.URL    := CS_URL_API;
  FVoting     := TVoting.GetInstance;
  FEmployees  := TEmployees.Create;
end;

procedure TFrmVoting.ConfigureFrameVote;
begin
  Self.Vote             := frameVote1.Vote;
  frameVote1.EnableNext := EnableNext;
  frameVote1.VoteList:= FVoting.VoteList;
  frameVote1.LoadVoting;
end;

procedure TFrmVoting.edtNameKeyUp(Sender: TObject; var Key: Word; Shift:
    TShiftState);
begin
  inherited;
  if (pgcVoting.ActivePage = tsStart) then
  begin
    btnNext.Enabled:= (edtCPF.Text <> EmptyStr) and
      (Length(Trim(edtName.Text)) > 3) and
      (Length(Trim(edtEmail.Text)) > 3);
  end;
end;

procedure TFrmVoting.HideTabControls;
var
  I: Integer;
begin
  for I := 0 to pgcVoting.PageCount - 1 do
  begin
    pgcVoting.Pages[I].TabVisible := False;
  end;
  pgcVoting.ActivePage:= tsStart;
end;

procedure TFrmVoting.FormShow(Sender: TObject);
begin
  SelectEmployer();
  EnableCtrls;
  HideTabControls;
  LoadCurrentVoting;
end;

procedure TFrmVoting.EnableNext(pEnabled: Boolean);
begin
  btnNext.Enabled:= pEnabled;
end;

end.

