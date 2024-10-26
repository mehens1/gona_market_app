import 'package:gona_market_app/data/models/category_model.dart';
import 'package:gona_market_app/data/models/guage_model.dart';

class ProductModel {
  final int id;
  final String title;
  final int price;
  final String description;
  final String image;
  final String? qtyAvailable;
  final CategoryModel? category;
  final GuageModel? guage;
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
    required this.addedBy,
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
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
      guage: json['guage'] != null ? GuageModel.fromJson(json['guage']) : null,
      // addedBy: UserModel.fromJson(json['added_by']),
      addedBy: json['added_by']?.toString(),
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

  @override
  String toString() {
    return 'ProductModel{id: $id, title: $title, price: $price, description: $description, image: $image, qtyAvailable: $qtyAvailable, category: $category, guage: $guage, addedBy: $addedBy, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
