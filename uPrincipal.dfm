object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 424
  ClientWidth = 677
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 677
    Height = 424
    ActivePage = tsRTTI
    Align = alClient
    TabOrder = 0
    object tsRTTI: TTabSheet
      Caption = 'tsRTTI'
      object Memo1: TMemo
        Left = 0
        Top = 79
        Width = 669
        Height = 317
        Align = alClient
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 669
        Height = 79
        Align = alTop
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 1
        object Label1: TLabel
          Left = 6
          Top = 4
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object Label2: TLabel
          Left = 138
          Top = 4
          Width = 28
          Height = 13
          Caption = 'Idade'
        end
        object edtNome: TEdit
          Left = 6
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edtIdade: TEdit
          Left = 138
          Top = 20
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object btnSalvar: TButton
          Left = 270
          Top = 18
          Width = 75
          Height = 25
          Caption = 'Salvar'
          TabOrder = 2
          OnClick = btnSalvarClick
        end
        object chkLogarChamadas: TCheckBox
          Left = 368
          Top = 3
          Width = 97
          Height = 17
          Caption = 'Logar Chamadas'
          TabOrder = 3
        end
        object chkValidarIdade: TCheckBox
          Left = 368
          Top = 26
          Width = 97
          Height = 17
          Caption = 'Validade Idade'
          TabOrder = 4
        end
        object btnLerAtributos: TButton
          Left = 0
          Top = 44
          Width = 123
          Height = 25
          Caption = 'btnLerAtributos'
          TabOrder = 5
          OnClick = btnLerAtributosClick
        end
        object btnLerValoresObjeto: TButton
          Left = 126
          Top = 44
          Width = 123
          Height = 25
          Caption = 'btnLerValoresObjeto'
          TabOrder = 6
          OnClick = btnLerValoresObjetoClick
        end
        object btnInvocarMetodo: TButton
          Left = 255
          Top = 44
          Width = 123
          Height = 25
          Caption = 'btnInvocarMetodo'
          TabOrder = 7
          OnClick = btnInvocarMetodoClick
        end
        object btnLerFields: TButton
          Left = 384
          Top = 44
          Width = 123
          Height = 25
          Caption = 'btnLerFields'
          TabOrder = 8
          OnClick = btnLerFieldsClick
        end
        object chkOpcao1: TCheckBox
          Left = 512
          Top = 8
          Width = 97
          Height = 17
          Caption = 'chkOpcao1'
          TabOrder = 9
        end
        object chkOpcao2: TCheckBox
          Left = 513
          Top = 26
          Width = 97
          Height = 17
          Caption = 'chkOpcao2'
          TabOrder = 10
        end
      end
    end
    object tsScript: TTabSheet
      Caption = 'tsScript'
      object MemoScript: TMemo
        Left = 0
        Top = 47
        Width = 669
        Height = 349
        Align = alClient
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 669
        Height = 47
        Align = alTop
        Caption = 'Panel2'
        ShowCaption = False
        TabOrder = 1
        object btnExecutar: TButton
          Left = 6
          Top = 9
          Width = 75
          Height = 25
          Caption = 'btnExecutar'
          TabOrder = 0
        end
      end
    end
  end
end
