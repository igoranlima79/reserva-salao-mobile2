class BancoFake {
  static List<Map<String, String>> usuarios = [
    {
      'nome': 'Administrador',
      'email': 'admin@imperialluxor.com',
      'apartamento': 'Admin',
      'login': 'admin',
      'senha': '1234',
      'tipo': 'administrador',
    },
    {
      'nome': 'Maria',
      'email': 'maria@email.com',
      'apartamento': '101',
      'login': 'maria',
      'senha': '1234',
      'tipo': 'condomino',
    },
  ];

  static List<Map<String, String>> reservas = [
    {
      'data': '2026-05-28',
      'nome': 'Maria',
      'apartamento': '101',
      'horario': 'Dia inteiro',
      'status': 'Reservado',
    },
  ];

  static Map<String, String>? fazerLogin(String login, String senha) {
    for (var usuario in usuarios) {
      if (usuario['login'] == login && usuario['senha'] == senha) {
        return usuario;
      }
    }
    return null;
  }

  static bool dataTemReserva(String data) {
    return reservas.any((reserva) => reserva['data'] == data);
  }

  static List<Map<String, String>> reservasDaData(String data) {
    return reservas.where((reserva) => reserva['data'] == data).toList();
  }

  static void criarReserva(String data) {
    reservas.add({
      'data': data,
      'nome': 'Maria',
      'apartamento': '101',
      'horario': 'Dia inteiro',
      'status': 'Reservado',
    });
  }

  static bool usuarioJaExiste(String nome, String email, String login) {
    return usuarios.any(
      (usuario) =>
          usuario['nome'] == nome ||
          usuario['email'] == email ||
          usuario['login'] == login,
    );
  }

  static bool cadastrarCondomino({
    required String nome,
    required String email,
    required String apartamento,
    required String login,
    required String senha,
  }) {
    if (usuarioJaExiste(nome, email, login)) {
      return false;
    }

    usuarios.add({
      'nome': nome,
      'email': email,
      'apartamento': apartamento,
      'login': login,
      'senha': senha,
      'tipo': 'condomino',
    });

    return true;
  }

  static bool cadastrarAdministrador({
    required String nome,
    required String email,
    required String login,
    required String senha,
  }) {
    if (usuarioJaExiste(nome, email, login)) {
      return false;
    }

    usuarios.add({
      'nome': nome,
      'email': email,
      'apartamento': 'Admin',
      'login': login,
      'senha': senha,
      'tipo': 'administrador',
    });

    return true;
  }

  static int totalCondominos() {
    return usuarios.where((usuario) => usuario['tipo'] == 'condomino').length;
  }

  static int totalReservas() {
    return reservas.length;
  }
}