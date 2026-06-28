import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

class ReviewProvider {
  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>> getReviews({int page = 1, int limit = 10, String sort = 'newest'}) async {
    try {
      final response = await _dio.get(
        ApiConstants.reviews,
        queryParameters: {
          'page': page,
          'limit': limit,
          'sort': sort,
        },
      );
      
      final List data = response.data['data']['reviews'] ?? [];
      return data.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting reviews: $e');
      return [];
    }
  }

  Future<void> submitReview({required String name, required int rating, required String comment}) async {
    try {
      await _dio.post(
        ApiConstants.reviews,
        data: {
          'reviewerName': name,
          'rating': rating,
          'comment': comment,
        },
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to submit review');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
