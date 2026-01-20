import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../autenticacion/presentacion/bloc/autenticacion_bloc.dart';
import '../../../autenticacion/presentacion/bloc/autenticacion_evento.dart';
import '../../../publicaciones/presentacion/bloc/publicaciones_list_bloc.dart';
import '../../../publicaciones/presentacion/bloc/publicaciones_list_estado.dart';
import '../../../publicaciones/presentacion/bloc/publicaciones_list_evento.dart';
import '../../../publicaciones/presentacion/widgets/publicacion_card_widget.dart';

class HomePagina extends StatefulWidget {
  const HomePagina({super.key});

  @override
  State<HomePagina> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePagina> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PublicacionesListBloc>().add(const CargarPublicaciones());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final state = context.read<PublicacionesListBloc>().state;
      if (state is PublicacionesListCargadas && state.hasMore) {
        context.read<PublicacionesListBloc>().add(CargarPublicaciones(
          page: (state.publicaciones.length / 20).floor(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorldRank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PublicacionesListBloc>().add(RefrescarPublicaciones());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AutenticacionBloc>().add(LogoutSolicitado());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<PublicacionesListBloc, PublicacionesListEstado>(
        builder: (context, state) {
          if (state is PublicacionesListInicial || state is PublicacionesListCargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PublicacionesListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.mensaje}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PublicacionesListBloc>().add(const CargarPublicaciones());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (state is PublicacionesListCargadas) {
            if (state.publicaciones.isEmpty) {
              return const Center(child: Text('No hay publicaciones aún'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PublicacionesListBloc>().add(RefrescarPublicaciones());
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.publicaciones.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.publicaciones.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final publicacion = state.publicaciones[index];
                  return PublicacionCardWidget(publicacion: publicacion);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/crear-publicacion');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
