class SessaoUsuario {
  static int? id;
  static String? nome;
  static String? telefone;
  static String? email;
  static String? apartamento;
  static String? login;
  static String? tipo;

  static void salvarUsuario(Map<String, dynamic> usuario) {
    id = usuario['id'];
    nome = usuario['nome'];
    telefone = usuario['telefone'];
    email = usuario['email'];
    apartamento = usuario['apartamento'];
    login = usuario['login'];
    tipo = usuario['tipo'];
  }

  static void limparSessao() {
    id = null;
    nome = null;
    telefone = null;
    email = null;
    apartamento = null;
    login = null;
    tipo = null;
  }

  static bool estaLogado() {
    return id != null;
  }
}