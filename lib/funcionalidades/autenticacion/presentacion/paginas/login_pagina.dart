import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/autenticacion_bloc.dart';
import '../bloc/autenticacion_estado.dart';
import '../widgets/formulario_login.dart';

class LoginPagina extends StatelessWidget {
  const LoginPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: BlocBuilder<AutenticacionBloc, AutenticacionEstado>(
        builder: (context, estado) {
          if (estado is AutenticacionCargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (estado is AutenticacionError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  estado.mensaje,
                  style: const TextStyle(color: Colors.red),
                ),
                const FormularioLogin(),
              ],
            );
          }

          if (estado is AutenticacionExitosa) {
            // navegación post-login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
            return const SizedBox.shrink();
          }

          return const FormularioLogin();
        },
      ),
    );
  }
}
