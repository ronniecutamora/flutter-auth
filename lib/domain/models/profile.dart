/// Data Transfer Object representing a user profile
/// from the `ronnie_profile_tbl` table in Supabase.
class Profile {
  /// The unique identifier for the profile (UUID).
  final String id;

  /// The timestamp when the profile was created.
  final DateTime createdAt;

  /// The user's display name.
  final String name;

  /// The user's date of birth.
  final DateTime? birthday;

  /// The user's gender.
  final String gender;

  /// Creates a new [Profile] instance.
  const Profile({
    required this.id,
    required this.createdAt,
    this.name = '',
    this.birthday,
    this.gender = '',
  });

  /// Creates a [Profile] from a Supabase JSON map.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: (json['name'] as String?) ?? '',
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      gender: (json['gender'] as String?) ?? '',
    );
  }

  /// Converts this [Profile] into a JSON map for Supabase.
  ///
  /// The [id] and [createdAt] fields are excluded because they are
  /// managed server-side by Supabase defaults.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday?.toIso8601String().split('T').first,
      'gender': gender,
    };
  }

  /// Returns a copy of this [Profile] with the given fields replaced.
  Profile copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    DateTime? birthday,
    String? gender,
  }) {
    return Profile(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
    );
  }
}
