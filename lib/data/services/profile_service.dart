import 'package:supabase_flutter/supabase_flutter.dart';

/// Service that handles all direct Supabase Database calls
/// for the `ronnie_users_tbl` table (profile fields).
///
/// This class isolates profile data access so that no UI widget
/// interacts with Supabase directly.
class ProfileService {
  /// The Supabase client instance.
  final SupabaseClient _client;

  /// The name of the users table in Supabase.
  static const String _tableName = 'ronnie_users_tbl';

  /// Creates a [ProfileService] with the given Supabase [client].
  ProfileService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetches the user row for the given [userId].
  ///
  /// Returns the user data as a JSON map, or `null` if not found.
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  /// Updates the user row for the given [userId] with the provided [data].
  ///
  /// Returns the updated user data as a JSON map.
  Future<Map<String, dynamic>> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _client
        .from(_tableName)
        .update(data)
        .eq('id', userId)
        .select()
        .single();
    return response;
  }
}
