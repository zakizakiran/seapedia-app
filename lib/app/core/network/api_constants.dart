class ApiConstants {
  static String get baseUrl {
    return 'http://129.226.211.8/api';
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String selectRole = '/auth/select-role';
  static const String addRole = '/auth/add-role';
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
  static const String orderSummary = '/orders/summary';
  static const String buyerOrders = '/orders/buyer';

  static const String sellerOrders = '/orders/seller';

  static const String buyerSpending = '/reports/buyer/spending';
  static const String sellerIncome = '/reports/seller/income';

  static const String driverDashboard = '/deliveries/dashboard';
  static const String driverAvailableJobs = '/deliveries/available';
  static String driverJobDetail(String id) => '/deliveries/jobs/$id';
  static String driverTakeJob(String id) => '/deliveries/jobs/$id/take';
  static String driverCompleteJob(String id) => '/deliveries/jobs/$id/complete';
}
