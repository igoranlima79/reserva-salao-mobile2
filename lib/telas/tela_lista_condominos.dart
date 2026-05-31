import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';
import 'tela_editar_condominos.dart';

class TelaListaCondominos extends StatefulWidget {
  const TelaListaCondominos({super.key});

  @override
  State<TelaListaCondominos> createState() => _TelaListaCondominosState();
}

class _TelaListaCondominosState extends State<TelaListaCondominos> {
  List<Map<String, dynamic>> condominos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final lista = await BancoSQLite.instance.listarCondominos();
    setState(() {
      condominos = lista;
      carregando = false;
    });
  }

  Future<void> excluir(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja excluir este condômino?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await BancoSQLite.instance.excluirUsuario(id);
      if (!mounted) return;
      carregar();
    }
  }

  Widget infoLinha(IconData icone, String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icone, size: 16, color: const Color(0xFF1F3D2E)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
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
        title: const Text('Condôminos'),
        centerTitle: true,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : condominos.isEmpty
              ? const Center(child: Text('Nenhum condômino cadastrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: condominos.length,
                  itemBuilder: (context, index) {
                    final c = condominos[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFF1F3D2E),
                                  radius: 22,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    c['nome'] ?? 'Sem nome',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F3D2E),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF1F3D2E),
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TelaEditarCondomino(
                                          condomino: c,
                                        ),
                                      ),
                                    );
                                    carregar();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => excluir(c['id']),
                                ),
                              ],
                            ),

                            const Divider(height: 20),

                            infoLinha(
                              Icons.apartment,
                              'Apartamento: ${c['apartamento'] ?? ''}',
                            ),
                            infoLinha(
                              Icons.email,
                              c['email'] ?? '',
                            ),
                            infoLinha(
                              Icons.phone,
                              c['telefone'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}