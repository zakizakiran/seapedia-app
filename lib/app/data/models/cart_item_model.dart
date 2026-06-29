import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final String? selectedVariation;
  final String storeId;
  final String storeName;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedVariation,
    required this.storeId,
    required this.storeName,
  });

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = ProductModel.fromJson(json['product'] ?? json);
    return CartItemModel(
      product: product,
      quantity: json['quantity'] ?? 1,
      selectedVariation: json['selectedVariation'],
      storeId: json['storeId'] ?? product.storeId,
      storeName: json['storeName'] ?? product.storeName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'selectedVariation': selectedVariation,
    };
  }
}
