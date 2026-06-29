import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/product_provider.dart';
import 'home_controller.dart';

class SearchTabController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;

  Timer? _debounce;
  final ProductProvider _productProvider = ProductProvider();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      final text = searchController.text.trim();
      if (text != searchQuery.value) {
        searchQuery.value = text;
        _onSearchChanged(text);
      }
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    isLoading.value = true;
    hasSearched.value = true;
    try {
      final results = await _productProvider.getProducts(search: query, limit: 20);
      searchResults.assignAll(results);
    } catch (e) {
      debugPrint('Search error: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToProductDetail(ProductModel product) async {
    await Get.toNamed('/product-detail', arguments: product);
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshCartCount();
    }
  }
}
