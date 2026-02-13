import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/auth_view_model.dart';
import 'profile_view_model.dart';

/// Profile edit view that allows users to modify their profile fields.
///
/// Pre-populates form fields from the current [ProfileViewModel.user]
/// and saves changes via [ProfileViewModel.updateProfile].
class ProfileEditView extends StatefulWidget {
  /// Creates a [ProfileEditView].
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  DateTime? _selectedBirthday;
  String? _selectedGender;

  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileViewModel>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _selectedBirthday = user?.birthday;
    _selectedGender =
        (user?.gender != null && user!.gender.isNotEmpty)
            ? user.gender
            : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select birthday';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthViewModel>().currentUser?.id;
    if (userId == null) return;

    final viewModel = context.read<ProfileViewModel>();
    final success = await viewModel.updateProfile(
      userId: userId,
      name: _nameController.text.trim(),
      birthday: _selectedBirthday,
      gender: _selectedGender ?? '',
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (viewModel.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickBirthday,
                    borderRadius: BorderRadius.circular(4),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        prefixIcon: Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _formatDate(_selectedBirthday),
                        style: _selectedBirthday == null
                            ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                )
                            : Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: _genderOptions
                        .map(
                          (g) => DropdownMenuItem(value: g, child: Text(g)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: viewModel.isLoading ? null : _save,
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
