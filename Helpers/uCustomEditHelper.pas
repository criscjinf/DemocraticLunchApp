unit uCustomEditHelper;

interface
uses
  classes,
  Vcl.StdCtrls,
  System.SysUtils,
  uDocumentFunctions,
  StrUtils;

type
  TCustomEditHelper =  class Helper for TCustomEdit
  private
    function ValidateValue(pIsValid: Boolean; pMsgError: string;
      pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
  public
    function ValidateText(pLabel: string; pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
    function ValidateEmail(pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
    function ValidateCpf(pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
  end;


implementation

function TCustomEditHelper.ValidateValue(pIsValid: Boolean; pMsgError: string;
  pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
const
  CS_MSG = 'Por favor informe um %s válido';
  CS_CAPTION = 'Atenção! %s inválido';
begin
  Result:= pIsValid;
  if not Result then
  begin
    pErrorMethod(Self, Format(CS_CAPTION, [pMsgError]), Format(CS_MSG, [LowerCase(pMsgError)]));
  end;
end;

function TCustomEditHelper.ValidateText(pLabel: string; pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
begin
  Result:= ValidateValue(Text <> '', pLabel, pErrorMethod);
end;

function TCustomEditHelper.ValidateEmail(pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
begin
  Result:= ValidateValue(TDocument.isMail(Text), 'E-mail', pErrorMethod);
end;

function TCustomEditHelper.ValidateCpf(pErrorMethod: TProc<TCustomEdit, string, string>): Boolean;
begin
  Result:= ValidateValue(TDocument.isCpf(Text), 'CPF', pErrorMethod);
end;

end.
