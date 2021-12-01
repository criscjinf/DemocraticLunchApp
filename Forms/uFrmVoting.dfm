inherited FrmVoting: TFrmVoting
  Caption = 'Democratic Lunch'
  ClientHeight = 466
  ClientWidth = 641
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 657
  ExplicitHeight = 505
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 425
    Width = 641
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnNext: TButton
      Left = 544
      Top = 6
      Width = 80
      Height = 25
      Caption = 'Continuar >>'
      TabOrder = 0
      OnClick = btnNextClick
    end
  end
  object pgcVoting: TPageControl
    Left = 0
    Top = 0
    Width = 641
    Height = 425
    ActivePage = tsStart
    Align = alClient
    MultiLine = True
    TabOrder = 1
    object tsNewtVoting: TTabSheet
      Caption = 'Come'#231'ar Vota'#231#227'o'
      ImageIndex = 3
      object lblNewVoting: TLabel
        Left = 147
        Top = 175
        Width = 320
        Height = 46
        Alignment = taCenter
        Caption = 'Nenhum vota'#231#227'o em andamento.'#13#10'Deseja iniciar uma nova vota'#231#227'o?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMenuHighlight
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object tsStart: TTabSheet
      Caption = 'Iniciar'
      object lblCPF: TLabel
        Left = 96
        Top = 101
        Width = 95
        Height = 13
        Caption = 'Informe seu CPF:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblName: TLabel
        Left = 156
        Top = 129
        Width = 35
        Height = 13
        Caption = 'Nome:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblEmail: TLabel
        Left = 153
        Top = 156
        Width = 38
        Height = 13
        Caption = 'E-mail:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblERROR: TLabel
        Left = 102
        Top = 184
        Width = 430
        Height = 38
        Alignment = taCenter
        Caption = 
          'Aten'#231#227'o! Usu'#225'rio n'#227'o cadastrado'#13#10'Informe os campos "Nome" e "e-m' +
          'ail" para continuar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtCPF: TMaskEdit
        Left = 197
        Top = 98
        Width = 93
        Height = 21
        EditMask = '999\.999\.999\-99;0;_'
        MaxLength = 14
        TabOrder = 0
        OnExit = edtCPFExit
      end
      object edtName: TEdit
        Left = 197
        Top = 125
        Width = 364
        Height = 21
        TabOrder = 1
        OnKeyUp = edtNameKeyUp
      end
      object edtEmail: TEdit
        Left = 197
        Top = 152
        Width = 364
        Height = 21
        TabOrder = 2
        OnKeyUp = edtNameKeyUp
      end
      object grpInfo: TGroupBox
        Left = 3
        Top = 330
        Width = 350
        Height = 64
        Caption = 'Vota'#231#227'o Encerra em:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object lblCaptionData: TLabel
          Left = 16
          Top = 25
          Width = 93
          Height = 19
          Caption = 'Data/Hora:'
        end
        object lblData: TLabel
          Left = 115
          Top = 25
          Width = 59
          Height = 19
          Caption = 'lblData'
        end
      end
    end
    object tsVote: TTabSheet
      Caption = 'Votar'
      ImageIndex = 1
      inline frameVote1: TframeVote
        Left = 0
        Top = 0
        Width = 633
        Height = 397
        Align = alClient
        Color = clWindow
        ParentBackground = False
        ParentColor = False
        TabOrder = 0
        ExplicitWidth = 633
        ExplicitHeight = 397
        inherited lblRestaurant: TLabel
          Left = 187
          Top = 165
          Width = 258
          Caption = 'Selecione o restaurante em que deseja votar:'
          ExplicitLeft = 187
          ExplicitTop = 165
          ExplicitWidth = 258
        end
        inherited lblWelcome: TLabel
          Left = 119
          Alignment = taCenter
          ExplicitLeft = 119
        end
        inherited cbbRestaurants: TComboBox
          Left = 150
          Top = 184
          Width = 332
          Style = csDropDownList
          Text = ''
          ExplicitLeft = 150
          ExplicitTop = 184
          ExplicitWidth = 332
        end
      end
    end
    object tsFinal: TTabSheet
      Caption = 'Finalizar'
      ImageIndex = 2
      object pnlFinalMsg: TPanel
        Left = 0
        Top = 0
        Width = 633
        Height = 397
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object lblMsg: TLabel
          Left = 147
          Top = 175
          Width = 339
          Height = 46
          Alignment = taCenter
          Caption = 
            'Vota'#231#227'o finalizada com sucesso'#13#10'Aguarde o resultado em seu e-mai' +
            'l.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMenuHighlight
          Font.Height = -19
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object appEvents: TApplicationEvents
    OnException = appEventsException
    Left = 312
    Top = 240
  end
end
