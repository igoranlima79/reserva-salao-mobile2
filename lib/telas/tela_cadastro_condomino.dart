import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';

class TelaCadastroCondomino extends StatefulWidget {
  const TelaCadastroCondomino({super.key});

  @override
  State<TelaCadastroCondomino> createState() =>
      _TelaCadastroCondominoState();
}

class _TelaCadastroCondominoState extends State<TelaCadastroCondomino> {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final apartamentoController = TextEditingController();
  final loginController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    apartamentoController.dispose();
    loginController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    String nome = nomeController.text;
    String email = emailController.text;
    String telefone = telefoneController.text;
    String apartamento = apartamentoController.text;
    String login = loginController.text;
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        apartamento.isEmpty ||
        login.isEmpty ||
        senha.isEmpty ||
        confirmarSenha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha todos os campos'),
        ),
      );
      return;
    }

    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('As senhas não coincidem'),
        ),
      );
      return;
    }

    bool sucesso = await BancoSQLite.instance.cadastrarCondomino(
      nome: nome,
      telefone: telefone,
      email: email,
      apartamento: apartamento,
      login: login,
      senha: senha,
    );

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 10),
              Text('Cadastro concluído com sucesso'),
            ],
          ),
        ),
      );

      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
      apartamentoController.clear();
      loginController.clear();
      senhaController.clear();
      confirmarSenhaController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Usuário já existe'),
        ),
      );
    }
  }

  Widget campoTexto({
    required String texto,
    required TextEditingController controller,
    bool senha = false,
    bool mostrar = false,
    VoidCallback? mudarVisibilidade,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: senha ? !mostrar : false,
        decoration: InputDecoration(
          labelText: texto,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: senha
              ? IconButton(
                  icon: Icon(
                    mostrar ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: mudarVisibilidade,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3D2E),
        foregroundColor: Colors.white,
        title: const Text('Cadastro de Condôminos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            campoTexto(
              texto: 'Nome do condômino',
              controller: nomeController,
            ),
            campoTexto(
              texto: 'Telefone',
              controller: telefoneController,
            ),
            campoTexto(
              texto: 'E-mail',
              controller: emailController,
            ),
            campoTexto(
              texto: 'Apartamento',
              controller: apartamentoController,
            ),
            campoTexto(
              texto: 'Login',
              controller: loginController,
            ),
            campoTexto(
              texto: 'Senha',
              controller: senhaController,
              senha: true,
              mostrar: mostrarSenha,
              mudarVisibilidade: () =>
                  setState(() => mostrarSenha = !mostrarSenha),
            ),
            campoTexto(
              texto: 'Repetir senha',
              controller: confirmarSenhaController,
              senha: true,
              mostrar: mostrarConfirmarSenha,
              mudarVisibilidade: () => setState(
                  () => mostrarConfirmarSenha = !mostrarConfirmarSenha),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3D2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(18),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}