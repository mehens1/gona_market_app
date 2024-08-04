class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String address;
  final String phoneNumber;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.avatarUrl,
  });

  // Factory method to create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['name'],
      lastname: json['name'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
    );
  }

  // Method to convert a UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
    };
  }
}
