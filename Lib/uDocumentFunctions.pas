unit uDocumentFunctions;

interface

type
  TDocument = class
  public
    class function isCPF(pCPF: string): Boolean;
    class function isMail(pMail: string): Boolean;
  end;

implementation
uses SysUtils, System.RegularExpressions, StrUtils;

{ TDocumento }

class function TDocument.isCPF(pCPF: string): Boolean;
var
  dig10, dig11: string;
  s, i, r, peso: integer;
  sCPF: string;
  function ReplaceInvalidChar(pCPF: string): string;
  var
    X: Integer;
  const
    sInvalidChar = '.-_ ';
  begin
    Result := pCPF;
    for X := 0 to Length(sInvalidChar) do
    begin
      Result:= ReplaceStr(Result, sInvalidChar[X], '');
    end;
  end;
begin
  sCPF:= ReplaceInvalidChar(pCPF);
  // length - retorna o tamanho da string (sCPF é um número formado por 11 dígitos)
  if ((sCPF = '00000000000') or (sCPF = '11111111111') or
      (sCPF = '22222222222') or (sCPF = '33333333333') or
      (sCPF = '44444444444') or (sCPF = '55555555555') or
      (sCPF = '66666666666') or (sCPF = '77777777777') or
      (sCPF = '88888888888') or (sCPF = '99999999999') or
      (length(sCPF) <> 11))
  then begin
    isCPF := false;
    Exit;
  end;

// try - protege o código para eventuais erros de conversão de tipo na função StrToInt
  try
    { *-- Cálculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
      // StrToInt converte o i-ésimo caractere do sCPF em um número
      s := s + (StrToInt(sCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11))
    then dig10 := '0'
    else str(r:1, dig10); // converte um número no respectivo caractere numérico

{ *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(sCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then dig11 := '0'
    else str(r:1, dig11);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = sCPF[10]) and (dig11 = sCPF[11])) then isCPF := true
    else isCPF := false;
  except
    isCPF := false
  end;
end;

class function TDocument.isMail(pMail: string): Boolean;
const
  EMAIL_EX = '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*|"((?=[\x01-\x7f])'
   +'[^"\\]|\\[\x01-\x7f])*"\x20*)*(?<angle><))?((?!\.)'
   +'(?>\.?[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])'
   +'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\-]+(?<!-)\.)+[a-zA-Z]'
   +'{2,}|\[(((?(?<!\[)\.)(25[0-5]|2[0-4]\d|[01]?\d?\d))'
   +'{4}|[a-zA-Z\d\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|\\'
   +'[\x01-\x7f])+)\])(?(angle)>)$';
begin
  Result:= TRegEx.IsMatch(pMail, EMAIL_EX);
end;


end.
