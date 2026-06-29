import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

class ReportProvider {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getBuyerSpending() async {
    try {
      final response = await _dio.get(ApiConstants.buyerSpending);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get buyer spending report',
      );
    }
  }

  Future<Map<String, dynamic>> getSellerIncome() async {
    try {
      final response = await _dio.get(ApiConstants.sellerIncome);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get seller income report',
      );
    }
  }
}
