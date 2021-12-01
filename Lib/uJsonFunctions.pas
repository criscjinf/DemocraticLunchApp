unit uJsonFunctions;

interface
uses
  Classes,
  System.SysUtils,
  Soap.XSBuiltIns;

type
  TJsonFunctions = class
    class function DateTimeISOToDate(const pDataTime: string): TDateTime;
  end;

implementation


class function TJsonFunctions.DateTimeISOToDate(const pDataTime: string): TDateTime;
var
  lData: TXSDateTime;
begin
  // http://msdn.microsoft.com/en-us/library/bb630289.aspx
  // http://stackoverflow.com/questions/6651829/how-do-i-convert-an-iso-8601-string-to-a-delphi-tdate

  lData := TXSDateTime.Create;
  try
    lData.XSToNative(pDataTime);
    Result := lData.AsDateTime;
  finally
    lData.Free;
  end;
end;

end.
