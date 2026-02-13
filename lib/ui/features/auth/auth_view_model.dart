import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/repositories/auth_repository.dart';

/// View Model that manages authentication state and user interactions
/// for the login and sign-up screens.
///
/// Exposes [isLoading] and [errorMessage] for the UI to reactively
/// display progress indicators and error feedback.
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

  /// Whether an authentication operation is in progress.
  bool get isLoading => _isLoading;

  /// The current error message, or `null` if there is no error.
  String? get errorMessage => _errorMessage;

  /// Returns the currently authenticated [User], or `null`.
  User? get currentUser => _authRepository.currentUser;

  /// A stream that emits [AuthState] changes (sign-in, sign-out, etc.).
  Stream<AuthState> get authStateChanges => _authRepository.authStateChanges;

  /// Signs up a new user with the given [email] and [password].
  ///
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authRepository.signUp(email: email, password: password);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs in an existing user with the given [email] and [password].
  ///
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      await _authRepository.signIn(email: email, password: password);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Signs out the currently authenticated user.
  ///
  /// Sets [isLoading] to `true` during the operation and populates
  /// [errorMessage] if the operation fails.
  Future<bool> signOut() async {
    _setLoading(true);
    _clearError();
    try {
      await _authRepository.signOut();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
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
