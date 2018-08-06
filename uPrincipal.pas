unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, System.Rtti,
  IniFiles, Generics.Collections;

type
  IRTTIIniFile = interface;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    tsRTTI: TTabSheet;
    Memo1: TMemo;
    Panel1: TPanel;
    edtNome: TEdit;
    edtIdade: TEdit;
    btnSalvar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    chkLogarChamadas: TCheckBox;
    chkValidarIdade: TCheckBox;
    btnLerAtributos: TButton;
    btnLerValoresObjeto: TButton;
    btnInvocarMetodo: TButton;
    btnLerFields: TButton;
    tsScript: TTabSheet;
    MemoScript: TMemo;
    Panel2: TPanel;
    btnExecutar: TButton;
    chkOpcao1: TCheckBox;
    chkOpcao2: TCheckBox;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnLerAtributosClick(Sender: TObject);
    procedure btnLerValoresObjetoClick(Sender: TObject);
    procedure btnInvocarMetodoClick(Sender: TObject);
    procedure btnLerFieldsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FIniRTTI: IRTTIIniFile;
  public

  end;


  NotEmptyAttribute = class(TCustomAttribute)
  end;

  IdadeMinimaAttribute = class(TCustomAttribute)
  private
    FIdadeMinima: Integer;
  public
    constructor Create(const AIdadeMinima: Integer);
  end;

  IRTTIIniFile = interface
  ['{BBB05D93-37EA-4A42-A2DF-D28B8CDFD457}']
    function ReadString(const Section, Ident, Default: string): string;
    function WriteString(const Section, Ident, Value: string) : IRTTIIniFile;
    function BindProperty(AObject : TObject; AProp, ASection, AIdent : string; ADefault : TValue) : IRTTIIniFile;
    procedure SavePropertiesValues;
    procedure ReadPropertiesValues;
  end;

  TPessoa = class
  private
    FNome: string;
    FIdade: Integer;
    procedure SetNome(const Value: string);
    procedure SetIdade(const Value: Integer);
  published
    [NotEmpty]
    property Nome: string read FNome write SetNome;
    [IdadeMinima(18)]
    property Idade: Integer read FIdade write SetIdade;
  end;

  TPessoaDAO = class
  public
    function Salvar(APessoa: TPessoa): Boolean; virtual;
  end;

  TFuncoes = class
  public
    function Soma(const A, B: Integer): Integer;
  end;

  TRTTIIniFile = class(TInterfacedObject,IRTTIIniFile)
  strict private
    type
      RBindPropertyConf = record
        Obj : TObject;
        Prop : TRttiProperty;
        Section : string;
        Ident : string;
        DefaultValue : TValue;
      end;
  private
    FIniFile : TIniFile;
    FCreateOnRead : Boolean;
    FPropertyList : TList<RBindPropertyConf>;
    FRttiContext : TRttiContext;
    constructor Create(AFileName : string; ACreateOnRead : Boolean);
  public
    destructor Destroy; override;
    class function New(AFileName : string; ACreateOnRead : Boolean) : IRTTIIniFile;overload;
    class function New(AFileName : string) : IRTTIIniFile;overload;
    function ReadString(const Section: string; const Ident: string;
      const Default: string): string;
    function WriteString(const Section: string; const Ident: string;
      const Value: string): IRTTIIniFile;
    function BindProperty(AObject : TObject; AProp, ASection, AIdent : string; ADefault : TValue) : IRTTIIniFile;
    procedure ReadPropertiesValues;
    procedure SavePropertiesValues;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TPessoa }

procedure TPessoa.SetIdade(const Value: Integer);
begin
  FIdade := Value;
end;

procedure TPessoa.SetNome(const Value: string);
begin
  FNome := Value;
end;

{ TPessoaDAO }

function TPessoaDAO.Salvar(APessoa: TPessoa): Boolean;
begin
  Result := True;
end;

