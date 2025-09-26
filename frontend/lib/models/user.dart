class User {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '', 
      email: json['email'] ?? '',
    );
  }
}
