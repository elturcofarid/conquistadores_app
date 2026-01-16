# Diseño del Flujo de Perfil en la Aplicación Móvil

## Contexto
El backend proporciona información del usuario autenticado a través del endpoint `GET /api/v1/users/me`, que requiere autenticación JWT en el header `Authorization: Bearer <token>`.

## Arquitectura Propuesta

### 1. Capa de Dominio (Domain Layer)
- **Entidad**: Reutilizar `Usuario` de `funcionalidades/autenticacion/dominio/entidades/usuario.dart`
- **Repositorio**: `RepositorioPerfil` interface
  ```dart
  abstract class RepositorioPerfil {
    Future<Usuario> obtenerPerfilUsuario();
  }
  ```
- **Caso de Uso**: `ObtenerPerfilUsuario`
  ```dart
  class ObtenerPerfilUsuario {
    final RepositorioPerfil repositorio;

    ObtenerPerfilUsuario(this.repositorio);

    Future<Usuario> ejecutar() {
      return repositorio.obtenerPerfilUsuario();
    }
  }
  ```

### 2. Capa de Datos (Data Layer)
- **Modelo**: `UsuarioModel` (mapea JSON a entidad)
  ```dart
  class UsuarioModel extends Usuario {
    UsuarioModel.fromJson(Map<String, dynamic> json)
        : super(
            id: json['id'],
            email: json['email'],
            username: json['username'],
          );
  }
  ```
- **Repositorio Impl**: `RepositorioPerfilImpl`
  ```dart
  class RepositorioPerfilImpl implements RepositorioPerfil {
    final Dio dio;

    RepositorioPerfilImpl(this.dio);

    @override
    Future<Usuario> obtenerPerfilUsuario() async {
      final response = await dio.get('/users/me');
      return UsuarioModel.fromJson(response.data);
    }
  }
  ```

### 3. Capa de Presentación (Presentation Layer)
- **Estados**: `PerfilEstado`
  ```dart
  abstract class PerfilEstado {}

  class PerfilInicial extends PerfilEstado {}

  class PerfilCargando extends PerfilEstado {}

  class PerfilCargado extends PerfilEstado {
    final Usuario usuario;
    PerfilCargado(this.usuario);
  }

  class PerfilError extends PerfilEstado {
    final String mensaje;
    PerfilError(this.mensaje);
  }
  ```
- **Eventos**: `PerfilEvento`
  ```dart
  abstract class PerfilEvento {}

  class CargarPerfil extends PerfilEvento {}
  ```
- **Bloc**: `PerfilBloc`
  ```dart
  class PerfilBloc extends Bloc<PerfilEvento, PerfilEstado> {
    final ObtenerPerfilUsuario obtenerPerfilUsuario;

    PerfilBloc(this.obtenerPerfilUsuario) : super(PerfilInicial()) {
      on<CargarPerfil>(_onCargarPerfil);
    }

    Future<void> _onCargarPerfil(CargarPerfil event, Emitter<PerfilEstado> emit) async {
      emit(PerfilCargando());
      try {
        final usuario = await obtenerPerfilUsuario.ejecutar();
        emit(PerfilCargado(usuario));
      } catch (e) {
        emit(PerfilError('Error al cargar perfil'));
      }
    }
  }
  ```
- **Página**: `PerfilPage`
  ```dart
  class PerfilPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => sl<PerfilBloc>()..add(CargarPerfil()),
        child: Scaffold(
          appBar: AppBar(title: Text('Perfil')),
          body: BlocBuilder<PerfilBloc, PerfilEstado>(
            builder: (context, state) {
              if (state is PerfilCargando) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is PerfilCargado) {
                return Column(
                  children: [
                    Text('ID: ${state.usuario.id}'),
                    Text('Email: ${state.usuario.email}'),
                    Text('Username: ${state.usuario.username}'),
                  ],
                );
              }
              if (state is PerfilError) {
                return Center(child: Text(state.mensaje));
              }
              return SizedBox.shrink();
            },
          ),
        ),
      );
    }
  }
  ```

### 4. Inyección de Dependencias
Actualizar `inyeccion_dependencias.dart`:
- Registrar `RepositorioPerfilImpl`
- Registrar `ObtenerPerfilUsuario`
- Registrar `PerfilBloc`
- Agregar interceptor JWT a Dio:
  ```dart
  dio.interceptors.add(InterceptorJwt(sl<SharedPreferences>()));
  ```

### 5. Navegación
- Agregar ruta en `main.dart`: `'/perfil': (_) => const PerfilPage()`
- Actualizar `HomePage` para incluir botón de navegación al perfil

### 6. Interceptor JWT
Actualizar `InterceptorJwt` para usar `SharedPreferences`:
```dart
class InterceptorJwt extends Interceptor {
  final SharedPreferences storage;

  InterceptorJwt(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = storage.getString('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
```

## Flujo de Usuario
1. Usuario hace login → Token guardado
2. Navega a Home → Botón "Ver Perfil"
3. Clic en "Ver Perfil" → Navega a `/perfil`
4. `PerfilPage` carga → `PerfilBloc` dispara `CargarPerfil`
5. `ObtenerPerfilUsuario` ejecuta → `RepositorioPerfilImpl` llama `GET /users/me` con JWT
6. Backend responde con datos de usuario → Se muestra en UI

## Consideraciones
- El interceptor JWT se ejecuta automáticamente en cada request autenticada
- Manejo de errores para token expirado (debería redirigir a login)
- Posible cache del perfil para evitar requests repetidas