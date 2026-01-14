import 'package:conquistadores_app/core/configuracion/entorno.dart';
import 'package:dio/dio.dart';
import 'interceptor_jwt.dart';


class ClienteHttp {
  final Dio dio;

  ClienteHttp(this.dio) {
    print(  'Configurando Dio con baseUrl: ${ConfiguracionEntorno.baseUrl}');
    
    dio.options = BaseOptions(
      baseUrl: ConfiguracionEntorno.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
      ),
    );
  }
}
