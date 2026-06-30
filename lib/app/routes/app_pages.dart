import 'package:get/get.dart';
import 'auth_middleware.dart';

import '../modules/auth/bindings/login_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reviews/bindings/reviews_binding.dart';
import '../modules/reviews/views/reviews_view.dart';
import '../modules/seller_dashboard/bindings/seller_dashboard_binding.dart';
import '../modules/seller_dashboard/views/seller_dashboard_view.dart';
import '../modules/seller_product_form/bindings/seller_product_form_binding.dart';
import '../modules/seller_product_form/views/seller_product_form_view.dart';
import '../modules/store_detail/bindings/store_detail_binding.dart';
import '../modules/store_detail/views/store_detail_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_list_view.dart';
import '../modules/address/views/address_form_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_list_view.dart';
import '../modules/order/views/order_detail_view.dart';
import '../data/services/auth_service.dart';
import '../modules/driver_dashboard/bindings/driver_dashboard_binding.dart';
import '../modules/driver_dashboard/views/driver_dashboard_view.dart';
import '../modules/driver_job_detail/bindings/driver_job_detail_binding.dart';
import '../modules/driver_job_detail/views/driver_job_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String get initial {
    if (Get.isRegistered<AuthService>()) {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn && authService.currentUser != null) {
        final user = authService.currentUser!;

        if (user.roles.length > 1 && user.activeRole == null) {
          return Routes.ROLE_SELECTION;
        }

        if (user.activeRole == 'SELLER' ||
            (user.roles.contains('SELLER') && user.roles.length == 1)) {
          return Routes.SELLER_DASHBOARD;
        }

        if (user.activeRole == 'DRIVER' ||
            (user.roles.contains('DRIVER') && user.roles.length == 1)) {
          return Routes.DRIVER_DASHBOARD;
        }
      }
    }
    return Routes.HOME;
  }

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),
    GetPage(name: _Paths.PRODUCT_DETAIL, page: () => const ProductDetailView()),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.REVIEWS,
      page: () => const ReviewsView(),
      binding: ReviewsBinding(),
    ),
    GetPage(
      name: _Paths.SELLER_DASHBOARD,
      page: () => const SellerDashboardView(),
      binding: SellerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.SELLER_PRODUCT_FORM,
      page: () => const SellerProductFormView(),
      binding: SellerProductFormBinding(),
    ),
    GetPage(
      name: _Paths.STORE_DETAIL,
      page: () => const StoreDetailView(),
      binding: StoreDetailBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADDRESS_LIST,
      page: () => const AddressListView(),
      binding: AddressBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ADDRESS_FORM,
      page: () => const AddressFormView(),
      binding: AddressBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ORDER_LIST,
      page: () => const OrderListView(),
      binding: OrderBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.ORDER_DETAIL,
      page: () => const OrderDetailView(),
      binding: OrderBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.DRIVER_DASHBOARD,
      page: () => const DriverDashboardView(),
      binding: DriverDashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.DRIVER_JOB_DETAIL,
      page: () => const DriverJobDetailView(),
      binding: DriverJobDetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
