import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/address_model.dart';

class AddressProvider {
  final Dio _dio = DioClient().dio;

  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _dio.get(ApiConstants.addresses);
      final responseData = response.data['data'];
      final List data = responseData is List
          ? responseData
          : (responseData != null && responseData is Map
              ? responseData['addresses'] ?? []
              : []);
      return data.map((e) => AddressModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load addresses',
      );
    }
  }

  Future<AddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiConstants.addresses, data: data);
      return AddressModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create address',
      );
    }
  }

  Future<AddressModel> updateAddress(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.addresses}/$id',
        data: data,
      );
      return AddressModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to update address',
      );
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete('${ApiConstants.addresses}/$id');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to delete address',
      );
    }
  }
}
