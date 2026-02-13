import 'package:flutter/foundation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';

/// View Model that manages authentication state and user interactions
/// for the login and sign-up screens.
///
/// Holds the currently signed-in [User] in memory. Exposes [isLoggedIn],
/// [isLoading], and [errorMessage] for the UI to reactively display
/// progress indicators, error feedback, and routing decisions.
class AuthViewModel extends ChangeNotifier {
  /// The authentication repository.
  final AuthRepository _authRepository;

  /// Creates an [AuthViewModel] with the given [authRepository].
  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  /// Whether an authentication operation is currently in progress.
  bool _isLoading = false;

  /// The current error message, or `null` if there is no error.
  String? _errorMessage;

  /// The currently signed-in user, or `null` if not authenticated.
  User? _currentUser;

  /// Whether an authentication operation is in progress.
  bool get isLoading => _isLoading;

  /// The current error message, or `null` if there is no error.
  String? get errorMessage => _errorMessage;

  /// Returns the currently signed-in [User], or `null`.
  User? get currentUser => _currentUser;

  /// Whether a user is currently signed in.
  bool get isLoggedIn => _currentUser != null;

  /// Signs up a new user with the given [email] and [password].
  ///
  /// On success the new user is stored as the current session user.
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      _currentUser = await _authRepository.signUp(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Sign up failed. The email may already be in use.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs in an existing user with the given [email] and [password].
  ///
  /// On success the user is stored as the current session user.
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      if (user == null) {
        _setError('Invalid email or password.');
        return false;
      }
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs out the current user by clearing the in-memory session.
  void signOut() {
    _currentUser = null;
    _clearError();
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
