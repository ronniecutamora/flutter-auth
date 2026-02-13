import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_view.dart';
import 'features/auth/auth_view_model.dart';
import 'features/profile/profile_view.dart';

/// A widget that watches [AuthViewModel.isLoggedIn] and conditionally
/// renders either the [AuthView] or the [ProfileView].
///
/// This serves as the root routing logic for the app. When a user
/// is signed in (held in memory) the profile screen is shown;
/// otherwise the login/signup screen is displayed.
class AuthGate extends StatelessWidget {
  /// Creates an [AuthGate].
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthViewModel>().isLoggedIn;

    if (isLoggedIn) {
      return const ProfileView();
    }

    return const AuthView();
  }
}
