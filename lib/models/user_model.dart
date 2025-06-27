class AppUser {
  final String uid;
  final String name;
  final String email;
  final String healthGoal;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String profileImageUrl;
  final bool isPremium;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.healthGoal,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    this.profileImageUrl = '',
    this.isPremium = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      healthGoal: map['healthGoal'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      weight: (map['weight'] ?? 70).toDouble(),
      height: (map['height'] ?? 170).toDouble(),
      profileImageUrl: map['profileImageUrl'] ?? '',
      isPremium: map['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'healthGoal': healthGoal,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'profileImageUrl': profileImageUrl,
      'isPremium': isPremium,
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? healthGoal,
    int? age,
    String? gender,
    double? weight,
    double? height,
    String? profileImageUrl,
    bool? isPremium,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      healthGoal: healthGoal ?? this.healthGoal,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
