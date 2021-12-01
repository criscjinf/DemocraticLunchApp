program DemocraticLunchTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  uObjectBaseApi in '..\Classes\uObjectBaseApi.pas',
  uVoting in '..\Classes\uVoting.pas',
  uApiComboboxHelper in '..\Helpers\uApiComboboxHelper.pas',
  uComboboxHelper in '..\Helpers\uComboboxHelper.pas',
  uCustomEditHelper in '..\Helpers\uCustomEditHelper.pas',
  uJsonObjectHelper in '..\Helpers\uJsonObjectHelper.pas',
  uApiConsumption in '..\Lib\uApiConsumption.pas',
  uApiDemocraticLunchConstants in '..\Lib\uApiDemocraticLunchConstants.pas',
  uConstants in '..\Lib\uConstants.pas',
  uDocumentFunctions in '..\Lib\uDocumentFunctions.pas',
  TestuVoting in 'TestuVoting.pas',
  uEmployees in '..\Classes\uEmployees.pas',
  TestuEmployees in 'TestuEmployees.pas',
  uRestaurants in '..\Classes\uRestaurants.pas',
  TestuRestaurants in 'TestuRestaurants.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

