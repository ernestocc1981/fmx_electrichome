unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.Bind.Grid, Data.Bind.Grid, FMX.Memo, Udatamodule, FMX.Memo.Types;

type
  TFPrincipal = class(TForm)
    ActionList1: TActionList;
    PreviousTabAction1: TPreviousTabAction;
    TitleAction: TControlAction;
    NextTabAction1: TNextTabAction;
    TopToolBar: TToolBar;
    btnBack: TSpeedButton;
    ToolBarLabel: TLabel;
    btnNext: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BottomToolBar: TToolBar;
    GridPanelLayout1: TGridPanelLayout;
    Edit1_Lectura_Anterior: TEdit;
    Edit2_Lectura_Actual: TEdit;
    Edit3ResultResta: TEdit;
    Edit4ResultGasto: TEdit;
    ClearEditButton2: TClearEditButton;
    Button1: TButton;
    DateEdit1: TDateEdit;
    Label5: TLabel;
    suiStringGrid1: TStringGrid;
    StringColumn7: TStringColumn;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    StringColumn6: TStringColumn;
    StringColumn8: TStringColumn;
    StringColumn9: TStringColumn;
    FDTableRergistros: TFDTable;
    FDTableRergistrosID_REGISTROS: TFDAutoIncField;
    FDTableRergistrosANTERIOR: TIntegerField;
    FDTableRergistrosACTUAL: TIntegerField;
    BindingsList1: TBindingsList;
    BindSourceDB1: TBindSourceDB;
    StringGrid1: TStringGrid;
    FDQuery1: TFDQuery;
    FDQuery1ID_REGISTROS: TFDAutoIncField;
    FDQuery1ANTERIOR: TIntegerField;
    FDQuery1ACTUAL: TIntegerField;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    FDQuery1SUMA: TIntegerField;
    FDTableRergistrosSUMA: TIntegerField;
    FDTableRergistrosFECHA: TDateField;
    FDQuery1FECHA: TDateField;
    Button2: TButton;
    FDTableRergistrosPRECIO: TFMTBCDField;
    FDQuery1PRECIO: TFMTBCDField;
    TabItem3: TTabItem;
    Button3: TButton;
    Memo1: TMemo;
    Image1: TImage;
    FDQueryCrearBaseDatos: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure TitleActionUpdate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Edit1_Lectura_AnteriorChangeTracking(Sender: TObject);
    procedure Edit2_Lectura_ActualChangeTracking(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.fmx}


procedure TFPrincipal.TitleActionUpdate(Sender: TObject);
begin
  if Sender is TCustomAction then
  begin
    if TabControl1.ActiveTab <> nil then
      TCustomAction(Sender).Text := TabControl1.ActiveTab.Text
    else
      TCustomAction(Sender).Text := '';
  end;
end;

procedure TFPrincipal.Button1Click(Sender: TObject);
var
  fecha1, fecha2: TDate;
