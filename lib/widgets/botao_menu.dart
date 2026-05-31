import 'package:flutter/material.dart';

class BotaoMenu extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback aoClicar;

  const BotaoMenu({
    super.key,
    required this.titulo,
    required this.icone,
    required this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: aoClicar,
        icon: Icon(icone),
        label: Text(titulo),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F3D2E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}