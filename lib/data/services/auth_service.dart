import 'package:supabase_flutter/supabase_flutter.dart';

/// Service that handles all direct Supabase Auth API calls.
///
/// This class isolates authentication logic so that no UI widget
/// interacts with Supabase directly.
class AuthService {
  /// The Supabase client instance.
  final SupabaseClient _client;

  /// Creates an [AuthService] with the given Supabase [client].
  AuthService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Signs up a new user with [email] and [password].
  ///
  /// Returns the [AuthResponse] from Supabase.
  /// Throws an [AuthException] if the sign-up fails.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  /// Signs in an existing user with [email] and [password].
  ///
  /// Returns the [AuthResponse] from Supabase.
  /// Throws an [AuthException] if the sign-in fails.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Signs out the currently authenticated user.
  ///
  /// Throws an [AuthException] if the sign-out fails.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Returns the current [User], or `null` if not authenticated.
  User? get currentUser => _client.auth.currentUser;

  /// A stream that emits [AuthState] changes (sign-in, sign-out, etc.).
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
