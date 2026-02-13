import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/auth_view.dart';
import 'features/profile/profile_view.dart';

/// A widget that listens to Supabase auth state changes and conditionally
/// renders either the [AuthView] or the [ProfileView].
///
/// This serves as the root routing logic for the app. When a valid session
/// exists the user sees their profile; otherwise the login/signup screen
/// is shown.
class AuthGate extends StatelessWidget {
  /// Creates an [AuthGate].
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const ProfileView();
        }

        return const AuthView();
      },
    );
  }
}
