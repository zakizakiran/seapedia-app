import 'package:dio/dio.dart';
import '../../core/exceptions/validation_exception.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';

class AuthProvider {
  final Dio _dio = DioClient().dio;

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        
        if (data is Map<String, dynamic>) {
          if (data['errors'] != null && data['errors'] is List) {
            final errorsList = data['errors'] as List;
            final Map<String, String> errorsMap = {};
            
            for (var err in errorsList) {
              final field = err['field'] ?? err['param'] ?? 'general';
              final msg = err['message'] ?? err['msg'] ?? 'Invalid input';
              
              if (!errorsMap.containsKey(field)) {
                errorsMap[field] = msg;
              }
            }
            throw ValidationException(data['message'] ?? 'Validation Error', errorsMap);
          }
          
          throw Exception(data['message'] ?? 'Login failed');
        } else {
          throw Exception('Login failed: ${e.response?.statusCode}');
        }
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    required List<String> roles,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'name': name,
          'roles': roles,
        },
      );

      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        
        if (data is Map<String, dynamic>) {
          if (data['errors'] != null && data['errors'] is List) {
            final errorsList = data['errors'] as List;
            final Map<String, String> errorsMap = {};
            
            for (var err in errorsList) {
              final field = err['field'] ?? err['param'] ?? 'general';
              final msg = err['message'] ?? err['msg'] ?? 'Invalid input';
              
              if (!errorsMap.containsKey(field)) {
                errorsMap[field] = msg;
              }
            }
            throw ValidationException(data['message'] ?? 'Validation Error', errorsMap);
          }
          
          throw Exception(data['message'] ?? 'Registration failed');
        } else {
          throw Exception('Registration failed: ${e.response?.statusCode}');
        }
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AuthResponseModel> selectRole(String role) async {
    try {
      final response = await _dio.post(
        ApiConstants.selectRole,
        data: {
          'role': role,
        },
      );

      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Role selection failed');
        } else {
          throw Exception('Role selection failed: ${e.response?.statusCode}');
        }
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return response.data['data']['user'];
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to get profile');
      }
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
