import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/product_model.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';

class ProductDetailController extends GetxController {
  late final ProductModel product;

  final RxString selectedVariation = ''.obs;
  final RxBool isAddingToCart = false.obs;

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

  Future<void> addToCart() async {
    final authService = Get.find<AuthService>();
    if (!authService.isLoggedIn) {
      Get.toNamed('/login');
      return;
    }

    if (isAddingToCart.value) return;

    try {
      isAddingToCart.value = true;

      CartController cartController;
      if (Get.isRegistered<CartController>()) {
        cartController = Get.find<CartController>();
      } else {
        cartController = Get.put(CartController());
      }

      final success = await cartController.addToCart(
        product,
        selectedVariation: selectedVariation.value.isNotEmpty
            ? selectedVariation.value
            : null,
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          '${product.title} ditambahkan ke keranjang',
          snackPosition: SnackPosition.TOP,
        );

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().refreshCartCount();
        }
      }
    } finally {
      isAddingToCart.value = false;
    }
  }
}
