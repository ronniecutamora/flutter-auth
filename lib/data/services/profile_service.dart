import 'package:supabase_flutter/supabase_flutter.dart';

/// Service that handles all direct Supabase Database calls
/// for the `ronnie_profile_tbl` table.
///
/// This class isolates profile data access so that no UI widget
/// interacts with Supabase directly.
class ProfileService {
  /// The Supabase client instance.
  final SupabaseClient _client;

  /// The name of the profiles table in Supabase.
  static const String _tableName = 'ronnie_profile_tbl';

  /// Creates a [ProfileService] with the given Supabase [client].
  ProfileService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetches the profile for the given [userId].
  ///
  /// Returns the profile data as a JSON map, or `null` if not found.
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  /// Creates a new profile row with the given [data].
  ///
  /// The [data] map should contain the column values for the new row.
  /// The `id` field should be included to link to the authenticated user.
  Future<Map<String, dynamic>> createProfile(
    Map<String, dynamic> data,
  ) async {
    final response =
        await _client.from(_tableName).insert(data).select().single();
    return response;
  }

  /// Updates the profile for the given [userId] with the provided [data].
  ///
  /// Returns the updated profile data as a JSON map.
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
