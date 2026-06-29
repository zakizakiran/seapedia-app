part of 'app_pages.dart';
// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const ROLE_SELECTION = _Paths.ROLE_SELECTION;
  static const PRODUCT_DETAIL = _Paths.PRODUCT_DETAIL;
  static const CART = _Paths.CART;
  static const PROFILE = _Paths.PROFILE;
  static const REVIEWS = _Paths.REVIEWS;
  static const SELLER_DASHBOARD = _Paths.SELLER_DASHBOARD;
  static const SELLER_PRODUCT_FORM = _Paths.SELLER_PRODUCT_FORM;
  static const STORE_DETAIL = _Paths.STORE_DETAIL;
  static const WALLET = _Paths.WALLET;
  static const ADDRESS_LIST = _Paths.ADDRESS_LIST;
  static const ADDRESS_FORM = _Paths.ADDRESS_FORM;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const ORDER_LIST = _Paths.ORDER_LIST;
  static const ORDER_DETAIL = _Paths.ORDER_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const ROLE_SELECTION = '/role-selection';
  static const PRODUCT_DETAIL = '/product-detail';
  static const CART = '/cart';
  static const PROFILE = '/profile';
  static const REVIEWS = '/reviews';
  static const SELLER_DASHBOARD = '/seller-dashboard';
  static const SELLER_PRODUCT_FORM = '/seller-product-form';
  static const STORE_DETAIL = '/store-detail';
  static const WALLET = '/wallet';
  static const ADDRESS_LIST = '/address-list';
  static const ADDRESS_FORM = '/address-form';
  static const CHECKOUT = '/checkout';
  static const ORDER_LIST = '/order-list';
  static const ORDER_DETAIL = '/order-detail';
}
