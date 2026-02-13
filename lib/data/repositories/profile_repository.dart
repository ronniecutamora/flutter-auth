import '../../domain/models/profile.dart';
import '../services/profile_service.dart';

/// Repository that serves as the single source of truth for
/// profile-related data operations.
///
/// Aggregates data from [ProfileService], converts raw JSON into
/// [Profile] model objects, and exposes a clean API for the
/// View Model layer to consume.
class ProfileRepository {
  /// The underlying profile service.
  final ProfileService _profileService;

  /// Creates a [ProfileRepository] with the given [profileService].
  ProfileRepository({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  /// Fetches the [Profile] for the given [userId].
  ///
  /// Returns `null` if no profile exists for that user.
  Future<Profile?> getProfile(String userId) async {
    final json = await _profileService.getProfile(userId);
    if (json == null) return null;
    return Profile.fromJson(json);
  }

  /// Creates a new profile for the user with [userId] and the given fields.
  ///
  /// Returns the newly created [Profile].
  Future<Profile> createProfile({
    required String userId,
    String name = '',
    DateTime? birthday,
    String gender = '',
  }) async {
    final data = {
      'id': userId,
      'name': name,
      'birthday': birthday?.toIso8601String().split('T').first,
      'gender': gender,
    };
    final json = await _profileService.createProfile(data);
    return Profile.fromJson(json);
  }

  /// Updates the profile for the given [userId] with the provided [profile].
  ///
  /// Returns the updated [Profile].
  Future<Profile> updateProfile(String userId, Profile profile) async {
    final json = await _profileService.updateProfile(
      userId,
      profile.toJson(),
    );
    return Profile.fromJson(json);
  }
}
