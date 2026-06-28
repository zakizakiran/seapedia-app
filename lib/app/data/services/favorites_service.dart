import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class FavoritesService extends GetxService {
  final _prefs = SharedPreferences.getInstance();
  static const _favoritesKey = 'favorite_products';

  final RxMap<String, ProductModel> favorites = <String, ProductModel>{}.obs;

  Future<FavoritesService> init() async {
    await _loadFavorites();
    return this;
  }

  Future<void> _loadFavorites() async {
    final prefs = await _prefs;
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final Map<String, dynamic> decodedMap = json.decode(favoritesJson);
      final Map<String, ProductModel> loadedFavorites = {};
      decodedMap.forEach((key, value) {
        loadedFavorites[key] = ProductModel.fromJson(value);
      });
      favorites.assignAll(loadedFavorites);
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await _prefs;
    final Map<String, dynamic> mapToSave = {};
    favorites.forEach((key, value) {
      mapToSave[key] = value.toJson();
    });
    await prefs.setString(_favoritesKey, json.encode(mapToSave));
  }

  bool isFavorite(String productId) {
    return favorites.containsKey(productId);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    if (isFavorite(product.id)) {
      favorites.remove(product.id);
    } else {
      favorites[product.id] = product;
    }
    await _saveFavorites();
  }

  List<ProductModel> get favoriteProductsList => favorites.values.toList();
}
