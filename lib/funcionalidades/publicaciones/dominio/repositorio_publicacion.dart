import 'entidades/publicacion.dart';

abstract class RepositorioPublicacion {
  Future<Publicacion> crearPublicacion(String descripcion, String imagenBase64, {double? longitud, double? latitud});
}