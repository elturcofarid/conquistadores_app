import '../entidades/publicacion.dart';
import '../repositorio_publicacion.dart';

class CrearPublicacion {
  final RepositorioPublicacion repositorio;

  CrearPublicacion(this.repositorio);

  Future<Publicacion> ejecutar(String descripcion, String imagenBase64, {double? longitud, double? latitud}) {
    return repositorio.crearPublicacion(descripcion, imagenBase64, longitud: longitud, latitud: latitud);
  }
}