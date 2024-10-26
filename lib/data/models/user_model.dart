class UserModel {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? fullName;
  final String? address;
  final String phoneNumber;
  final StateModel? state;
  final LgaModel? lga;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    this.fullName,
    this.address,
    this.state,
    this.lga,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      fullName: '${json['first_name']} ${json['last_name']}',
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      state: StateModel.fromJson(json['state']),
      lga: LgaModel.fromJson(json['lga']),
      avatarUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'full_name': fullName,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'state': state?.toJson(),
      'lga': lga?.toJson(), 
      'avatar_url': avatarUrl,
    };
  }
}

class StateModel {
  final int id;
  final String stateName;

  StateModel({required this.id, required this.stateName});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      stateName: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': stateName,
    };
  }
}
class LgaModel {
  final int id;
  final String lgaName;

  LgaModel({required this.id, required this.lgaName});

  factory LgaModel.fromJson(Map<String, dynamic> json) {
    return LgaModel(
      id: json['id'],
      lgaName: json['lga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lga': lgaName,
    };
  }
}
