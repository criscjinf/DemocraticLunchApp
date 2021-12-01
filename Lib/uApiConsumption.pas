unit uApiConsumption;

interface

Uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  DATA.DBXJSON,
  System.StrUtils,
  Forms,
  Winapi.Windows;

type
  ApiException = class(Exception);

  TApiConsumption = class
  private
    FHttp                        : TIdHTTP;
    FIdSSLIOHandlerSocketOpenSSL : TIdSSLIOHandlerSocketOpenSSL;
    FHeaders                     : TStringList;
    FURL                         : string;
    FAuthorize                   : string;
    FParams                      : TStringList;
    procedure Configure;
    function FormatParams(pParamams: TStringList): string;
    function CallApi(pEndPoint, pID: string; pMethod: TFunc<string, string>): string;
    function GetURL(): string;
    function GetJsonParams(pParams: TStringList): TStringStream;
    constructor CreateInstance;
  public
    constructor Create;
    class function GetInstance: TApiConsumption;
    function Get(pEndPoint: string): string;
    function Post(pEndPoint: string): string;
    function Put(pEndPoint: string; pID: string): string;
    procedure AddParam(pKey: string; pValue: Variant);
    procedure Delete(pEndPoint: string; pID: string);
    procedure DeleteAll(pEndPoint: string);
    destructor Destroy; override;
    property URL       : string      read GetURL     write FURL;
    property Headers   : TStringList read FHeaders   write FHeaders;
    property Authorize : string      read FAuthorize write FAuthorize;
  end;

var _ApiInstance: TApiConsumption;

implementation

{ TApiConsumption }

constructor TApiConsumption.CreateInstance;
begin
  inherited Create;
  FHttp                        := TIdHTTP.Create(nil);
  FIdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(FHttp);
  FHttp.IOHandler              := FIdSSLIOHandlerSocketOpenSSL;
  FParams                      := TStringList.Create;
end;

constructor TApiConsumption.Create;
begin
  raise Exception.Create('Atenção! Esta classe não permite multiplas instancias, por favor utilize o método GetInstance');
end;

class function TApiConsumption.GetInstance: TApiConsumption;
begin
  if not Assigned(_ApiInstance) then
  begin
    _ApiInstance := TApiConsumption.CreateInstance;
  end;
  Result           := _ApiInstance;
end;

procedure TApiConsumption.Configure();
begin
  with FHTTP do
  begin
    Request.Clear;
    Request.ContentType   := 'application/json';
    Request.AcceptCharSet := 'UTF-8';
    Response.ContentType  := 'application/json';
    Response.ResponseText := 'UTF-8';
    Request.Accept        := 'application/json';
    BoundPortMax          := 5000;
    ConnectTimeout        := 5000;
    if FAuthorize <> EmptyStr then
    begin
      Request.CustomHeaders.Add('Authorization: ' + Authorize);
    end;
  end;
end;

function TApiConsumption.FormatParams(pParamams: TStringList) : string;
var
  lParametro: string;
  lAux: string;
begin
  Result:= '';
  if Assigned(pParamams) then
  begin
    lAux := '?';
    for lParametro in pParamams do
    begin
      Result := Result + lAux + lParametro;
      lAux := '&'
    end;
  end;
end;

procedure TApiConsumption.AddParam(pKey: string; pValue: Variant);
begin
  Fparams.Values[pKey]:= VarToStr(pValue);
end;

function TApiConsumption.CallApi(pEndPoint, pID: string; pMethod: TFunc<string, string>): string;
var
  sUrl: string;
  sErrorMessage: string;
begin
  try
    try
      Configure;
      sUrl:= URL +
        pEndPoint +
        IfThen((pID <> '') and (EndsStr('/', pEndPoint)), '', '/') +
        IfThen(pID <> '', pID, '');

      Result:= pMethod(sUrl);
    finally
      FParams.Clear;
    end;
  except
    on E: Exception do
    begin
      if (FHTTP.Response.ResponseCode = 500) then
      begin
      sErrorMessage:= IfThen(ContainsStr(E.Message, 'Socket Error # 10061'),
        'Api parece estar indisponível no momento. ' + sLineBreak +
        'Verifique suas conexões de rede e se o serviço está ativo',
        E.Message);
      end;
      raise ApiException.Create('Falha de comunicação com a api.' +
          sLineBreak + sLineBreak +
          'Erro: ' + sErrorMessage);
    end;
  end;
end;

function TApiConsumption.Get(pEndPoint: string): string;
var
  lJsonStreamReturn: TStringStream;
begin
  Result:= CallApi(pEndPoint, '',
    function (pUrl: string): string
      begin
        lJsonStreamReturn := TStringStream.Create('', TEncoding.UTF8);
        try
          FHTTP.Get(pUrl + FormatParams(FParams), lJsonStreamReturn);
          lJsonStreamReturn.Position := 0;
          Result := lJsonStreamReturn.DataString;
        finally
          lJsonStreamReturn.Free;
        end;
      end);
end;

function TApiConsumption.GetURL: string;
begin
  if not EndsStr('/', FURL) then
  begin
    FURL:= FURL + '/';
  end;
  Result:= FURL;
end;

function TApiConsumption.GetJsonParams(pParams: TStringList): TStringStream;
var
  sAux: string;
  sJson: string;
  I: Integer;
const
  CS_PARAM = '"%s": "%s"';
begin
  sJson:= '';
  if (Assigned(pParams)) and (pParams.Count > 0) then
  begin
    sAux := '{';
    for I := 0 to pParams.Count -1 do
    begin
      sJson := sJson + sAux + Format(CS_PARAM, [pParams.Names[I], pParams.ValueFromIndex[I]]);
      sAux:= ',';
    end;
    sJson:= sJson + '}';
  end;
  Result:= TStringStream.Create(sJson);
end;

function TApiConsumption.Post(pEndPoint: string): string;
var
  lJsonStream: TStringStream;
begin
  Result:= CallApi(pEndPoint, '',
    function (pUrl: string): string
    begin
      lJsonStream:= GetJsonParams(FParams);
      try
        Result:= FHTTP.Post(pURL, lJsonStream);
      finally
        lJsonStream.Free;
      end;
    end);
end;

function TApiConsumption.Put(pEndPoint: string; pID: string): string;
var
  lJsonStream: TStringStream;
begin
  Result:= CallApi(pEndPoint, pID,
    function (pUrl: string): string
    begin
      lJsonStream:= GetJsonParams(FParams);
      try
        Result:= FHTTP.Put(pURL, lJsonStream);
      finally
        lJsonStream.Free;
      end;
    end);
end;

procedure TApiConsumption.Delete(pEndPoint: string; pID: string);
begin
  CallApi(pEndPoint, pID,
    function (pUrl: string): string
    begin
      FHTTP.Delete(pUrl);
      Result:= '';
    end);
end;

procedure TApiConsumption.DeleteAll(pEndPoint: string);
begin
  CallApi(pEndPoint, '',
    function (pUrl: string): string
    begin
      FHTTP.Delete(pUrl);
      Result:= '';
    end);
end;

destructor TApiConsumption.Destroy;
begin
  FHttp.Free;
  FParams.Free;
end;

initialization
  TApiConsumption.GetInstance;

finalization
  FreeAndNil(_ApiInstance);

end.
