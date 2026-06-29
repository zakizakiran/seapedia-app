import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/services/auth_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxInt selectedBottomNavIndex = 0.obs;
  final RxString selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All',
    'Smartphones',
    'Headphones',
    'Laptops',
    'Gaming',
  ];

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreProducts = true.obs;
  int currentPage = 1;
  final int limit = 12;

  final RxInt cartItemCount = 0.obs;

  final ScrollController scrollController = ScrollController();

  final PageController bannerController = PageController();
  final RxInt currentBannerIndex = 0.obs;
  Timer? _bannerTimer;

  final List<Map<String, String>> banners = [
    {
      'title': 'Clearance\nSales',
      'subtitle': '% Up to 50%',
      'image':
          'https://images.unsplash.com/photo-1616348436168-de43ad0db179?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'New\nArrivals',
      'subtitle': 'Explore Now',
      'image':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Gadget\nFest',
      'subtitle': 'Extra 20% Off',
      'image':
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?q=80&w=600&auto=format&fit=crop',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadProducts(isRefresh: true);
    _startBannerTimer();
    refreshCartCount();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadProducts();
    }
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (bannerController.hasClients) {
        int nextIndex = (currentBannerIndex.value + 1) % banners.length;
        bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    // Do not dispose scrollController and bannerController here. 
    // GetX calls onClose immediately when the route pops, but the view remains 
    // in the tree during the transition animation. Disposing them now causes 
    // "A ScrollController was used after being disposed" errors.
    super.onClose();
  }

  Future<void> _loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreProducts.value = true;
      isLoadingProducts.value = true;
    } else {
      if (isLoadingMore.value || !hasMoreProducts.value) return;
      isLoadingMore.value = true;
    }

    try {
      final provider = ProductProvider();
      final data = await provider.getProducts(page: currentPage, limit: limit);

      if (isRefresh) {
        if (data.isNotEmpty) {
          products.assignAll(data);
        } else {
          products.value = [
            ProductModel(
              id: '1',
              title: 'AirPods',
              description: 'Apple AirPods with great sound quality.',
              price: 132.00,
              rating: 4.9,
              reviewCount: 300,
              positiveReviewPercentage: 98,
              imageUrl:
                  'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?q=80&w=300&auto=format&fit=crop',
              category: 'Headphones',
              variations: ['White'],
              storeId: 's1',
              storeName: 'Apple Store',
            ),
          ];
        }
      } else {
        products.addAll(data);
      }

      if (data.length < limit) {
        hasMoreProducts.value = false;
      } else {
        currentPage++;
      }
    } finally {
      isLoadingProducts.value = false;
      isLoadingMore.value = false;
    }
  }

  void changeBottomNavIndex(int index) {
    if (index == 2 || index == 3) {
      if (!_authService.isLoggedIn) {
        Get.toNamed('/login');
        return;
      }
    }
    selectedBottomNavIndex.value = index;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void navigateToProductDetail(ProductModel product) {
    Get.toNamed('/product-detail', arguments: product);
  }

  void navigateToCart() {
    Get.toNamed('/cart');
  }

  Future<void> refreshCartCount() async {
    if (!_authService.isLoggedIn) return;
    try {
      final data = await CartProvider().getCart();
      final List items = data['items'] ?? [];
      int total = 0;
      for (final item in items) {
        total += (item['quantity'] as int? ?? 1);
      }
      cartItemCount.value = total;
    } catch (_) {
      cartItemCount.value = 0;
    }
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed('/login');
  }
}
