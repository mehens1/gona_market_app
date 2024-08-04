import 'package:gona_market_app/data/models/guage_model.dart';

class ProductModel {
  final int id;
  final String title;
  final int price;
  final String description;
  final String image;
  final String? qtyAvailable;
  final String? category;
  final Guage? guage;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    this.qtyAvailable,
    this.category,
    this.guage,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      image: json['image'],
      qtyAvailable: json['qty_available']?.toString(),
      category: json['category'],
      guage: json['guage'] != null ? Guage.fromJson(json['guage']) : null,
      addedBy: json['added_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'qty_available': qtyAvailable,
      'category': category,
      'guage': guage,
      'added_by': addedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
