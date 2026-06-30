import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

class DeliveryProvider {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _dio.get(ApiConstants.driverDashboard);
      return response.data['data'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load dashboard');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<dynamic>> getAvailableJobs() async {
    try {
      final response = await _dio.get(ApiConstants.driverAvailableJobs);
      return response.data['data']['jobs'] ?? [];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load jobs');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getJobDetail(String id) async {
    try {
      final response = await _dio.get(ApiConstants.driverJobDetail(id));
      return response.data['data']['job'] ?? response.data['data'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load job detail');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> takeJob(String orderId) async {
    try {
      final response = await _dio.post(ApiConstants.driverTakeJob(orderId));
      return response.data['data'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to take job');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> completeJob(String jobId) async {
    try {
      final response = await _dio.patch(ApiConstants.driverCompleteJob(jobId));
      return response.data['data'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to complete job');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
