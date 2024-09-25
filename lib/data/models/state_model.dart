class StateModel {
  final int id;
  final String state;

  StateModel({required this.id, required this.state});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      state: json['state'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
    };
  }
}
