import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final String? selectedVariation;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedVariation,
  });

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json, ProductModel product) {
    return CartItemModel(
      product: product,
      quantity: json['quantity'] ?? 1,
      selectedVariation: json['selectedVariation'],
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
