import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/autenticacion_bloc.dart';
import '../bloc/autenticacion_evento.dart';

class FormularioLogin extends StatefulWidget {
  const FormularioLogin({super.key});

  @override
  State<FormularioLogin> createState() => _FormularioLoginState();
}

class _FormularioLoginState extends State<FormularioLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Contraseña'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AutenticacionBloc>().add(
                    LoginSolicitado(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
            },
            child: const Text('Ingresar'),
          ),
        ],
      ),
    );
  }
}
