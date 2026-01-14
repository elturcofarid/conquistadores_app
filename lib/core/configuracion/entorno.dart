enum Entorno { desarrollo, produccion }

class ConfiguracionEntorno {
  static Entorno entorno = Entorno.desarrollo;

  static String get baseUrl {
    switch (entorno) {
      case Entorno.produccion:
        return 'https://api.worldrank.com/api/v1';
      default:
        return 'http://localhost:8080/api/v1';
    }
  }
}
