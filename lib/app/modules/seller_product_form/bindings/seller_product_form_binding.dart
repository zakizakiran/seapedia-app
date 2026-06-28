import 'package:get/get.dart';
import '../controllers/seller_product_form_controller.dart';

class SellerProductFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerProductFormController>(() => SellerProductFormController());
  }
}
