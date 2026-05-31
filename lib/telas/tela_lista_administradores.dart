import 'package:flutter/material.dart';
import '../dados/banco_sqlite.dart';
import 'tela_editar_administrador.dart';

class TelaListaAdministradores extends StatefulWidget {
  const TelaListaAdministradores({super.key});

  @override
  State<TelaListaAdministradores> createState() =>
      _TelaListaAdministradoresState();
}

class _TelaListaAdministradoresState
    extends State<TelaListaAdministradores> {
  List<Map<String, dynamic>> administradores = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final lista = await BancoSQLite.instance.listarAdministradores();
    setState(() {
      administradores = lista;
      carregando = false;
    });
  }

  Future<void> excluir(Map<String, dynamic> admin) async {
    // Protege o administrador padrão
    if (admin['login'] == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('O administrador padrão não pode ser excluído.'),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja excluir este administrador?'),
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
      await BancoSQLite.instance.excluirUsuario(admin['id']);
      if (!mounted) return;
      carregar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F3D2E),
        foregroundColor: Colors.white,
        title: const Text('Administradores'),
        centerTitle: true,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : administradores.isEmpty
              ? const Center(child: Text('Nenhum administrador cadastrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: administradores.length,
                  itemBuilder: (context, index) {
                    final a = administradores[index];
                    final ehAdminPadrao = a['login'] == 'admin';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFC9A14A),
                          child: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          a['nome'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(a['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF1F3D2E),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TelaEditarAdministrador(
                                      administrador: a,
                                    ),
                                  ),
                                );
                                carregar();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                // ícone acinzentado para o admin padrão
                                color: ehAdminPadrao
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                              onPressed: () => excluir(a),
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