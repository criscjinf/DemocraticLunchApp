unit TestuEmployees;
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
  uJsonObjectHelper, DateUtils, Classes, uEmployees, uApiDemocraticLunchConstants,
  Data.DBXJSON, uApiConsumption;

type
  // Test methods for class TEmployees

  TestTEmployees = class(TTestCase)
  strict private
    FEmployees: TEmployees;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLoad;
    procedure TestNewEmployeer;
    procedure TestUpdateEmployeer;
  end;

implementation

procedure TestTEmployees.SetUp;
begin
  TApiConsumption.GetInstance.URL:= CS_URL_API;
  FEmployees := TEmployees.Create;
  FEmployees.DeleteAll;
end;

procedure TestTEmployees.TearDown;
begin
  FEmployees.Free;
  FEmployees := nil;
end;

procedure TestTEmployees.TestLoad;
var
  ReturnValue: Boolean;
  pCPF: string;
begin
  pCpf   := '99999';
  FEmployees.AddParam(CS_FIELD_CPF, pCpf);
  FEmployees.AddParam(CS_FIELD_NAME, 'Teste');
  FEmployees.AddParam(CS_FIELD_EMAIL, 'teste@email.com.br');
  FEmployees.New;


  FEmployees.AddParam(CS_FIELD_CPF, pCpf);//Classe sempre limpa os par�metros ap�s requisi��o
  ReturnValue := FEmployees.Load;
  CheckTrue(ReturnValue, 'Deve carregar os dados do funcion�rio');
end;

procedure TestTEmployees.TestNewEmployeer;
var
  ReturnValue: TJSONObject;
begin
  FEmployees.AddParam(CS_FIELD_CPF  , '');

  try
    FEmployees.New;
    Check(False, 'Enviadas informa��es inv�lidas no cadastro de funcion�rios e n�o retornou erro');
  except
    on e: ApiException do
    begin
      Check(True, 'Deve receber uma exce��o da api a tentar enviar informa��es inv�lidas');
    end;
    on e: Exception do
    begin
      Check(False, 'Recebeu um erro que n�o veio da api ao tentar realizar um cadastro de usu�rio');
    end;
  end;

  FEmployees.AddParam(CS_FIELD_CPF  , '99');
  FEmployees.AddParam(CS_FIELD_NAME , 'Teste');
  FEmployees.AddParam(CS_FIELD_EMAIL, 'teste@email.com.br');

  ReturnValue:= FEmployees.New;

  CheckTrue(Assigned(ReturnValue), 'Deve criar um novo usu�rio na api e retornar o objeto com os dados do funcion�rio');
end;

procedure TestTEmployees.TestUpdateEmployeer;
var
  ReturnValue: TJSONObject;
  pNewEmail: string;
begin
  FEmployees.AddParam(CS_FIELD_CPF  , '9');
  FEmployees.AddParam(CS_FIELD_NAME , 'Teste');
  FEmployees.AddParam(CS_FIELD_EMAIL, 'teste@email.com.br');
  ReturnValue:= FEmployees.New;

  CheckTrue(Assigned(ReturnValue), 'Deve criar um novo usu�rio na api e retornar o objeto com os dados do funcion�rio');

  pNewEmail := 'teste@hotmail.com.br';
  FEmployees.AddParam(CS_FIELD_CPF  , '9');
  FEmployees.AddParam(CS_FIELD_NAME , 'Teste');
  FEmployees.AddParam(CS_FIELD_EMAIL, pNewEmail);

  ReturnValue := FEmployees.Update(ReturnValue.AsString(CS_FIELD_ID));

  CheckTrue(Assigned(ReturnValue) and (ReturnValue.AsString(CS_FIELD_EMAIL) = pNewEmail),
    'Deve atualizar as informa��es do usu�rio na api e retornar o objeto com os dados do funcion�rio');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTEmployees.Suite);
end.

