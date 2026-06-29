import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/cart_provider.dart';

class CartController extends GetxController {
  final CartProvider _provider = CartProvider();

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentStoreId = ''.obs;
  final RxString currentStoreName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      final data = await _provider.getCart();
      final List items = data['items'] ?? [];
      cartItems.assignAll(
        items.map((e) => CartItemModel.fromJson(e)).toList(),
      );
      if (cartItems.isNotEmpty) {
        currentStoreId.value = cartItems.first.storeId;
        currentStoreName.value = cartItems.first.storeName;
      }
    } catch (e) {
      cartItems.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart(
    ProductModel product, {
    int quantity = 1,
    String? selectedVariation,
  }) async {
    if (cartItems.isNotEmpty &&
        currentStoreId.value.isNotEmpty &&
        product.storeId != currentStoreId.value) {
      final confirm = await _showStoreConflictDialog(product.storeName);
      if (!confirm) return false;
      await clearCart();
    }

    try {
      await _provider.addToCart(
        productId: product.id,
        quantity: quantity,
        selectedVariation: selectedVariation,
      );
      await fetchCart();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  Future<bool> _showStoreConflictDialog(String newStoreName) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ganti Toko?'),
        content: Text(
          'Cart saat ini berisi produk dari "${currentStoreName.value}". '
          'Menambahkan produk dari "$newStoreName" akan menghapus cart saat ini.\n\n'
          'Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Ya, Ganti'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> incrementQuantity(int index) async {
    final item = cartItems[index];
    try {
      await _provider.updateCartItem(
        productId: item.product.id,
        quantity: item.quantity + 1,
      );
      cartItems[index].quantity++;
      cartItems.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> decrementQuantity(int index) async {
    final item = cartItems[index];
    if (item.quantity <= 1) return;
    try {
      await _provider.updateCartItem(
        productId: item.product.id,
        quantity: item.quantity - 1,
      );
      cartItems[index].quantity--;
      cartItems.refresh();
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> removeItem(int index) async {
    final item = cartItems[index];
    try {
      await _provider.removeFromCart(item.product.id);
      cartItems.removeAt(index);
      if (cartItems.isEmpty) {
        currentStoreId.value = '';
        currentStoreName.value = '';
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> clearCart() async {
    try {
      await _provider.clearCart();
      cartItems.clear();
      currentStoreId.value = '';
      currentStoreName.value = '';
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.TOP);
    }
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void goToCheckout() {
    if (cartItems.isEmpty) return;
    Get.toNamed('/checkout');
  }
}
