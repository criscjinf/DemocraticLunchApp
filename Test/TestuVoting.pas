unit TestuVoting;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, System.SysUtils, uObjectBaseApi, System.Generics.Collections,
  uJsonObjectHelper, classes, uVoting, System.StrUtils, Data.DBXJSON,
  uApiDemocraticLunchConstants, uApiConsumption,
  uRestaurants, uEmployees;

type
  // Test methods for class TVoting

  TestTVoting = class(TTestCase)
  strict private
    FApi: TApiConsumption;
    FVoting: TVoting;
    FEmployees: TEmployees;
    FRestaurants: TRestaurants;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestVoting;
  end;

implementation

procedure TestTVoting.SetUp;
begin
  FApi       := TApiConsumption.GetInstance;
  FApi.URL   := CS_URL_API;
  FVoting    := TVoting.GetInstance;
  FEmployees := TEmployees.Create;
  FEmployees.DeleteAll;

  FRestaurants:= TRestaurants.Create;
  FRestaurants.DeleteAll;
  FApi.DeleteAll(CS_ENDPOINT_VOTING);
end;

procedure TestTVoting.TearDown;
begin
  FreeAndNil(FEmployees);
  FreeAndNil(FRestaurants);
end;

procedure TestTVoting.TestVoting;
var
  ReturnValue: Boolean;
  lEmployer: TJSONObject;
  sIDRestaurant: array [0..2] of string;
  sIDEmployer: string;
  I: Integer;
begin
  try
    ReturnValue := FVoting.StartNewVoting;
    Check(False, 'Tentado abrir uma vota��o sem restaurantes cadastrados');
  except
    on e: ApiException do
    begin
      Check(True, 'Deve receber uma exce��o da api ao tentar abrir uma vota��o sem restaurantes cadastrados');
    end;
    on e: Exception do
    begin
      Check(False, 'Recebeu um erro que n�o veio da api ao tentar abrir uma vota��o sem restaurantes cadastrados');
    end;
  end;

  for I := 0 to 2 do
  begin
    FRestaurants.AddParam(CS_FIELD_NAME, 'RESTAURANTE ' + IntToStr(I));
    sIDRestaurant[I] := FRestaurants.New.AsString(CS_FIELD_ID);
  end;

  FEmployees.AddParam(CS_FIELD_CPF, '1');
  FEmployees.AddParam(CS_FIELD_NAME, 'TESTE 1');
  FEmployees.AddParam(CS_FIELD_EMAIL, 'mail@');
  sIDEmployer:= FEmployees.New.AsString(CS_FIELD_ID);

  ReturnValue := FVoting.StartNewVoting;
  CheckTrue(ReturnValue, 'Vota��o iniciada');

  ReturnValue := FVoting.LoadCurrentVoting;
  CheckTrue(ReturnValue, 'Carregada vota��o corrente');

  CheckTrue(FVoting.VoteList.Count = 3, 'Devem ter 3 restaurantes dispon�veis para vota��o');

  CheckTrue(FVoting.Vote(sIDEmployer, sIDRestaurant[0]), 'Teste de vota��o');

  FApi.DeleteAll(CS_ENDPOINT_VOTING);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTVoting.Suite);
end.
