import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/publicacion_bloc.dart';
import '../bloc/publicacion_estado.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/description_field_widget.dart';
import '../widgets/submit_button_widget.dart';

class CrearPublicacionPagina extends StatelessWidget {
  const CrearPublicacionPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
      ),
      body: BlocBuilder<PublicacionBloc, PublicacionEstado>(
        builder: (context, estado) {
          if (estado is PublicacionCargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (estado is PublicacionCreada) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Publicación creada exitosamente')),
              );
              Navigator.pop(context);
            });
            return const SizedBox.shrink();
          }

          if (estado is PublicacionError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(estado.mensaje)),
              );
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const ImagePickerWidget(),
                const SizedBox(height: 16),
                const DescriptionFieldWidget(),
                const SizedBox(height: 16),
                const SubmitButtonWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}