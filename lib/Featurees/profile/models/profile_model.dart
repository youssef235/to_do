class ProfileModel {
  final String name;
  final String phone;
  final String level;
  final int yearsOfExperience;
  final String location;

  ProfileModel({
    required this.name,
    required this.phone,
    required this.level,
    required this.yearsOfExperience,
    required this.location,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['displayName'] ?? '',
      phone: json['username'] ?? '',
      level: json['level'] ?? '',
      yearsOfExperience: json['experienceYears'] ?? '',
      location: json['address'] ?? '',
    );
  }
}
