abstract class RepositorioAutenticacion {
  Future<void> registrar({
    required String email,
    required String username,
    required String password,
    required String paisOrigen,
  });

  Future<String> login({
    required String email,
    required String password,
  });
}
