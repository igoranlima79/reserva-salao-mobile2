import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';
import '../dados/sessao_usuario.dart';

class TelaMinhasReservas extends StatefulWidget {
  const TelaMinhasReservas({super.key});

  @override
  State<TelaMinhasReservas> createState() => _TelaMinhasReservasState();
}

class _TelaMinhasReservasState extends State<TelaMinhasReservas> {
  List<Map<String, dynamic>> minhasReservas = [];

  @override
  void initState() {
    super.initState();
    carregarReservas();
  }

  String formatarDataBrasil(String data) {
    List<String> partes = data.split('-');
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  Future<void> carregarReservas() async {
    if (SessaoUsuario.id == null) {
      return;
    }

    List<Map<String, dynamic>> resultado =
        await BancoSQLite.instance.reservasDoUsuario(SessaoUsuario.id!);

    setState(() {
      minhasReservas = resultado;
    });
  }

  Future<void> cancelarReserva(int reservaId) async {
    await BancoSQLite.instance.cancelarReserva(reservaId);

    await carregarReservas();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Reserva cancelada'),
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
        title: const Text('Minhas reservas'),
        centerTitle: true,
      ),
      body: minhasReservas.isEmpty
          ? const Center(
              child: Text(
                'Você ainda não possui reservas.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: minhasReservas.length,
              itemBuilder: (context, index) {
                final reserva = minhasReservas[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.event_available,
                        color: Color(0xFF8B0000),
                        size: 45,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatarDataBrasil(reserva['data']),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F3D2E),
                              ),
                            ),
                            Text('Nome: ${reserva['nome']}'),
                            Text('Apartamento: ${reserva['apartamento']}'),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cancelarReserva(reserva['id']);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}