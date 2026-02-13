/// Data Transfer Object representing a user
/// from the `ronnie_users_tbl` table in Supabase.
///
/// The [password] field is intentionally excluded from this model.
/// It is only used during sign-up and sign-in operations.
class User {
  /// The unique identifier for the user (UUID).
  final String id;

  /// The timestamp when the user was created.
  final DateTime createdAt;

  /// The user's display name.
  final String name;

  /// The user's date of birth.
  final DateTime? birthday;

  /// The user's gender.
  final String gender;

  /// The user's email address.
  final String email;

  /// Creates a new [User] instance.
  const User({
    required this.id,
    required this.createdAt,
    required this.email,
    this.name = '',
    this.birthday,
    this.gender = '',
  });

  /// Creates a [User] from a Supabase JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] as String,
      name: (json['name'] as String?) ?? '',
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      gender: (json['gender'] as String?) ?? '',
    );
  }

  /// Converts this [User] into a JSON map for Supabase updates.
  ///
  /// Only includes profile-editable fields. The [id], [createdAt],
  /// [email], and password are excluded because they should not be
  /// modified via profile edits.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday?.toIso8601String().split('T').first,
      'gender': gender,
    };
  }

  /// Returns a copy of this [User] with the given fields replaced.
  User copyWith({
    String? id,
    DateTime? createdAt,
    String? email,
    String? name,
    DateTime? birthday,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
    );
  }
}
