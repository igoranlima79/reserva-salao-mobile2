import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';
import '../dados/sessao_usuario.dart';
import '../widgets/botao_menu.dart';
import 'tela_calendario.dart';
import 'tela_regras.dart';
import 'tela_cadastro_condomino.dart';
import 'tela_cadastro_administrador.dart';
import 'tela_lista_condominos.dart';
import 'tela_lista_administradores.dart';
import 'tela_login.dart';

class TelaAdministrador extends StatefulWidget {
  const TelaAdministrador({super.key});

  @override
  State<TelaAdministrador> createState() => _TelaAdministradorState();
}

class _TelaAdministradorState extends State<TelaAdministrador> {
  int totalCondominos = 0;
  int totalReservas = 0;

  @override
  void initState() {
    super.initState();
    carregarResumo();
  }

  Future<void> carregarResumo() async {
    int condominos = await BancoSQLite.instance.totalCondominos();
    int reservas = await BancoSQLite.instance.totalReservas();

    setState(() {
      totalCondominos = condominos;
      totalReservas = reservas;
    });
  }

  void sair(BuildContext context) {
    SessaoUsuario.limparSessao();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaLogin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F3D2E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => sair(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                    const Icon(
                      Icons.apartment,
                      color: Color(0xFFC9A14A),
                      size: 70,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'RESIDENCIAL IMPERIAL LUXOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ÁREA DO ADMINISTRADOR',
                      style: TextStyle(
                        color: Color(0xFFC9A14A),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(blurRadius: 8, color: Colors.black12),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Resumo do Salão',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F3D2E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        colunaResumo(Icons.people, '$totalCondominos', 'Condôminos'),
                        colunaResumo(Icons.event_available, '$totalReservas', 'Reservas'),
                        colunaResumo(Icons.check_circle, 'Ativo', 'Status'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F3D2E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Área Administrativa',
                      style: TextStyle(
                        color: Color(0xFFC9A14A),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Gerencie condôminos, administradores, reservas e regras do salão de festas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              BotaoMenu(
                titulo: 'Cadastro de Condôminos',
                icone: Icons.person_add,
                aoClicar: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaCadastroCondomino()),
                  );
                  carregarResumo();
                },
              ),

              BotaoMenu(
                titulo: 'Cadastro de Administradores',
                icone: Icons.admin_panel_settings,
                aoClicar: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaCadastroAdministrador()),
                  );
                  carregarResumo();
                },
              ),

              BotaoMenu(
                titulo: 'Calendário de Reservas',
                icone: Icons.calendar_month,
                aoClicar: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaCalendario()),
                  );
                  carregarResumo();
                },
              ),

              BotaoMenu(
                titulo: 'Regras do Salão',
                icone: Icons.description,
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaRegras()),
                  );
                },
              ),

              BotaoMenu(
                titulo: 'Listar Condôminos',
                icone: Icons.people,
                aoClicar: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaListaCondominos()),
                  );
                  carregarResumo();
                },
              ),

              BotaoMenu(
                titulo: 'Listar Administradores',
                icone: Icons.manage_accounts,
                aoClicar: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaListaAdministradores()),
                  );
                  carregarResumo();
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget colunaResumo(IconData icone, String valor, String titulo) {
    return Column(
      children: [
        Icon(icone, color: const Color(0xFF1F3D2E), size: 35),
        const SizedBox(height: 10),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F3D2E),
          ),
        ),
        const SizedBox(height: 5),
        Text(titulo, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}