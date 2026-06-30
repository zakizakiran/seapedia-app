import 'package:get/get.dart';
import '../controllers/admin_stores_controller.dart';

class AdminStoresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminStoresController>(() => AdminStoresController());
  }
}
