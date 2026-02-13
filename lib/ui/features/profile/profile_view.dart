import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_view_model.dart';
import 'profile_edit_view.dart';
import 'profile_view_model.dart';

/// Profile view that displays the current user's profile information.
///
/// Loads the profile on initialization and provides navigation
/// to [ProfileEditView] for editing. Uses [Consumer] for reactive rebuilds.
class ProfileView extends StatefulWidget {
  /// Creates a [ProfileView].
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final userId = context.read<AuthViewModel>().currentUser?.id;
    if (userId != null) {
      context.read<ProfileViewModel>().loadProfile(userId);
    }
  }

  void _signOut() {
    context.read<ProfileViewModel>().clear();
    context.read<AuthViewModel>().signOut();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: () async {
              final didUpdate = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: context.read<ProfileViewModel>(),
                    child: const ProfileEditView(),
                  ),
                ),
              );
              if (didUpdate == true && mounted) {
                _loadProfile();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: _loadProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = viewModel.user;
          if (user == null) {
            return const Center(child: Text('No profile data.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ProfileTile(
                icon: Icons.person_outline,
                label: 'Name',
                value: user.name.isEmpty ? 'Not set' : user.name,
              ),
              _ProfileTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user.email,
              ),
              _ProfileTile(
                icon: Icons.cake_outlined,
                label: 'Birthday',
                value: _formatDate(user.birthday),
              ),
              _ProfileTile(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: user.gender.isEmpty ? 'Not set' : user.gender,
              ),
              _ProfileTile(
                icon: Icons.calendar_today_outlined,
                label: 'Member Since',
                value: _formatDate(user.createdAt),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A single row displaying a profile field with an icon, label, and value.
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