//  lectura_anterior : string;
begin

  // INSERTO LOS DATOS
  BindSourceDB1.DataSource.DataSet.Edit;

  if FDQuery1.RecordCount <= 0 then
  begin
    BindSourceDB1.DataSource.DataSet.FieldByName('ANTERIOR').AsString :=
      Edit1_Lectura_Anterior.Text;
    BindSourceDB1.DataSource.DataSet.FieldByName('ACTUAL').AsString :=
      Edit2_Lectura_Actual.Text;
    BindSourceDB1.DataSource.DataSet.FieldByName('SUMA').AsString :=
      Edit3ResultResta.Text;
  end
  else
  begin
    FDQuery1.Active := TRUE;
    BindSourceDB2.DataSource.DataSet.Last;
    BindSourceDB1.DataSource.DataSet.FieldByName('ANTERIOR').AsString :=  BindSourceDB2.DataSource.DataSet.FieldByName('ACTUAL').AsString;
    BindSourceDB1.DataSource.DataSet.FieldByName('ACTUAL').AsString :=   Edit2_Lectura_Actual.Text;
    BindSourceDB1.DataSource.DataSet.FieldByName('SUMA').AsString := Edit3ResultResta.Text;
  end;

  BindSourceDB1.DataSource.DataSet.FieldByName('PRECIO').AsString :=
    Edit4ResultGasto.Text;
  BindSourceDB1.DataSource.DataSet.FieldByName('FECHA').AsDateTime :=
    DateEdit1.Date;

  // ASIGNO LAS FECHAS A LAS VARIABLES
  fecha1 := DateEdit1.Date;
  FDQuery1.Active := TRUE;
  FDQuery1.Last;
  fecha2 := BindSourceDB2.DataSource.DataSet.FieldByName('FECHA').AsDateTime;

  // PREGUNTO SI LA LECTURA ACTUAL ES MENOR O IGUAL QUE LA ANTERIOR
  if StrToInt(Edit2_Lectura_Actual.Text) <= StrToInt(Edit1_Lectura_Anterior.Text) then
  begin
    Label5.Text :=
      'No puede insertar lectura inferior a la última, Verifiquee!';
  end
  else
  begin

    // PARA QUE NO ME INSERTEN FECHA ANTERIOR A LA ULTIMA
    if fecha1 < fecha2 then
    BEGIN
      Label5.Text :=
        'No puede insertar fecha anterior a la última, Verifiquee!';

    END
    else
    begin

      BindSourceDB1.DataSource.DataSet.Insert;

      FDQuery1.Active := FALSE;
      FDQuery1.Active := TRUE;
      Edit1_Lectura_Anterior.Text := '';
      Edit2_Lectura_Actual.Text := '';
      Edit3ResultResta.Text := '';
      Edit4ResultGasto.Text := '';

      // AQUI PREGUNTO SI HAY DATOS EN EL REGISTRO, ENTONCES TOMO LA ULTIMA LECTURA
      if FDQuery1.RecordCount = 1 then
      begin
        FDQuery1.First;
        Edit1_Lectura_Anterior.Text := BindSourceDB2.DataSource.DataSet.FieldByName
          ('ANTERIOR').AsString;
        Edit2_Lectura_Actual.Text := '';
        Edit3ResultResta.Text := '';
        Edit4ResultGasto.Text := '';
      end
      else
      begin
        Edit1_Lectura_Anterior.Text := BindSourceDB2.DataSource.DataSet.FieldByName
          ('ANTERIOR').AsString;
        Edit2_Lectura_Actual.Text := '';
        Edit3ResultResta.Text := '';
        Edit4ResultGasto.Text := '';

      end;
    end;
  end;

end;

procedure TFPrincipal.Button2Click(Sender: TObject);
begin
  while not BindSourceDB1.DataSource.DataSet.Eof do
  begin
    BindSourceDB1.DataSource.DataSet.First;
    BindSourceDB1.DataSource.DataSet.delete;
    Edit1_Lectura_Anterior.Enabled := True;
    Edit1_Lectura_Anterior.Text := '';
    Edit2_Lectura_Actual.Text := '';
    Edit3ResultResta.Text := '';
    Edit4ResultGasto.Text := '';
    FDQuery1.Refresh;
  end;
    Edit1_Lectura_Anterior.Enabled := True;
    Edit1_Lectura_Anterior.Text := '';
    Edit2_Lectura_Actual.Text := '';
    Edit3ResultResta.Text := '';
    Edit4ResultGasto.Text := '';
    Label5.Text := '';
end;

procedure TFPrincipal.Edit1_Lectura_AnteriorChangeTracking(Sender: TObject);
var
  ValorAnterior, ValorActual, Resultado, Constante: Extended;

