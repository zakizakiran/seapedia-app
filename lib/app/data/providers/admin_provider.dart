import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';

class AdminProvider {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await _dio.get('${ApiConstants.adminDashboard}?t=$timestamp');
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load dashboard');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getVouchers() async {
    try {
      final response = await _dio.get(ApiConstants.discountsVouchers);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load vouchers');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getPromos() async {
    try {
      final response = await _dio.get(ApiConstants.discountsPromos);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load promos');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> createVoucher(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiConstants.discountsVouchers, data: data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create voucher');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> createPromo(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiConstants.discountsPromos, data: data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to create promo');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getOverdueOrders() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await _dio.get('${ApiConstants.adminOverdueOrders}?t=$timestamp');
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load overdue orders');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> processOverdue() async {
    try {
      final response = await _dio.post(ApiConstants.adminOverdueProcess);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to process overdue');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> simulateDay() async {
    try {
      await _dio.post(ApiConstants.adminSimulateDay);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to simulate day');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> resetSimulatedTime() async {
    try {
      await _dio.post(ApiConstants.adminSimulateDayReset);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to reset time');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getTimeInfo() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await _dio.get('${ApiConstants.adminTimeInfo}?t=$timestamp');
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get time info');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getUsers() async {
    try {
      final response = await _dio.get(ApiConstants.adminUsers);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get users');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getOrders() async {
    try {
      final response = await _dio.get(ApiConstants.adminOrders);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get orders');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getStores() async {
    try {
      final response = await _dio.get(ApiConstants.adminStores);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get stores');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _dio.get(ApiConstants.adminProducts);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get products');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getDeliveryJobs() async {
    try {
      final response = await _dio.get(ApiConstants.adminDeliveryJobs);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get delivery jobs');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
