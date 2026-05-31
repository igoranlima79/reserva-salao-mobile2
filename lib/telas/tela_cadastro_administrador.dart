import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';

class TelaCadastroAdministrador extends StatefulWidget {
  const TelaCadastroAdministrador({super.key});

  @override
  State<TelaCadastroAdministrador> createState() =>
      _TelaCadastroAdministradorState();
}

class _TelaCadastroAdministradorState
    extends State<TelaCadastroAdministrador> {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
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
    loginController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrar() async {
    if (nomeController.text.isEmpty ||
        telefoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        loginController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha todos os campos'),
        ),
      );
      return;
    }

    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('As senhas não coincidem'),
        ),
      );
      return;
    }

    bool sucesso = await BancoSQLite.instance.cadastrarAdministrador(
      nome: nomeController.text,
      telefone: telefoneController.text,
      email: emailController.text,
      login: loginController.text,
      senha: senhaController.text,
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
              Text('Administrador cadastrado com sucesso'),
            ],
          ),
        ),
      );

      nomeController.clear();
      telefoneController.clear();
      emailController.clear();
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

  Widget campoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget campoSenha({
    required String label,
    required TextEditingController controller,
    required bool mostrar,
    required VoidCallback mudar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: !mostrar,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: IconButton(
            icon: Icon(mostrar ? Icons.visibility : Icons.visibility_off),
            onPressed: mudar,
          ),
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
        title: const Text('Cadastro de Administrador'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Color(0xFF1F3D2E),
            ),
            const SizedBox(height: 15),
            const Text(
              'Novo Administrador',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F3D2E),
              ),
            ),
            const SizedBox(height: 25),
            campoTexto('Nome', nomeController),
            campoTexto('Telefone', telefoneController),
            campoTexto('E-mail', emailController),
            campoTexto('Login', loginController),
            campoSenha(
              label: 'Senha',
              controller: senhaController,
              mostrar: mostrarSenha,
              mudar: () => setState(() => mostrarSenha = !mostrarSenha),
            ),
            campoSenha(
              label: 'Repetir senha',
              controller: confirmarSenhaController,
              mostrar: mostrarConfirmarSenha,
              mudar: () => setState(
                  () => mostrarConfirmarSenha = !mostrarConfirmarSenha),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cadastrar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3D2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Cadastrar administrador',
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