begin
  if ((Edit1_Lectura_Anterior.Text) <> '') and ((Edit2_Lectura_Actual.Text) <> '') then
  begin
    Label5.Text := '';

    // ASIGNACION DE VALORES
    ValorAnterior := StrToFloat(Edit1_Lectura_Anterior.Text);
    ValorActual := StrToFloat(Edit2_Lectura_Actual.Text);

    if (ValorAnterior < 1) or (ValorActual < 1) then
    begin
      Label5.Text := '!Error!, La Lectura Actual o Anterior no puede ser 0';
    end;

    // RESTA DEL VALOR ACTUAL MENOS EL ANTERIOR (CONSUMO)
    Resultado := (ValorActual - ValorAnterior);

    // MUESTRA EL RESULTADO QUE ES EL CONSUMO
    Edit3ResultResta.Text := FloatToStr(Resultado);

    if (Resultado > 5000) then
    begin
      Constante := 13459 + ((Resultado - 5000) * 5.00);
      Edit4ResultGasto.Text := FloatToStr(Constante);
    end;

    if Resultado <= 100 then
    begin
      Resultado := Resultado * 0.09;
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 101) and (Resultado <= 150) then
    begin
      Resultado := 9 + ((Resultado - 100) * 0.30);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 151) and (Resultado <= 200) then
    begin
      Resultado := 24 + ((Resultado - 150) * 0.40);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 201) and (Resultado <= 250) then
    begin
      Resultado := 44 + ((Resultado - 200) * 0.60);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 251) and (Resultado <= 300) then
    begin
      Resultado := 74 + ((Resultado - 250) * 0.80);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 301) and (Resultado <= 350) then
    begin
      Resultado := 114 + ((Resultado - 300) * 1.50);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 351) and (Resultado <= 500) then
    begin
      Resultado := 189 + ((Resultado - 350) * 1.80);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 501) and (Resultado <= 1000) then
    begin
      Resultado := 459 + ((Resultado - 500) * 2.00);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if (Resultado >= 1001) and (Resultado <= 5000) then
    begin
      Resultado := 1459 + ((Resultado - 1000) * 3.00);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
    end;

    if Resultado <= 0 then
      Label5.Text := '!Error!, La Lectura Actual debe ser Mayor que la Anterior'
    else
      Label5.Text := '';
  end
end;

procedure TFPrincipal.Edit2_Lectura_ActualChangeTracking(Sender: TObject);
var
  ValorAnterior, ValorActual, Resultado, Constante: Extended;

