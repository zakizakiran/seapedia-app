import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../home/controllers/home_controller.dart';

class ProductDetailController extends GetxController {
  late final ProductModel product;
  
  final RxString selectedVariation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as ProductModel;
    if (product.variations.isNotEmpty) {
      selectedVariation.value = product.variations.first;
    }
  }

  void selectVariation(String variation) {
    selectedVariation.value = variation;
  }

  void addToCart() {
    Get.snackbar(
      'Success',
      'Added to cart',
      snackPosition: SnackPosition.TOP,
    );
    
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().cartItemCount.value++;
    }
  }
}
