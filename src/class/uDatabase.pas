unit uDatabase;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.SysUtils, System.Variants, System.Classes, Vcl.Controls,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
  TSQLiteConnection = class(TFDConnection)
  private
    { private declarations }
    FSQLiteDriverLink: TFDPhysSQLiteDriverLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function getConnection: TFDConnection; static;
  end;

var
  SQLiteConn: TFDConnection;

implementation

{ TDatabaseConnection }

constructor TSQLiteConnection.Create(AOwner: TComponent);
begin
  inherited;
  FSQLiteDriverLink := TFDPhysSQLiteDriverLink.Create(Self);
  Self.DriverName := 'SQLite';
  Self.Params.Database := '.\..\..\..\database\jsdownloader.db';
end;

destructor TSQLiteConnection.Destroy;
begin
  Self.CloneConnection;
  FSQLiteDriverLink.Free;
  inherited;
end;

class function TSQLiteConnection.getConnection: TFDConnection;
begin
  Result := TFDConnection(TSQLiteConnection.Create(nil));
end;

end.

