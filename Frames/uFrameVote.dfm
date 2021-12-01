object frameVote: TframeVote
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  Color = clWindow
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object lblRestaurant: TLabel
    Left = 144
    Top = 154
    Width = 237
    Height = 13
    Caption = 'Selecione o restaurante que deseja votar:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblWelcome: TLabel
    Left = 64
    Top = 72
    Width = 395
    Height = 29
    Caption = 'BEM VINDO A SALA DE VOTA'#199#195'O'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuHighlight
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cbbRestaurants: TComboBox
    Left = 80
    Top = 181
    Width = 393
    Height = 21
    TabOrder = 0
    Text = 'cbbRestaurants'
    OnClick = cbbRestaurantsClick
  end
end
