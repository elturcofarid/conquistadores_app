import 'package:conquistadores_app/core/configuracion/entorno.dart';
import 'package:dio/dio.dart';
import 'interceptor_jwt.dart';


class ClienteHttp {
  final Dio dio;

  ClienteHttp(this.dio) {
    dio.options.baseUrl = ConfiguracionEntorno.baseUrl;
    dio.interceptors.add(InterceptorJwt());
  }
}