import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/favorites_service.dart';
import 'home_controller.dart';

class FavoritesController extends GetxController {
  final FavoritesService _favoritesService = Get.find<FavoritesService>();

  List<ProductModel> get favoriteProducts => _favoritesService.favoriteProductsList;
  
  bool get hasFavorites => _favoritesService.favorites.isNotEmpty;

  void toggleFavorite(ProductModel product) {
    _favoritesService.toggleFavorite(product);
  }
  
  bool isFavorite(String productId) {
    return _favoritesService.isFavorite(productId);
  }

  void navigateToProductDetail(ProductModel product) async {
    await Get.toNamed('/product-detail', arguments: product);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshCartCount();
    }
  }
}
