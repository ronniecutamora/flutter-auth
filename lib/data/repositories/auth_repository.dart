import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

/// Repository that serves as the single source of truth for
/// authentication-related operations.
///
/// Aggregates data from [AuthService] and exposes a clean API
/// for the View Model layer to consume.
class AuthRepository {
  /// The underlying authentication service.
  final AuthService _authService;

  /// Creates an [AuthRepository] with the given [authService].
  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  /// Signs up a new user with [email] and [password].
  ///
  /// Returns the [AuthResponse] from Supabase.
  /// Throws an [AuthException] on failure.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return _authService.signUp(email: email, password: password);
  }

  /// Signs in an existing user with [email] and [password].
  ///
  /// Returns the [AuthResponse] from Supabase.
  /// Throws an [AuthException] on failure.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
  }

  /// Signs out the currently authenticated user.
  ///
  /// Throws an [AuthException] on failure.
  Future<void> signOut() {
    return _authService.signOut();
  }

  /// Returns the current [User], or `null` if not authenticated.
  User? get currentUser => _authService.currentUser;

  /// A stream that emits [AuthState] changes (sign-in, sign-out, etc.).
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;
}
