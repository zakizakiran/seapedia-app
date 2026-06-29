import 'package:get/get.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }
    Get.lazyPut<CheckoutController>(() => CheckoutController());
  }
}
