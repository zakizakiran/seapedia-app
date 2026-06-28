class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final int positiveReviewPercentage;
  final String imageUrl;
  final String category;
  final List<String> variations;
  final String storeId;
  final String storeName;
  final bool isOnSale;
  final int stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.positiveReviewPercentage,
    required this.imageUrl,
    required this.category,
    required this.variations,
    required this.storeId,
    required this.storeName,
    this.isOnSale = false,
    this.stock = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      positiveReviewPercentage: json['positiveReviewPercentage'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      variations: List<String>.from(json['variations'] ?? []),
      storeId: json['storeId']?.toString() ?? '',
      storeName: json['storeName'] ?? '',
      isOnSale: json['isOnSale'] ?? false,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'positiveReviewPercentage': positiveReviewPercentage,
      'imageUrl': imageUrl,
      'category': category,
      'variations': variations,
      'storeId': storeId,
      'storeName': storeName,
      'isOnSale': isOnSale,
      'stock': stock,
    };
  }
}
