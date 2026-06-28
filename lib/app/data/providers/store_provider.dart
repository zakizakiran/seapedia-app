import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/store_model.dart';

class StoreProvider {
  final Dio _dio = DioClient().dio;

  Future<StoreModel?> getMyStore() async {
    try {
      final response = await _dio.get('/stores/seller/my-store');
      if (response.data != null && response.data['data'] != null) {
        return StoreModel.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Store not found (not created yet)
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get store profile',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<StoreModel> createStore({
    required String name,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        '/stores/seller',
        data: {'name': name, 'description': description},
      );
      return StoreModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create store');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<StoreModel> updateStore({
    required String name,
    required String description,
  }) async {
    try {
      final response = await _dio.put(
        '/stores/seller',
        data: {'name': name, 'description': description},
      );

      if (response.data != null && response.data['data'] != null) {
        return StoreModel.fromJson(response.data['data']);
      }
      return StoreModel(id: '', name: name, description: description);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update store');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<StoreModel?> getStoreById(String id) async {
    try {
      final response = await _dio.get('/stores/$id');
      if (response.data != null &&
          response.data['data'] != null &&
          response.data['data']['store'] != null) {
        return StoreModel.fromJson(response.data['data']['store']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception(e.response?.data['message'] ?? 'Failed to get store');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}
