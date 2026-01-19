enum Entorno { desarrollo, produccion }

class ConfiguracionEntorno {
  static Entorno entorno = Entorno.desarrollo;

  static String get baseUrl {
    switch (entorno) {
      case Entorno.produccion:
        return 'http://192.168.1.134:8082/api';
      default:
        return 'http://192.168.1.134:8082/api';
    }
  }
}
