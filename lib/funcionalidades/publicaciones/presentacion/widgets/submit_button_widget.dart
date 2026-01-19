import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/publicacion_bloc.dart';
import '../bloc/publicacion_evento.dart';
import '../bloc/publicacion_estado.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionBloc, PublicacionEstado>(
      builder: (context, estado) {
        bool isEnabled = false;
        if (estado is PublicacionInicial) {
          isEnabled = estado.imagenBase64 != null && estado.descripcion.isNotEmpty;
        }

        return ElevatedButton(
          onPressed: isEnabled ? () {
            context.read<PublicacionBloc>().add(CrearPublicacionSolicitado());
          } : null,
          child: const Text('Crear Publicación'),
        );
      },
    );
  }
}