procedure TForm1.btnInvocarMetodoClick(Sender: TObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
  LFuncoes: TFuncoes;
begin
  Memo1.Lines.Clear;
  LContext := TRttiContext.Create;
  LType := LContext.GetType(TFuncoes);
  LFuncoes := TFuncoes.Create;
  try
    LMethod := LType.GetMethod('Soma');
    Memo1.Lines.Add('SOMA: ' + LMethod.Invoke(LFuncoes, [2, 4]).AsInteger.ToString);
  finally
    LFuncoes.Free;
    LContext.Free;
    LType.Free;
  end;
end;

procedure TForm1.btnLerAtributosClick(Sender: TObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperty: TRttiProperty;
  LCustomAttribute: TCustomAttribute;
begin
  Memo1.Lines.Clear;
  LContext := TRttiContext.Create;
  LType := LContext.GetType(TPessoa);
  try
    for LProperty in LType.GetProperties do
      for LCustomAttribute in LProperty.GetAttributes do
      begin
        if LCustomAttribute is NotEmptyAttribute then
          Memo1.Lines.Add(LProperty.ToString + ' ' + NotEmptyAttribute.ClassName)
        else
        if LCustomAttribute is IdadeMinimaAttribute then
          Memo1.Lines.Add(LProperty.ToString + ' ' + IdadeMinimaAttribute.ClassName + ' ' +
            IdadeMinimaAttribute(LCustomAttribute).FIdadeMinima.ToString);
      end;
  finally
    LType.Free;
    LContext.Free;
  end;
end;

procedure TForm1.btnLerFieldsClick(Sender: TObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LPessoa: TPessoa;
begin
  Memo1.Lines.Clear;
  LContext := TRttiContext.Create;
  LPessoa := TPessoa.Create;
  LType := LContext.GetType(TPessoa);
  try
    LPessoa.Nome := 'MARIO';
    LPessoa.Idade := 15;
    for LField in LType.GetFields do
      Memo1.Lines.Add(LField.Name);
  finally
    LPessoa.Free;
    LType.Free;
    LContext.Free;
  end;
end;

procedure TForm1.btnLerValoresObjetoClick(Sender: TObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperty: TRttiProperty;
  LPessoa: TPessoa;
begin
  Memo1.Lines.Clear;
  LContext := TRttiContext.Create;
  LPessoa := TPessoa.Create;
  LType := LContext.GetType(TPessoa);
  try
    LPessoa.Nome := 'MARIO';
    LPessoa.Idade := 15;
    for LProperty in LType.GetProperties do
      Memo1.Lines.Add(LProperty.GetValue(LPessoa).ToString);
  finally
    LPessoa.Free;
    LType.Free;
    LContext.Free;
  end;
end;

procedure TForm1.btnSalvarClick(Sender: TObject);
var
  LPessoa: TPessoa;
  LPessoaDAO: TPessoaDAO;
  LVirtualMethodInterceptor: TVirtualMethodInterceptor;
begin
  LPessoa := TPessoa.Create;
  LPessoaDAO := TPessoaDAO.Create;
  LVirtualMethodInterceptor := TVirtualMethodInterceptor.Create(TPessoaDAO);
  try
    LVirtualMethodInterceptor.OnBefore :=
    procedure(Instance: TObject; Method: TRttiMethod; const Args: TArray<TValue>; out DoInvoke: Boolean;
    out Result: TValue)
    begin
      if Method.Parent.AsInstance.MetaclassType <> TPessoaDAO then
        Exit;
      if Method.Name = 'Salvar' then
      begin
        if chkValidarIdade.Checked then
        begin
          if Args[0].AsType<TPessoa>.Idade < 18 then
          begin
            ShowMessage('Não é permitido pessoas menores de idade');
            DoInvoke := False;
            Exit;
          end;
        end;
      end;
    end;

    LVirtualMethodInterceptor.OnAfter :=
    procedure(Instance: TObject;
    Method: TRttiMethod; const Args: TArray<TValue>; var Result: TValue)
    begin
      if Method.Parent.AsInstance.MetaclassType <> TPessoaDAO then
        Exit;
      if chkLogarChamadas.Checked then
        Memo1.Lines.Add(Method.ToString);
    end;

    LVirtualMethodInterceptor.Proxify(LPessoaDAO);
    LPessoa.Nome := edtNome.Text;
    LPessoa.Idade := StrToIntDef(edtIdade.Text, 0);
    LPessoaDAO.Salvar(LPessoa);
  finally
    LPessoa.Free;
    LPessoaDAO.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  LIni: TIniFile;
begin
  {LIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'opcoes.ini');
  try
    chkLogarChamadas.Checked := LIni.ReadBool('CONFIG', 'LOGARCHAMADAS', False);
    chkValidarIdade.Checked :=  LIni.ReadBool('CONFIG', 'VALIDARIDADE', False);
    chkOpcao1.Checked := LIni.ReadBool('CONFIG', 'OPCAO1', False);
    chkOpcao2.Checked := LIni.ReadBool('CONFIG', 'OPCAO2', False);
    edtNome.Text := LIni.ReadString('CONFIG', 'NOME', '');
    edtIdade.Text := LIni.ReadString('CONFIG', 'IDADE', '0')
  finally
    LIni.Free;
  end;}
  FIniRTTI := TRTTIIniFile.New(ExtractFilePath(ParamStr(0)) + 'opcoesRTTI.ini');
  FIniRTTI.BindProperty(chkLogarChamadas, 'Checked', 'CONFIG', 'LOGARCHAMADAS', False);
  FIniRTTI.BindProperty(chkValidarIdade, 'Checked', 'CONFIG', 'VALIDARIDADE', False);
  FIniRTTI.BindProperty(chkOpcao1, 'Checked', 'CONFIG', 'OPCAO1', False);
  FIniRTTI.BindProperty(chkOpcao2, 'Checked', 'CONFIG', 'OPCAO2', False);
  FIniRTTI.BindProperty(edtNome, 'Text', 'CONFIG', 'NOME', '');
  FIniRTTI.BindProperty(edtIdade, 'Text', 'CONFIG', 'IDADE', '0');
  FIniRTTI.ReadPropertiesValues;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  LIni: TIniFile;
begin
  {LIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'opcoes.ini');
  try
    LIni.WriteBool('CONFIG', 'LOGARCHAMADAS', chkLogarChamadas.Checked);
    LIni.WriteBool('CONFIG', 'VALIDARIDADE', chkValidarIdade.Checked);
    LIni.WriteBool('CONFIG', 'OPCAO1', chkOpcao1.Checked);
    LIni.WriteBool('CONFIG', 'OPCAO2', chkOpcao2.Checked);
    LIni.WriteString('CONFIG', 'NOME', edtNome.Text);
    LIni.WriteString('CONFIG', 'IDADE', edtIdade.Text);
  finally
    LIni.Free;
  end;}
  FIniRTTI.SavePropertiesValues;
end;

{ IdadeMinimaAttribute }

constructor IdadeMinimaAttribute.Create(const AIdadeMinima: Integer);
begin
  FIdadeMinima := AIdadeMinima;
end;

{ TFuncoes }

function TFuncoes.Soma(const A, B: Integer): Integer;
begin
  Result := a + B;
end;

{ TRTTIIniFile }

function TRTTIIniFile.BindProperty(AObject: TObject; AProp, ASection, AIdent: string;
  ADefault: TValue): IRTTIIniFile;
var LType : TRttiType;
    LProperty : TRttiProperty;
    LBindPropertyConf : RBindPropertyConf;
begin
  LType := FRttiContext.GetType(AObject.ClassType);
{  for LProperty in LType.GetDeclaredProperties do
  begin
    if SameText(LProperty.Name, AProp) then
    begin
      LBindPropertyConf := default(RBindPropertyConf);
      LBindPropertyConf.Obj := AObject;
      LBindPropertyConf.Prop := LProperty;
      LBindPropertyConf.Section := ASection;
      LBindPropertyConf.Ident := AIdent;
      LBindPropertyConf.DefaultValue := ADefault;
      FPropertyList.Add(LBindPropertyConf);
      Break;
    end;
  end;}
  for LProperty in LType.GetProperties do
  begin
    if SameText(LProperty.Name, AProp) then
    begin
      LBindPropertyConf := default(RBindPropertyConf);
      LBindPropertyConf.Obj := AObject;
      LBindPropertyConf.Prop := LProperty;
      LBindPropertyConf.Section := ASection;
      LBindPropertyConf.Ident := AIdent;
      LBindPropertyConf.DefaultValue := ADefault;
      FPropertyList.Add(LBindPropertyConf);
      Break;
    end;
  end;
end;

constructor TRTTIIniFile.Create(AFileName: string; ACreateOnRead: Boolean);
begin
  FRttiContext := TRttiContext.Create;
  FRttiContext.KeepContext;
  FIniFile := TIniFile.Create(AFileName);
  FCreateOnRead := ACreateOnRead;
  FPropertyList := TList<RBindPropertyConf>.Create;
end;

destructor TRTTIIniFile.Destroy;
begin
  FIniFile.Free;
  FPropertyList.Free;
  FRttiContext.DropContext;
  inherited;
end;

class function TRTTIIniFile.New(AFileName: string; ACreateOnRead: Boolean): IRTTIIniFile;
begin
  Result := Self.Create(AFileName,ACreateOnRead);
end;

class function TRTTIIniFile.New(AFileName: string): IRTTIIniFile;
begin
  Result := New(AFileName,True);
end;

procedure TRTTIIniFile.ReadPropertiesValues;
var LBindPropertyConf : RBindPropertyConf;
    LProperty : TRttiProperty;
    LObject : TObject;
    LValue, LDefaultValue : TValue;
    LSection, LIdent : string;
begin
  for LBindPropertyConf in FPropertyList do
  begin
    LSection := LBindPropertyConf.Section;
    LIdent := LBindPropertyConf.Ident;
    LDefaultValue := LBindPropertyConf.DefaultValue;
    LProperty := LBindPropertyConf.Prop;
    LObject := LBindPropertyConf.Obj;
    case LBindPropertyConf.Prop.PropertyType.TypeKind of
      tkInteger, tkInt64, tkEnumeration : LValue := TValue.FromOrdinal(LDefaultValue.TypeInfo, ReadString(LSection, LIdent, LDefaultValue.AsOrdinal.ToString).ToInteger);
      tkChar, tkString, tkWChar, tkLString, tkWString, tkUString: LValue := TValue.From<string>(ReadString(LSection, LIdent, LDefaultValue.ToString));
      tkFloat: LValue := TValue.From<Double>(ReadString(LSection, LIdent, LDefaultValue.ToString).ToDouble);
      tkVariant: raise Exception.Create('Não implementado');
    end;
    LProperty.SetValue(LObject, LValue);
  end;
end;

function TRTTIIniFile.ReadString(const Section, Ident, Default: string): string;
begin
  Result := FIniFile.ReadString(Section,Ident,Default);
  if Result = Default then
    FIniFile.WriteString(Section,Ident,Default);
end;

procedure TRTTIIniFile.SavePropertiesValues;
var LBindPropertyConf : RBindPropertyConf;
    LProperty : TRttiProperty;
    LObject : TObject;
    LSection, LIdent : string;
    LValue : TValue;
begin
  for LBindPropertyConf in FPropertyList do
  begin
    LSection := LBindPropertyConf.Section;
    LIdent := LBindPropertyConf.Ident;
    LProperty := LBindPropertyConf.Prop;
    LObject := LBindPropertyConf.Obj;
    LValue := LProperty.GetValue(LObject);
    case LBindPropertyConf.Prop.PropertyType.TypeKind of
      tkInteger, tkInt64, tkEnumeration : WriteString(LSection, LIdent, LValue.AsOrdinal.ToString);
      tkChar, tkString, tkWChar, tkLString, tkWString, tkUString: WriteString(LSection, LIdent, LValue.ToString);
      tkFloat: WriteString(LSection, LIdent, LValue.AsExtended.ToString);
      tkVariant: raise Exception.Create('Não implementado');
    end;
  end;
end;

function TRTTIIniFile.WriteString(const Section, Ident, Value: string): IRTTIIniFile;
begin
  FIniFile.WriteString(Section,Ident,Value);
  Result := Self;
end;

end.
