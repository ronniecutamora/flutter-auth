import '../../domain/models/user.dart';
import '../services/auth_service.dart';

/// Repository that serves as the single source of truth for
/// authentication-related operations.
///
/// Aggregates data from [AuthService], converts raw JSON into
/// [User] model objects, and exposes a clean API for the
/// View Model layer to consume.
class AuthRepository {
  /// The underlying authentication service.
  final AuthService _authService;

  /// Creates an [AuthRepository] with the given [authService].
  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Signs up a new user with [email] and [password].
  ///
  /// Returns the newly created [User].
  /// Throws on failure (e.g. duplicate email).
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    final json = await _authService.signUp(
      email: email,
      password: password,
    );
    return User.fromJson(json);
  }

  /// Signs in a user with [email] and [password].
  ///
  /// Returns the matching [User], or `null` if the credentials
  /// are invalid.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final json = await _authService.signIn(
      email: email,
      password: password,
    );
    if (json == null) return null;
    return User.fromJson(json);
  }
}
