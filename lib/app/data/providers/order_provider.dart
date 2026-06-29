import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/order_model.dart';

class OrderProvider {
  final Dio _dio = DioClient().dio;

  Future<OrderModel> checkout(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.checkout, data: data);
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Checkout failed',
      );
    }
  }

  Future<List<OrderModel>> getBuyerOrders() async {
    try {
      final response = await _dio.get(ApiConstants.buyerOrders);
      final responseData = response.data['data'];
      final List data = responseData is List
          ? responseData
          : (responseData != null && responseData is Map
              ? responseData['orders'] ?? []
              : []);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load orders',
      );
    }
  }

  Future<OrderModel> getOrderDetail(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.buyerOrders}/$id');
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load order detail',
      );
    }
  }

  Future<List<OrderModel>> getSellerOrders() async {
    try {
      final response = await _dio.get(ApiConstants.sellerOrders);
      final responseData = response.data['data'];
      final List data = responseData is List
          ? responseData
          : (responseData != null && responseData is Map
              ? responseData['orders'] ?? []
              : []);
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load seller orders',
      );
    }
  }

  Future<Map<String, dynamic>> getCheckoutSummary(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.orderSummary, data: data);
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get checkout summary',
      );
    }
  }

  Future<OrderModel> processOrder(String orderId) async {
    try {
      final response = await _dio.patch('${ApiConstants.sellerOrders}/$orderId/process');
      return OrderModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to process order',
      );
    }
  }
}
