import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    return 'https://unmumbled-wendolyn-nonfraternal.ngrok-free.dev/api';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String selectRole = '/auth/select-role';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  static const String products = '/products';

  static const String reviews = '/reviews';

  static const String wallet = '/wallets';
  static const String walletTopUp = '/wallets/top-up';

  static const String addresses = '/addresses';

  static const String cart = '/carts';
  static const String cartItems = '/carts/items';

  static const String checkout = '/orders';
  static const String buyerOrders = '/orders/buyer';

  static const String sellerOrders = '/orders/seller';
}
