unit Model.Formularios;

interface

uses
 Vcl.Forms,
 Winapi.Messages,
 strutils,
 math,
 Data.DB,
 Interfaces.Formularios,
 View.Utilitarios.Cadastros.Usuarios,
 View.Compras.Cadastros.Produtos,
 View.Vendas.Cadastros.Pessoas,
 View.Financeiro.Cadastros.Bancos,
 View.Compras.Cadastros.Unidades,
 View.Compras.Cadastros.Grupos,
 View.Compras.Cadastros.SubGrupos,
 View.Consulta.Padrao;

  type
    TFormulario = class(TInterfacedObject, iFormularios)
      private
        FCaption : String;
      public
      constructor create;
      destructor destroy; override;
      class function New : iFormularios;
        function CadastroProdutos(Owner : TForm) : TFrmCadProdutos;
        function CadastroPessoas(Owner : TForm; aCaption : String) : TFrmCadPessoas;
        function CadastroBanco(Owner : TForm) : TFrmCadBancos;
        function CadastroUsuarios(Owner : TForm) : TFrmCadUsuarios;
        function CadastroUnidades(Owner : TForm) : TFrmCadUnidade;
        function CadastroGrupos(Owner : TForm) : TFrmGrupos;
        function CadastroSubGrupos(Owner : TForm) : TFrmSubGrupos;
        function Consulta(Owner : TForm; aCaption : String; aTabela : String) : TFrmConsultaPadrao;

        function TipoFormulario(aValue : String) : iFormularios;
    end;

implementation

{ tFormulario }

function TFormulario.CadastroGrupos(Owner: TForm): TFrmGrupos;
begin
  FrmGrupos := TFrmGrupos.Create(Owner);
  Result := FrmGrupos;
end;

function TFormulario.CadastroPessoas(Owner: TForm; aCaption : String): TFrmCadPessoas;
begin
  FrmCadPessoas := TFrmCadPessoas.Create(Owner);
  FrmCadPessoas.Caption := aCaption;
  Result := FrmCadPessoas;
end;

function tFormulario.CadastroProdutos(Owner: TForm): TFrmCadProdutos;
begin
  FrmCadProdutos := TFrmCadProdutos.Create(Owner);
  Result := FrmCadProdutos;
end;

function TFormulario.CadastroSubGrupos(Owner: TForm): TFrmSubGrupos;
begin
  FrmSubGrupos := TFrmSubGrupos.Create(Owner);
  Result := FrmSubGrupos;
end;

function TFormulario.CadastroUnidades(Owner: TForm): TFrmCadUnidade;
begin
  FrmCadUnidade := TFrmCadUnidade.Create(Owner);
  Result := FrmCadUnidade;
end;

function TFormulario.CadastroUsuarios(Owner: TForm): TFrmCadUsuarios;
begin
  FrmCadUsuarios := TFrmCadUsuarios.Create(Owner);
  Result := FrmCadUsuarios;
end;

function TFormulario.Consulta(Owner: TForm; aCaption : String; aTabela : String): TFrmConsultaPadrao;
begin
  FrmConsultaPadrao := TFrmConsultaPadrao.Create(Owner);
  FrmConsultaPadrao.caption := aCaption;
  FrmConsultaPadrao.aTabela := aTabela;
  Result := FrmConsultaPadrao;
end;

function TFormulario.CadastroBanco(Owner: TForm): TFrmCadBancos;
begin
  FrmCadBancos := TFrmCadBancos.Create(Owner);
  Result := FrmCadBancos;
end;

constructor tFormulario.create;
begin

end;

destructor tFormulario.destroy;
begin

  inherited;
end;

class function tFormulario.New: iFormularios;
begin
  Result := Self.create;
end;

function TFormulario.TipoFormulario(aValue: String): iFormularios;
begin
//
end;

end.
