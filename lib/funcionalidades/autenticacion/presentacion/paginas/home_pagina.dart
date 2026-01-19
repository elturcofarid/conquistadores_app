import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../autenticacion/presentacion/bloc/autenticacion_bloc.dart';
import '../../../autenticacion/presentacion/bloc/autenticacion_evento.dart';

class HomePagina extends StatelessWidget {
  const HomePagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorldRank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AutenticacionBloc>().add(LogoutSolicitado());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a WorldRank 🌍',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/perfil');
              },
              child: const Text('Ver Perfil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/crear-publicacion');
              },
              child: const Text('Crear Publicación'),
            ),
          ],
        ),
      ),
    );
  }
}
