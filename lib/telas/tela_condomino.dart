import 'package:flutter/material.dart';
import '../dados/sessao_usuario.dart';
import '../widgets/botao_menu.dart';
import 'tela_calendario.dart';
import 'tela_regras.dart';
import 'tela_login.dart';
import 'tela_minhas_reservas.dart';

class TelaCondomino extends StatelessWidget {
  const TelaCondomino({super.key});

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
                        onPressed: () {
                          sair(context);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.apartment,
                      color: Color(0xFFC9A14A),
                      size: 70,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'IMPERIAL LUXOR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bem-vindo(a), ${SessaoUsuario.nome ?? ''}',
                      style: const TextStyle(
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
                  color: const Color(0xFFE7EFE8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F3D2E),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.event_available,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Salão de Festas',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F3D2E),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Faça reservas e acompanhe seus agendamentos.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              BotaoMenu(
                titulo: 'Fazer reserva',
                icone: Icons.calendar_month,
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCalendario(
                        modoCondomino: true,
                      ),
                    ),
                  );
                },
              ),

              BotaoMenu(
                titulo: 'Ver minhas reservas',
                icone: Icons.list_alt,
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaMinhasReservas(),
                    ),
                  );
                },
              ),

              BotaoMenu(
                titulo: 'Regras do salão',
                icone: Icons.description,
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaRegras(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}