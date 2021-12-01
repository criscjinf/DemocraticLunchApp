unit uLogInformation;

interface
uses
  Classes,
  Winapi.Windows,
  types,
  System.SysUtils,
  Vcl.Forms,
  Vcl.Imaging.jpeg,
  Vcl.Graphics,
  Vcl.Dialogs;


type
  TLogInformation = class
  private
     class function GetUser: string;
     class function SystemVersion: string;
     class procedure SaveFormImage(const pFileName: string);
  public
    class procedure SaveLog(pSender: TObject; pErro: Exception);
    class procedure ShowLogInformation(pErro: Exception);
  end;

implementation

class function TLogInformation.GetUser: string;
var
  wSize: DWord;
begin
  wSize := 1024;
  SetLength(Result, wSize);
  GetUserName(PChar(Result), wSize);
  SetLength(Result, wSize - 1);
end;


class function TLogInformation.SystemVersion: string;
begin
  case System.SysUtils.Win32MajorVersion of
    5:
      case System.SysUtils.Win32MinorVersion of
        1: Result := 'Windows XP';
      end;
    6:
      case System.SysUtils.Win32MinorVersion of
        0: Result := 'Windows Vista';
        1: Result := 'Windows 7';
        2: Result := 'Windows 8';
        3: Result := 'Windows 8.1';
      end;
    10:
      case System.SysUtils.Win32MinorVersion of
        0: Result := 'Windows 10';
      end;
  end;
end;

class procedure TLogInformation.SaveFormImage(const pFileName: string);
var
  lBitmap: TBitmap;
  lJPEG: TJpegImage;
begin
  if Assigned(Screen.ActiveForm) then
  begin
    lJPEG := TJpegImage.Create;
    try
      lBitmap := Screen.ActiveForm.GetFormImage;
      lJPEG.Assign(lBitmap);
      lJPEG.SaveToFile(Format('%s\%s.jpg', [GetCurrentDir, pFileName]));
    finally
      lJPEG.Free;
      lBitmap.Free;
    end;
  end;
end;


class procedure TLogInformation.SaveLog(pSender: TObject; pErro: Exception);
var
  sPath: string;
  lLogFile: TextFile;
  sDateTime: string;
begin
  sPath := GetCurrentDir + '\LogExcecoes.txt';
  AssignFile(lLogFile, sPath);
  if FileExists(sPath) then
    Append(lLogFile)
  else
    ReWrite(lLogFile);

  sDateTime := FormatDateTime('dd-mm-yyyy_hh-nn-ss', Now);


  TLogInformation.SaveFormImage(sDateTime);

  // Escreve os dados no arquivo de log
  WriteLn(lLogFile, 'Data/Hora.......: ' + DateTimeToStr(Now));
  WriteLn(lLogFile, 'Mensagem........: ' + pErro.Message);
  WriteLn(lLogFile, 'Classe Exceção..: ' + pErro.ClassName);
  if Assigned(Screen.ActiveForm) then
  begin
    WriteLn(lLogFile, 'Formulário......: ' + Screen.ActiveForm.Name);
  end;
  WriteLn(lLogFile, 'Unit............: ' + pSender.UnitName);
  if Assigned(Screen.ActiveControl) then
  begin
    WriteLn(lLogFile, 'Controle Visual.: ' + Screen.ActiveControl.Name);
  end;
  WriteLn(lLogFile, 'Usuário.........: ' + TLogInformation.GetUser);
  WriteLn(lLogFile, 'Versão Windows..: ' + TLogInformation.SystemVersion);
  WriteLn(lLogFile, StringOfChar('-', 70));

  // Fecha o arquivo
  CloseFile(lLogFile);
end;

class procedure TLogInformation.ShowLogInformation(pErro: Exception);
var
  StringBuilder: TStringBuilder;
begin
  StringBuilder := TStringBuilder.Create;
  try
    StringBuilder
      .AppendLine('Ocorreu um erro durante a executação.')
      .AppendLine('Notifique o desenvolvedor para verificar os logs de erro.')
      .AppendLine(EmptyStr)
      .AppendLine('Informações técnicas:')
      .AppendLine(pErro.Message);

    MessageDlg(StringBuilder.ToString, mtWarning, [mbOK], 0);
  finally
    StringBuilder.Free;
  end;
end;



end.
