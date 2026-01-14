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
      body: const Center(
        child: Text(
          'Bienvenido a WorldRank 🌍',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
