class UserModel {
  final int id;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      email: json['user']['email'],
      phoneNumber: json['user']['phone_number'],
      firstName: json['user']['user_detail']['first_name'],
      lastName: json['user']['user_detail']['last_name'],
    );
  }
}
