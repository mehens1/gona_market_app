class GuageModel {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GuageModel({required this.id, required this.name, this.createdAt, this.updatedAt});

  factory GuageModel.fromJson(Map<String, dynamic> json) {
    return GuageModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}