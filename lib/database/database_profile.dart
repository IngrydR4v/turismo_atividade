class DatabaseProvider {
  static const _dbName = 'pontos_turisticos_md.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {

    await db.execute(''' 
      CREATE TABLE ${PontoTuristico.nomeTabela} (
        ${PontoTuristico.campoId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontoTuristico.campoNome} TEXT NOT NULL,
        ${PontoTuristico.campoDetalhes} TEXT,
        ${PontoTuristico.campoDiferenciais} TEXT,
        ${PontoTuristico.campoInclusao} TEXT
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  getDatabasesPath() {}

  openDatabase(String dbPath, {required int version, required Future<void> Function(Database db, int version) onCreate, required Future<void> Function(Database db, int oldVersion, int newVersion) onUpgrade}) {}

}

class PontoTuristico {
  static var nomeTabela;
  static var campoId;
  static var campoNome;
  static var campoDiferenciais;
  static var campoDetalhes;
  static var campoInclusao;
}

class Database {
  close() {}

  execute(String s) {}
}