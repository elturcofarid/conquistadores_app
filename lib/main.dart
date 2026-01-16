import 'package:conquistadores_app/funcionalidades/autenticacion/presentacion/bloc/autenticacion_bloc.dart';
import 'package:conquistadores_app/funcionalidades/autenticacion/presentacion/paginas/home_pagina.dart';
import 'package:conquistadores_app/funcionalidades/autenticacion/presentacion/paginas/login_pagina.dart';
import 'package:conquistadores_app/funcionalidades/perfil/presentacion/paginas/perfil_pagina.dart';
import 'package:conquistadores_app/inyeccion_dependencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inicializarDependencias(); // ← ESTO ES CLAVE
  print(sl.isRegistered<AutenticacionBloc>()); // debe imprimir true
  runApp(const WorldRankApp());
}

class WorldRankApp extends StatelessWidget {
  const WorldRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AutenticacionBloc>(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/login': (_) => const LoginPagina(),
          '/home': (_) => const HomePagina(),
          '/perfil': (_) => const PerfilPagina(),
        },
        initialRoute: '/login',
      ),
    );
  }
}
