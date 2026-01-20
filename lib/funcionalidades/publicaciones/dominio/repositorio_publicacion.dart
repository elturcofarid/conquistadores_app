import 'entidades/publicacion.dart';
import '../data/modelos/publicacion_list_response.dart';

abstract class RepositorioPublicacion {
  Future<Publicacion> crearPublicacion(String descripcion, String imagenBase64, {double? longitud, double? latitud});
  Future<List<PublicacionListResponse>> obtenerPublicaciones({int page = 0, int size = 20});
}