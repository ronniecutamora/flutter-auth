import 'package:flutter/foundation.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../domain/models/user.dart';

/// View Model that manages profile state and user interactions
/// for the profile view and edit screens.
///
/// Exposes [isLoading], [errorMessage], and the current [user]
/// for the UI to reactively display data and feedback.
class ProfileViewModel extends ChangeNotifier {
  /// The profile repository.
  final ProfileRepository _profileRepository;

  /// Creates a [ProfileViewModel] with the given [profileRepository].
  ProfileViewModel({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository();

  /// Whether a profile operation is currently in progress.
  bool _isLoading = false;

  /// The current error message, or `null` if there is no error.
  String? _errorMessage;

  /// The currently loaded user profile, or `null` if not yet fetched.
  User? _user;

  /// Whether a profile operation is in progress.
  bool get isLoading => _isLoading;

  /// The current error message, or `null` if there is no error.
  String? get errorMessage => _errorMessage;

  /// The currently loaded [User] profile, or `null` if not yet fetched.
  User? get user => _user;

  /// Loads the profile for the given [userId].
  ///
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<void> loadProfile(String userId) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _profileRepository.getProfile(userId);
    } catch (e) {
      _setError('Failed to load profile. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the profile for the given [userId] with the provided fields.
  ///
  /// Only the fields that are passed will be updated; others retain
  /// their current values via [User.copyWith].
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> updateProfile({
    required String userId,
    String? name,
    DateTime? birthday,
    String? gender,
  }) async {
    if (_user == null) {
      _setError('No profile loaded. Load the profile first.');
      return false;
    }
    _setLoading(true);
    _clearError();
    try {
      final updated = _user!.copyWith(
        name: name,
        birthday: birthday,
        gender: gender,
      );
      _user = await _profileRepository.updateProfile(userId, updated);
      return true;
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Clears the loaded profile data (e.g. on sign-out).
  void clear() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    _clearError();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
