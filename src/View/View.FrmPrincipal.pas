unit View.FrmPrincipal;

interface

uses
  vcl.Styles,
  vcl.Themes,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.StdCtrls,
  Controller.Formularios,
  Controller.ComponenteQuery,
  Controller.Conexao;

type
  TFrmPrincipal = class(TForm)
    pnPrincipal: TPanel;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    mCompras: TMenuItem;
    mVendas: TMenuItem;
    mFinanceiro: TMenuItem;
    mRH: TMenuItem;
    mUtilitarios: TMenuItem;
    mComprasCadastros: TMenuItem;
    mComprasCadastros_Produtos: TMenuItem;
    mVendasCadastros: TMenuItem;
    mVendasCadastros_Clientes: TMenuItem;
    mFinanceiroCadastro: TMenuItem;
    mFinanceiroCadastros_Bancos: TMenuItem;
    mRHCadastros: TMenuItem;
    mRHCadastros_Funcionarios: TMenuItem;
    mUtilitariosCadastros: TMenuItem;
    mUtilitariosCadastros_Usuarios: TMenuItem;
    mComprasCadastros_Unidades: TMenuItem;
    mComprasCadastros_Fornecedores: TMenuItem;
    mComprasCadastros_Fabricantes: TMenuItem;
    mUtilitariosCadastros_Empresa: TMenuItem;
    mComprasCadastros_Grupos: TMenuItem;
    mComprasCadastros_SubGrupos: TMenuItem;
    cbStyles: TComboBox;
    procedure mComprasCadastros_ProdutosClick(Sender: TObject);
    procedure mVendasCadastros_ClientesClick(Sender: TObject);
    procedure mFinanceiroCadastros_BancosClick(Sender: TObject);
    procedure mRHCadastros_FuncionariosClick(Sender: TObject);
    procedure mUtilitariosCadastros_UsuariosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mComprasCadastros_UnidadesClick(Sender: TObject);
    procedure mComprasCadastros_FornecedoresClick(Sender: TObject);
    procedure mComprasCadastros_FabricantesClick(Sender: TObject);
    procedure mUtilitariosCadastros_EmpresaClick(Sender: TObject);
    procedure mComprasCadastros_GruposClick(Sender: TObject);
    procedure mComprasCadastros_SubGruposClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbStylesChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadStyles;
  public
    { Public declarations }
    procedure TabEnter(Key :Char);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.cbStylesChange(Sender: TObject);
begin
  TStyleManager.TrySetStyle(cbStyles.Items[cbStyles.ItemIndex]);
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  TControllerConexao
   .New
    .Conexao;
end;

procedure TFrmPrincipal.mVendasCadastros_ClientesClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroPessoas
     .CadastroPessoas(Self,'Cadastro de Clientes')
      .ShowModal;
end;

procedure TFrmPrincipal.TabEnter(Key: Char);
begin
  If Key = #13 then //Se o comando for igual a enter
  Begin
    Key := #0;
    Screen.ActiveForm.Perform(WM_NextDlgCtl, 0, 0);
  End;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  LoadStyles;
end;

procedure TFrmPrincipal.LoadStyles;
 var
  ssTyles : string;
begin
  cbStyles.Items.BeginUpdate;
  try
    cbStyles.Items.Clear;
      for ssTyles in TStyleManager.StyleNames do
        cbStyles.Items.add(ssTyles);
      cbStyles.Sorted := true;
      cbStyles.ItemIndex := cbStyles.Items.IndexOf(TStyleManager.ActiveStyle.Name);
    finally
      cbStyles.Items.EndUpdate;
  end;
end;

procedure TFrmPrincipal.mComprasCadastros_FabricantesClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroPessoas
     .CadastroPessoas(Self,'Cadastro de Fabricantes')
      .ShowModal;
end;

procedure TFrmPrincipal.mComprasCadastros_FornecedoresClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroPessoas
     .CadastroPessoas(Self,'Cadastro de Fornecedores')
      .ShowModal;
end;

procedure TFrmPrincipal.mComprasCadastros_GruposClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroGrupos
     .CadastroGrupos(Self)
      .ShowModal;
end;

procedure TFrmPrincipal.mComprasCadastros_ProdutosClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroProdutos
     .CadastroProdutos(Self)
      .ShowModal;
end;

procedure TFrmPrincipal.mComprasCadastros_SubGruposClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroSubGrupos
     .CadastroSubGrupos(Self)
      .ShowModal;
end;

procedure TFrmPrincipal.mComprasCadastros_UnidadesClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroUnidades
     .CadastroUnidades(Self)
      .ShowModal;
end;

procedure TFrmPrincipal.mFinanceiroCadastros_BancosClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroBancos
     .CadastroBanco(Self)
      .ShowModal;
end;

procedure TFrmPrincipal.mRHCadastros_FuncionariosClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroPessoas
     .CadastroPessoas(Self,'Cadastro de Funcionarios')
      .ShowModal;
end;

procedure TFrmPrincipal.mUtilitariosCadastros_EmpresaClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroPessoas
     .CadastroPessoas(Self,'Cadastro de Empresas')
      .ShowModal;
end;

procedure TFrmPrincipal.mUtilitariosCadastros_UsuariosClick(Sender: TObject);
begin
  TAbrirFormularios
   .New
    .CadastroUsuarios
     .CadastroUsuarios(Self)
      .ShowModal;
end;
end.
