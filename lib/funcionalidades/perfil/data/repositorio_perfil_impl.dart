import 'package:dio/dio.dart';

import '../dominio/entidades/perfil.dart';
import '../dominio/repositorio_perfil.dart';
import 'modelos/perfil_model.dart';

class RepositorioPerfilImpl implements RepositorioPerfil {
  final Dio dio;

  RepositorioPerfilImpl(this.dio);

  @override
  Future<Perfil> obtenerPerfilUsuario() async {
    final response = await dio.get('/v1/users/me');
    return PerfilModel.fromJson(response.data);
  }
}