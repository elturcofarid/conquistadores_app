import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inyeccion_dependencias.dart';
import '../bloc/perfil_bloc.dart';
import '../bloc/perfil_estado.dart';
import '../bloc/perfil_evento.dart';

class PerfilPagina extends StatelessWidget {
  const PerfilPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PerfilBloc>()..add(CargarPerfil()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
        ),
        body: BlocBuilder<PerfilBloc, PerfilEstado>(
          builder: (context, state) {
            if (state is PerfilCargando) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PerfilError) {
              return Center(
                child: Text(
                  state.mensaje,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is PerfilCargado) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${state.perfil.userId}'),
                    Text('Nombre: ${state.perfil.biografia}'),
                    Text('Foto: ${state.perfil.fotoUrl}'),
                    Text('Rango: ${state.perfil.rango}'),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}