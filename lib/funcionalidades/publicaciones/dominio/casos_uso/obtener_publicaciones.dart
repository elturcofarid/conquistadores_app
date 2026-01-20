import '../repositorio_publicacion.dart';
import '../../data/modelos/publicacion_list_response.dart';

class ObtenerPublicaciones {
  final RepositorioPublicacion repositorio;

  ObtenerPublicaciones(this.repositorio);

  Future<List<PublicacionListResponse>> ejecutar({int page = 0, int size = 20}) {
    return repositorio.obtenerPublicaciones(page: page, size: size);
  }
}