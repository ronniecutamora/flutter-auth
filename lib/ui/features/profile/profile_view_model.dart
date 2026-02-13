import 'package:flutter/foundation.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../domain/models/profile.dart';

/// View Model that manages profile state and user interactions
/// for the profile view and edit screens.
///
/// Exposes [isLoading], [errorMessage], and the current [profile]
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

  /// The currently loaded profile, or `null` if not yet fetched.
  Profile? _profile;

  /// Whether a profile operation is in progress.
  bool get isLoading => _isLoading;

  /// The current error message, or `null` if there is no error.
  String? get errorMessage => _errorMessage;

  /// The currently loaded [Profile], or `null` if not yet fetched.
  Profile? get profile => _profile;

  /// Loads the profile for the given [userId].
  ///
  /// If no profile exists, one is created automatically.
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<void> loadProfile(String userId) async {
    _setLoading(true);
    _clearError();
    try {
      final fetched = await _profileRepository.getProfile(userId);
      if (fetched != null) {
        _profile = fetched;
      } else {
        _profile = await _profileRepository.createProfile(userId: userId);
      }
    } catch (e) {
      _setError('Failed to load profile. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the profile for the given [userId] with the provided fields.
  ///
  /// Only the fields that are passed will be updated; others retain
  /// their current values via [Profile.copyWith].
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> updateProfile({
    required String userId,
    String? name,
    DateTime? birthday,
    String? gender,
  }) async {
    if (_profile == null) {
      _setError('No profile loaded. Load the profile first.');
      return false;
    }
    _setLoading(true);
    _clearError();
    try {
      final updated = _profile!.copyWith(
        name: name,
        birthday: birthday,
        gender: gender,
      );
      _profile = await _profileRepository.updateProfile(userId, updated);
      return true;
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
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
