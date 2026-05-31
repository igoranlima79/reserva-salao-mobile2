import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';

class TelaEditarAdministrador extends StatefulWidget {
  final Map<String, dynamic> administrador;

  const TelaEditarAdministrador({super.key, required this.administrador});

  @override
  State<TelaEditarAdministrador> createState() =>
      _TelaEditarAdministradorState();
}

class _TelaEditarAdministradorState extends State<TelaEditarAdministrador> {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final loginController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool mostrarSenha = false;
  bool mostrarConfirmarSenha = false;
  bool alterarSenha = false;

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.administrador['nome'] ?? '';
    telefoneController.text = widget.administrador['telefone'] ?? '';
    emailController.text = widget.administrador['email'] ?? '';
    loginController.text = widget.administrador['login'] ?? '';
  }

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

  Future<void> salvar() async {
    final nome = nomeController.text;
    final telefone = telefoneController.text;
    final email = emailController.text;
    final login = loginController.text;

    if (nome.isEmpty || telefone.isEmpty || email.isEmpty || login.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Preencha todos os campos'),
        ),
      );
      return;
    }

    String? novaSenha;

    if (alterarSenha) {
      final senha = senhaController.text;
      final confirmarSenha = confirmarSenhaController.text;

      if (senha.isEmpty || confirmarSenha.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Preencha os campos de senha'),
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

      novaSenha = senha;
    }

    final bool sucesso = await BancoSQLite.instance.editarCondomino(
      id: widget.administrador['id'],
      nome: nome,
      telefone: telefone,
      email: email,
      apartamento: 'Admin', // administrador não tem apartamento
      login: login,
      senha: novaSenha,
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
              Text('Dados atualizados com sucesso'),
            ],
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erro ao atualizar. E-mail ou login já em uso.'),
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
        title: const Text('Editar Administrador'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            campoTexto(texto: 'Nome', controller: nomeController),
            campoTexto(texto: 'Telefone', controller: telefoneController),
            campoTexto(texto: 'E-mail', controller: emailController),
            campoTexto(texto: 'Login', controller: loginController),

            SwitchListTile(
              value: alterarSenha,
              activeColor: const Color(0xFF1F3D2E),
              title: const Text('Alterar senha'),
              onChanged: (valor) => setState(() {
                alterarSenha = valor;
                if (!valor) {
                  senhaController.clear();
                  confirmarSenhaController.clear();
                }
              }),
            ),

            if (alterarSenha) ...[
              const SizedBox(height: 8),
              campoTexto(
                texto: 'Nova senha',
                controller: senhaController,
                senha: true,
                mostrar: mostrarSenha,
                mudarVisibilidade: () =>
                    setState(() => mostrarSenha = !mostrarSenha),
              ),
              campoTexto(
                texto: 'Repetir nova senha',
                controller: confirmarSenhaController,
                senha: true,
                mostrar: mostrarConfirmarSenha,
                mudarVisibilidade: () => setState(
                    () => mostrarConfirmarSenha = !mostrarConfirmarSenha),
              ),
            ],

            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3D2E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(18),
                ),
                child: const Text(
                  'Salvar alterações',
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