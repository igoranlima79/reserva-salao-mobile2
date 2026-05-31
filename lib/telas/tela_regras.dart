import 'package:flutter/material.dart';

class TelaRegras extends StatelessWidget {
  const TelaRegras({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> regras = [
      'O salão pode ser reservado apenas por condôminos cadastrados.',
      'O horário máximo de utilização é até 00h.',
      'É proibido som alto após 22h.',
      'O limite máximo é de 50 convidados.',
      'O responsável pela reserva deve zelar pela limpeza do espaço.',
      'Danos causados ao salão serão de responsabilidade do condômino.',
      'O cancelamento deve ser realizado com pelo menos 24h de antecedência.',
      'Não é permitido fumar dentro do salão.',
      'Após o evento, mesas e cadeiras devem ser organizadas.',
      'O uso do salão implica concordância com todas as regras.',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3D2E),
        foregroundColor: Colors.white,
        title: const Text('Regras do Salão'),
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
                  SizedBox(height: 10),
                  Text(
                    'Regras do Salão de Festas',
                    style: TextStyle(
                      color: Color(0xFFC9A14A),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: regras.map(
                  (regra) {
                    return Container(
                      width: double.infinity,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1F3D2E),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              regra,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}