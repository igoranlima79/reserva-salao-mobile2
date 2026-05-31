import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoSQLite {
  static final BancoSQLite instance = BancoSQLite._init();

  static Database? _database;

  BancoSQLite._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await iniciarBanco();
    return _database!;
  }

  Future<Database> iniciarBanco() async {
    String caminho = join(await getDatabasesPath(), 'imperial_luxor.db');

    return await openDatabase(
      caminho,
      version: 2,
      onCreate: criarBanco,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE usuarios ADD COLUMN telefone TEXT NOT NULL DEFAULT ""',
          );
        }
      },
    );
  }

  Future criarBanco(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        apartamento TEXT NOT NULL,
        login TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reservas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL UNIQUE,
        usuario_id INTEGER NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    await db.insert('usuarios', {
      'nome': 'Administrador',
      'email': 'admin@imperialluxor.com',
      'apartamento': 'Admin',
      'telefone': '11999999999',
      'login': 'admin',
      'senha': '1234',
      'tipo': 'administrador',
    });

    await db.insert('usuarios', {
      'nome': 'Maria',
      'telefone': '11987654321',
      'email': 'maria@email.com',
      'apartamento': '101',
      'login': 'maria',
      'senha': '1234',
      'tipo': 'condomino',
    });
  }

  Future<Map<String, dynamic>?> fazerLogin(
    String login,
    String senha,
  ) async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.query(
      'usuarios',
      where: 'login = ? AND senha = ?',
      whereArgs: [login, senha],
    );

    if (resultado.isNotEmpty) {
      return resultado.first;
    }

    return null;
  }

  Future<bool> usuarioJaExiste(
    String nome,
    String email,
    String login,
  ) async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.query(
      'usuarios',
      where: 'nome = ? OR email = ? OR login = ?',
      whereArgs: [nome, email, login],
    );

    return resultado.isNotEmpty;
  }

  Future<bool> cadastrarCondomino({
    required String nome,
    required String telefone,
    required String email,
    required String apartamento,
    required String login,
    required String senha,
  }) async {
    final db = await database;

    bool existe = await usuarioJaExiste(nome, email, login);

    if (existe) {
      return false;
    }

    await db.insert('usuarios', {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'apartamento': apartamento,
      'login': login,
      'senha': senha,
      'tipo': 'condomino',
    });

    return true;
  }

  Future<bool> cadastrarAdministrador({
    required String nome,
    required String telefone,
    required String email,
    required String login,
    required String senha,
  }) async {
    final db = await database;

    bool existe = await usuarioJaExiste(nome, email, login);

    if (existe) {
      return false;
    }

    await db.insert('usuarios', {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'apartamento': 'Admin',
      'login': login,
      'senha': senha,
      'tipo': 'administrador',
    });

    return true;
  }

  Future<bool> editarCondomino({
    required int id,
    required String nome,
    required String telefone,
    required String email,
    required String apartamento,
    required String login,
    String? senha,
  }) async {
    final db = await database;

    final existente = await db.query(
      'usuarios',
      where: '(email = ? OR login = ?) AND id != ?',
      whereArgs: [email, login, id],
    );

    if (existente.isNotEmpty) return false;

    final Map<String, dynamic> dados = {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'apartamento': apartamento,
      'login': login,
    };

    if (senha != null) {
      dados['senha'] = senha;
    }

    await db.update(
      'usuarios',
      dados,
      where: 'id = ?',
      whereArgs: [id],
    );

    return true;
  }

  Future<int> totalCondominos() async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM usuarios WHERE tipo = 'condomino'",
    );

    return resultado.first['total'] as int;
  }

  Future<int> totalReservas() async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM reservas',
    );

    return resultado.first['total'] as int;
  }

  Future<bool> dataTemReserva(String data) async {
    final db = await database;

    List<Map<String, dynamic>> resultado = await db.query(
      'reservas',
      where: 'data = ?',
      whereArgs: [data],
    );

    return resultado.isNotEmpty;
  }

  Future<bool> criarReserva({
    required String data,
    required int usuarioId,
  }) async {
    final db = await database;

    bool reservada = await dataTemReserva(data);

    if (reservada) {
      return false;
    }

    await db.insert('reservas', {
      'data': data,
      'usuario_id': usuarioId,
      'status': 'Reservado',
    });

    return true;
  }

  Future<List<Map<String, dynamic>>> reservasDaData(String data) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        reservas.id,
        reservas.data,
        reservas.status,
        usuarios.nome,
        usuarios.apartamento
      FROM reservas
      INNER JOIN usuarios ON reservas.usuario_id = usuarios.id
      WHERE reservas.data = ?
    ''', [data]);
  }

  Future<List<Map<String, dynamic>>> reservasDoUsuario(int usuarioId) async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        reservas.id,
        reservas.data,
        reservas.status,
        usuarios.nome,
        usuarios.apartamento
      FROM reservas
      INNER JOIN usuarios ON reservas.usuario_id = usuarios.id
      WHERE reservas.usuario_id = ?
      ORDER BY reservas.data
    ''', [usuarioId]);
  }

  Future<void> cancelarReserva(int reservaId) async {
    final db = await database;

    await db.delete(
      'reservas',
      where: 'id = ?',
      whereArgs: [reservaId],
    );
  }

  Future<List<Map<String, dynamic>>> listarCondominos() async {
    final db = await database;
    return await db.query(
      'usuarios',
      where: 'tipo = ?',
      whereArgs: ['condomino'],
      orderBy: 'nome',
    );
  }

  Future<List<Map<String, dynamic>>> listarAdministradores() async {
    final db = await database;
    return await db.query(
      'usuarios',
      where: 'tipo = ?',
      whereArgs: ['administrador'],
      orderBy: 'nome',
    );
  }

  Future<void> excluirUsuario(int id) async {
    final db = await database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}