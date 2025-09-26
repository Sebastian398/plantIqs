class UserDetail {
  final String firstName;
  final String lastName;
  final String email;

  UserDetail({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
    );
  }
}
