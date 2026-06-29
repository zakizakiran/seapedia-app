import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

class CartProvider {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get(ApiConstants.cart);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to load cart');
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    String? selectedVariation,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.cartItems,
        data: {
          'productId': productId,
          'quantity': quantity,
          'selectedVariation': ?selectedVariation,
        },
      );
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add to cart');
    }
  }

  Future<void> updateCartItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      await _dio.post(
        ApiConstants.cartItems,
        data: {'productId': productId, 'quantity': quantity},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update cart');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _dio.delete('${ApiConstants.cartItems}/$productId');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to remove from cart',
      );
    }
  }

  Future<void> clearCart() async {
    try {
      await _dio.delete(ApiConstants.cart);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to clear cart');
    }
  }
}
