import 'package:get/get.dart';
import '../controllers/my_products_controller.dart';
import '../controllers/seller_dashboard_controller.dart';
import '../controllers/store_profile_controller.dart';

class SellerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerDashboardController>(() => SellerDashboardController());
    Get.lazyPut<StoreProfileController>(() => StoreProfileController());
    Get.lazyPut<MyProductsController>(() => MyProductsController());
  }
}
