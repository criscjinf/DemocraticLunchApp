program DemocraticLunch;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uDocumentFunctions in 'Lib\uDocumentFunctions.pas',
  uFrmBase in 'Forms\uFrmBase.pas' {FrmBase},
  uFrmVoting in 'Forms\uFrmVoting.pas' {FrmVoting},
  uCustomEditHelper in 'Helpers\uCustomEditHelper.pas',
  uObjectBaseApi in 'Classes\uObjectBaseApi.pas',
  uJsonObjectHelper in 'Helpers\uJsonObjectHelper.pas',
  uApiComboboxHelper in 'Helpers\uApiComboboxHelper.pas',
  uFrameVote in 'Frames\uFrameVote.pas' {frameVote: TFrame},
  uVoting in 'Classes\uVoting.pas',
  uApiDemocraticLunchConstants in 'Lib\uApiDemocraticLunchConstants.pas',
  uApiConsumption in 'Lib\uApiConsumption.pas',
  uEmployees in 'Classes\uEmployees.pas',
  uLogInformation in 'Lib\uLogInformation.pas',
  uRestaurants in 'Classes\uRestaurants.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmVoting, FrmVoting);
  Application.Run;
end.
