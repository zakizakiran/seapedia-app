import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductProvider {
  final Dio _dio = DioClient().dio;

  Future<List<ProductModel>> getProducts({int page = 1, int limit = 12, String? search, String? storeId, String? category}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (storeId != null && storeId.isNotEmpty) {
        queryParams['storeId'] = storeId;
      }

      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams['category'] = category;
      }

      final response = await _dio.get(
        ApiConstants.products,
        queryParameters: queryParams,
      );

      final List data = response.data['data']['products'] ?? [];
      return data.map((json) {
        return ProductModel(
          id: json['id'],
          title: json['name'] ?? json['title'] ?? '',
          description: json['description'] ?? '',
          price: (json['price'] ?? 0).toDouble(),
          rating: 0.0, 
          reviewCount: 0,
          positiveReviewPercentage: 0,
          imageUrl: json['imageUrl'] ?? '',
          category: json['category'] ?? 'All', 
          variations: [], 
          storeId: json['storeId'] ?? '',
          storeName: json['store']?['name'] ?? '',
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  // Seller Endpoints
  Future<List<ProductModel>> getSellerProducts() async {
    try {
      final response = await _dio.get('/products/seller/my-products');
      final List data = response.data['data']['products'] ?? response.data['data'] ?? [];
      return data.map((json) {
        return ProductModel(
          id: json['id'],
          title: json['name'] ?? json['title'] ?? '',
          description: json['description'] ?? '',
          price: (json['price'] ?? 0).toDouble(),
          rating: 0.0,
          reviewCount: 0,
          positiveReviewPercentage: 0,
          imageUrl: json['imageUrl'] ?? '',
          category: 'All',
          variations: [],
          storeId: json['storeId'] ?? '',
          storeName: json['store']?['name'] ?? '',
          stock: json['stock'] ?? 0,
        );
      }).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get seller products');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    String? imageUrl,
    String? category,
  }) async {
    try {
      await _dio.post(
        '/products/seller',
        data: {
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
          if (category != null && category.isNotEmpty) 'category': category,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create product');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? imageUrl,
    String? category,
  }) async {
    try {
      await _dio.put(
        '/products/seller/$id',
        data: {
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
          if (category != null && category.isNotEmpty) 'category': category,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update product');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/products/seller/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete product');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
