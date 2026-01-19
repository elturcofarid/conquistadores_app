import 'package:dio/dio.dart';

import '../dominio/entidades/publicacion.dart';
import '../dominio/repositorio_publicacion.dart';
import 'modelos/crear_publicacion_request.dart';
import 'modelos/publicacion_model.dart';

class RepositorioPublicacionImpl implements RepositorioPublicacion {
  final Dio dio;

  RepositorioPublicacionImpl(this.dio);

  @override
  Future<Publicacion> crearPublicacion(String descripcion, String imagenBase64, {double? longitud, double? latitud}) async {
    final request = CrearPublicacionRequest(
      descripcion: descripcion,
      longitud: longitud,
      latitud: latitud,
      imagenBase64: imagenBase64,
    );

    print('Enviando solicitud de creación de publicación:');
    print('Descripción: $descripcion');
    print('Longitud: $longitud');
    print('Latitud: $latitud');
    print('Imagen Base64 length: ${imagenBase64.length}');
    final response = await dio.post('/api/publicaciones', data: request.toJson());
    print('Respuesta del backend: ${response.statusCode}');
    return PublicacionModel.fromJson(response.data);
  }
}