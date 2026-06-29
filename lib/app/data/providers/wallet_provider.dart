import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/wallet_model.dart';

class WalletProvider {
  final Dio _dio = DioClient().dio;

  Future<WalletModel> getWallet() async {
    try {
      final response = await _dio.get(ApiConstants.wallet);
      return WalletModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load wallet',
      );
    }
  }

  Future<WalletModel> topUp(double amount) async {
    try {
      final response = await _dio.post(
        ApiConstants.walletTopUp,
        data: {'amount': amount},
      );
      return WalletModel.fromJson(response.data['data']['wallet'] ?? response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to top up',
      );
    }
  }

  Future<List<WalletTransactionModel>> getTransactions() async {
    try {
      final response = await _dio.get(ApiConstants.wallet);
      final responseData = response.data['data'];
      final List data = responseData is List
          ? responseData
          : (responseData != null && responseData is Map
              ? responseData['transactions'] ?? []
              : []);
      return data.map((e) => WalletTransactionModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to load transactions',
      );
    }
  }
}
