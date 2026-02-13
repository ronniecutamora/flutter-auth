import 'package:supabase_flutter/supabase_flutter.dart';

/// Service that handles authentication by querying the
/// `ronnie_users_tbl` table directly (no Supabase built-in auth).
///
/// This class isolates authentication logic so that no UI widget
/// interacts with Supabase directly.
class AuthService {
  /// The Supabase client instance.
  final SupabaseClient _client;

  /// The name of the users table in Supabase.
  static const String _tableName = 'ronnie_users_tbl';

  /// Creates an [AuthService] with the given Supabase [client].
  AuthService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Signs up a new user by inserting a row into `ronnie_users_tbl`.
  ///
  /// Returns the newly created user row as a JSON map.
  /// Throws a [PostgrestException] if the insert fails
  /// (e.g. duplicate email).
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _client
        .from(_tableName)
        .insert({'email': email, 'password': password})
        .select()
        .single();
    return response;
  }

  /// Signs in a user by querying `ronnie_users_tbl` for a matching
  /// [email] and [password].
  ///
  /// Returns the user row as a JSON map, or `null` if no match is found.
  Future<Map<String, dynamic>?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    return response;
  }
}
