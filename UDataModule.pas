unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDataModule1 = class(TDataModule)
    FDQueryCrearBaseDatos: TFDQuery;
    FDConnectionElectricHome: TFDConnection;
    procedure FDConnectionElectricHomeBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InicializarDB;
    constructor create(Aowner: tcomponent); override;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}
{ TDataModule1 }

uses
   System.ioutils;


constructor TDataModule1.create(Aowner: tcomponent);
begin
  inherited;
  InicializarDB;
end;


procedure TDataModule1.FDConnectionElectricHomeBeforeConnect(Sender: TObject);
begin
   {$IF DEFINED (ANDROID)}
  FDConnection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'REGISTROS.db');
{$ENDIF}
end;

procedure TDataModule1.InicializarDB;
begin
  FDQueryCrearBaseDatos.ExecSQL;
end;


end.