begin
  if ((Edit1_Lectura_Anterior.Text) <> '') and ((Edit2_Lectura_Actual.Text) <> '') then
  begin
    Label5.Text := '';

    // ASIGNACION DE VALORES

   if BindSourceDB1.DataSource.DataSet.RecordCount < 1 then
      begin
        Edit1_Lectura_Anterior.Enabled := True;
        ValorAnterior := StrToFloat(Edit1_Lectura_Anterior.Text);
        ValorActual := StrToFloat(Edit2_Lectura_Actual .Text);
        Edit1_Lectura_Anterior.Enabled := False;
      end
    else
      begin
        FDQuery1.First;
        ValorAnterior := BindSourceDB2.DataSource.DataSet.FieldByName('ANTERIOR').AsExtended;
        ValorActual := StrToFloat(Edit2_Lectura_Actual .Text);
        Edit1_Lectura_Anterior.Enabled := false;
      end;



    if ((ValorAnterior) < 1) or ((ValorActual) = 0) then
      Label5.Text := '!Error!, La Lectura Actual o Anterior no puede ser 0';

    if ((ValorActual) < 1) then
      Label5.Text := '!Error!, La Lectura Actual o Anterior no puede ser 0';

    // RESTA DEL VALOR ACTUAL MENOS EL ANTERIOR (CONSUMO)
    Resultado := (ValorActual - ValorAnterior);

    // MUESTRA EL RESULTADO QUE ES EL CONSUMO
    Edit3ResultResta.Text := FloatToStr(Resultado);

    if (Resultado > 5000) then
    begin
      Constante := 13459 + ((Resultado - 5000) * 5.00);
      Edit4ResultGasto.Text := FloatToStr(Constante);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := '40';
      suiStringGrid1.Cells[4, 6] := '75';
      suiStringGrid1.Cells[4, 7] := '270';
      suiStringGrid1.Cells[4, 8] := '1000';
      suiStringGrid1.Cells[4, 9] := '12000';
    end;

    if Resultado <= 100 then
    begin
      Resultado := Resultado * 0.09;
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[3, 1] := Edit3ResultResta.Text;
      suiStringGrid1.Cells[4, 1] := FloatToStr(Resultado);
    end;

    if (Resultado >= 101) and (Resultado <= 150) then
    begin
      Resultado := 9 + ((Resultado - 100) * 0.30);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := FloatToStr(Resultado - 9);
    end;

    if (Resultado >= 151) and (Resultado <= 200) then
    begin
      Resultado := 24 + ((Resultado - 150) * 0.40);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := FloatToStr(Resultado - 24);

    end;

    if (Resultado >= 201) and (Resultado <= 250) then
    begin
      Resultado := 44 + ((Resultado - 200) * 0.60);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := FloatToStr(Resultado - 48);

    end;

    if (Resultado >= 251) and (Resultado <= 300) then
    begin
      Resultado := 74 + ((Resultado - 250) * 0.80);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := FloatToStr(Resultado - 72);
    end;

    if (Resultado >= 301) and (Resultado <= 350) then
    begin
      Resultado := 114 + ((Resultado - 300) * 1.50);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := '40';
      suiStringGrid1.Cells[4, 6] := FloatToStr(Resultado - 144);
    end;

    if (Resultado >= 351) and (Resultado <= 500) then
    begin
      Resultado := 189 + ((Resultado - 350) * 1.80);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := '40';
      suiStringGrid1.Cells[4, 6] := '75';
      suiStringGrid1.Cells[4, 7] := FloatToStr(Resultado - 216);
    end;

    if (Resultado >= 501) and (Resultado <= 1000) then
    begin
      Resultado := 459 + ((Resultado - 500) * 2.00);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := '40';
      suiStringGrid1.Cells[4, 6] := '75';
      suiStringGrid1.Cells[4, 7] := '270';
    end;

    if (Resultado >= 1001) and (Resultado <= 5000) then
    begin
      Resultado := 1459 + ((Resultado - 1000) * 3.00);
      Edit4ResultGasto.Text := FloatToStr(Resultado);
      suiStringGrid1.Cells[4, 1] := '9';
      suiStringGrid1.Cells[4, 2] := '15';
      suiStringGrid1.Cells[4, 3] := '20';
      suiStringGrid1.Cells[4, 4] := '30';
      suiStringGrid1.Cells[4, 5] := '40';
      suiStringGrid1.Cells[4, 6] := '75';
      suiStringGrid1.Cells[4, 7] := '270';
      suiStringGrid1.Cells[4, 8] := '1000';
    end;

    if Resultado <= 0 then
      Label5.Text := '!Error!, La Lectura Actual debe ser Mayor que la Anterior'
    else
      Label5.Text := '';



  end

end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.First(TTabTransition.None);
end;

procedure TFPrincipal.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkHardwareBack) and (TabControl1.TabIndex <> 0) then
  begin
    TabControl1.First;
    Key := 0;
  end;
end;

procedure TFPrincipal.FormShow(Sender: TObject);
begin
  FDTableRergistros.Active := TRUE;
  FDQuery1.Active := TRUE;
  BindSourceDB1.DataSource.DataSet.Edit;
  BindSourceDB1.DataSource.DataSet.Insert;
  Edit3ResultResta.Text := '';
  Edit4ResultGasto.Text := '';
  FDQuery1.First;
  Edit1_Lectura_Anterior.Text := BindSourceDB2.DataSource.DataSet.FieldByName
    ('ANTERIOR').AsString;
  FDQuery1.Active := FALSE;
  FDQuery1.Active := TRUE;;
end;

end.
