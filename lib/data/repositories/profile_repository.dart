import '../../domain/models/user.dart';
import '../services/profile_service.dart';

/// Repository that serves as the single source of truth for
/// profile-related data operations.
///
/// Aggregates data from [ProfileService], converts raw JSON into
/// [User] model objects, and exposes a clean API for the
/// View Model layer to consume.
class ProfileRepository {
  /// The underlying profile service.
  final ProfileService _profileService;

  /// Creates a [ProfileRepository] with the given [profileService].
  ProfileRepository({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  /// Fetches the [User] for the given [userId].
  ///
  /// Returns `null` if no user row exists for that id.
  Future<User?> getProfile(String userId) async {
    final json = await _profileService.getProfile(userId);
    if (json == null) return null;
    return User.fromJson(json);
  }

  /// Updates the profile fields for the given [userId] with
  /// the provided [user] data.
  ///
  /// Returns the updated [User].
  Future<User> updateProfile(String userId, User user) async {
    final json = await _profileService.updateProfile(
      userId,
      user.toJson(),
    );
    return User.fromJson(json);
  }
}
