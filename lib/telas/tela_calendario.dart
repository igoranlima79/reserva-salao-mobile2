import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';
import '../dados/sessao_usuario.dart';

class TelaCalendario extends StatefulWidget {
  final bool modoCondomino;

  const TelaCalendario({
    super.key,
    this.modoCondomino = false,
  });

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime mesAtual = DateTime.now();
  String? dataSelecionada;

  List<Map<String, dynamic>> reservasDoMes = [];
  List<Map<String, dynamic>> reservasSelecionadas = [];

  @override
  void initState() {
    super.initState();
    carregarReservasDoMes();
  }

  Future<void> carregarReservasDoMes() async {
    List<Map<String, dynamic>> todas = [];

    for (int dia = 1; dia <= DateTime(mesAtual.year, mesAtual.month + 1, 0).day; dia++) {
      String data = formatarData(DateTime(mesAtual.year, mesAtual.month, dia));
      List<Map<String, dynamic>> reservas =
          await BancoSQLite.instance.reservasDaData(data);

      todas.addAll(reservas);
    }

    setState(() {
      reservasDoMes = todas;
    });
  }

  String formatarData(DateTime data) {
    String mes = data.month.toString().padLeft(2, '0');
    String dia = data.day.toString().padLeft(2, '0');
    return '${data.year}-$mes-$dia';
  }

  String formatarDataBrasil(String data) {
    List<String> partes = data.split('-');
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  String nomeMes(int mes) {
    List<String> meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return meses[mes - 1];
  }

  bool dataTemReservaLocal(String data) {
    for (var reserva in reservasDoMes) {
      if (reserva['data'] == data) {
        return true;
      }
    }
    return false;
  }

  Future<void> selecionarData(String data) async {
    List<Map<String, dynamic>> reservas =
        await BancoSQLite.instance.reservasDaData(data);

    setState(() {
      dataSelecionada = data;
      reservasSelecionadas = reservas;
    });
  }

  Future<void> fazerReserva() async {
    if (dataSelecionada == null || SessaoUsuario.id == null) {
      return;
    }

    bool sucesso = await BancoSQLite.instance.criarReserva(
      data: dataSelecionada!,
      usuarioId: SessaoUsuario.id!,
    );

    if (sucesso) {
      await carregarReservasDoMes();
      await selecionarData(dataSelecionada!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 10),
              Text('Reserva feita com sucesso'),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Esta data já está reservada'),
        ),
      );
    }
  }

  List<Widget> gerarDiasDoCalendario() {
    int ano = mesAtual.year;
    int mes = mesAtual.month;

    DateTime primeiroDia = DateTime(ano, mes, 1);
    int quantidadeDias = DateTime(ano, mes + 1, 0).day;
    int inicio = primeiroDia.weekday;

    List<Widget> dias = [];

    for (int i = 1; i < inicio; i++) {
      dias.add(const SizedBox());
    }

    for (int dia = 1; dia <= quantidadeDias; dia++) {
      DateTime data = DateTime(ano, mes, dia);
      String dataFormatada = formatarData(data);

      bool reservado = dataTemReservaLocal(dataFormatada);
      bool selecionado = dataSelecionada == dataFormatada;

      dias.add(
        GestureDetector(
          onTap: () {
            selecionarData(dataFormatada);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: reservado
                  ? const Color(0xFF8B0000)
                  : selecionado
                      ? const Color(0xFFC9A14A)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selecionado
                    ? const Color(0xFFC9A14A)
                    : const Color(0xFF1F3D2E),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                dia.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: reservado || selecionado
                      ? Colors.white
                      : const Color(0xFF1F3D2E),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return dias;
  }

  @override
  Widget build(BuildContext context) {
    bool dataLivre =
        dataSelecionada != null && reservasSelecionadas.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3D2E),
        foregroundColor: Colors.white,
        title: Text(
          widget.modoCondomino ? 'Fazer reserva' : 'Calendário de Reservas',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Color(0xFF1F3D2E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.apartment,
                    color: Color(0xFFC9A14A),
                    size: 65,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'IMPERIAL LUXOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              mesAtual = DateTime(
                                mesAtual.year,
                                mesAtual.month - 1,
                              );
                              dataSelecionada = null;
                              reservasSelecionadas = [];
                            });

                            await carregarReservasDoMes();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        Text(
                          '${nomeMes(mesAtual.month)} ${mesAtual.year}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3D2E),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              mesAtual = DateTime(
                                mesAtual.year,
                                mesAtual.month + 1,
                              );
                              dataSelecionada = null;
                              reservasSelecionadas = [];
                            });

                            await carregarReservasDoMes();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('S'),
                        Text('T'),
                        Text('Q'),
                        Text('Q'),
                        Text('S'),
                        Text('S'),
                        Text('D'),
                      ],
                    ),

                    const SizedBox(height: 10),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 7,
                      children: gerarDiasDoCalendario(),
                    ),

                    const SizedBox(height: 15),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color(0xFF8B0000),
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text('Reservado'),
                        SizedBox(width: 18),
                        Icon(
                          Icons.circle,
                          color: Color(0xFFC9A14A),
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text('Selecionado'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (dataSelecionada != null && widget.modoCondomino)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Data selecionada: ${formatarDataBrasil(dataSelecionada!)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F3D2E),
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (dataLivre)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: fazerReserva,
                            icon: const Icon(Icons.check),
                            label: const Text('Fazer reserva'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F3D2E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Esta data já está reservada.',
                          style: TextStyle(
                            color: Color(0xFF8B0000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            if (dataSelecionada != null && !widget.modoCondomino)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Reservas do dia ${formatarDataBrasil(dataSelecionada!)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F3D2E),
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (reservasSelecionadas.isEmpty)
                        const Text('Não há reservas para esta data.')
                      else
                        Column(
                          children: reservasSelecionadas.map((reserva) {
                            return ListTile(
                              leading: const Icon(
                                Icons.person,
                                color: Color(0xFF8B0000),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Responsável: ${reserva['nome']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Apartamento: ${reserva['apartamento']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}