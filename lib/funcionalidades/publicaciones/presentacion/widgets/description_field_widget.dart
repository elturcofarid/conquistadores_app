import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/publicacion_bloc.dart';
import '../bloc/publicacion_evento.dart';
import '../bloc/publicacion_estado.dart';

class DescriptionFieldWidget extends StatelessWidget {
  const DescriptionFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicacionBloc, PublicacionEstado>(
      builder: (context, estado) {
        String descripcion = '';
        if (estado is PublicacionInicial) {
          descripcion = estado.descripcion;
        }

        return TextField(
          controller: TextEditingController(text: descripcion),
          decoration: const InputDecoration(
            labelText: 'Descripción',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            context.read<PublicacionBloc>().add(DescripcionCambiada(value));
          },
        );
      },
    );
  }
}