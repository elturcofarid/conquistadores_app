import 'package:dio/dio.dart';

import '../dominio/entidades/publicacion.dart';
import '../dominio/repositorio_publicacion.dart';
import 'modelos/crear_publicacion_request.dart';
import 'modelos/publicacion_list_response.dart';
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
    final response = await dio.post('/publicaciones', data: request.toJson());
    print('Respuesta del backend: ${response.statusCode}');
    return PublicacionModel.fromJson(response.data);
  }

  @override
  Future<List<PublicacionListResponse>> obtenerPublicaciones({int page = 0, int size = 20}) async {
    final response = await dio.get('/publicaciones', queryParameters: {'page': page, 'size': size});
    print('Respuesta del backend para obtener publicaciones: ${response.statusCode}');
    final data = response.data as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>;
    return content.map((item) => PublicacionListResponse.fromJson(item)).toList();
  }
}