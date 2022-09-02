object DataModule1: TDataModule1
  Height = 474
  Width = 728
  object FDQueryCrearBaseDatos: TFDQuery
    Connection = FDConnectionElectricHome
    SQL.Strings = (
      '--Tabla: Registros'
      ''
      '--DROP TABLE Registros;'
      ''
      'CREATE TABLE IF NOT EXISTS Registros ('
      '  ID_REGISTROS  integer NOT NULL PRIMARY KEY AUTOINCREMENT,'
      '  ANTERIOR      integer,'
      '  ACTUAL        integer NOT NULL,'
      '  FECHA         date NOT NULL,'
      '  SUMA          integer,'
      '  PRECIO        numeric(50)'
      ');')
    Left = 368
    Top = 208
  end
  object FDConnectionElectricHome: TFDConnection
    Params.Strings = (
      'Database=ElectricHome.db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = FDConnectionElectricHomeBeforeConnect
    Left = 160
    Top = 162
  end
end
