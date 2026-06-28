import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  
  final RxString promoCode = ''.obs;
  final RxBool isPromoApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyCartItems();
  }

  void _loadDummyCartItems() {
    cartItems.value = [
      CartItemModel(
        product: ProductModel(
          id: '3',
          title: 'Xbox series X',
          description: '',
          price: 570.00,
          rating: 4.8,
          reviewCount: 117,
          positiveReviewPercentage: 94,
          imageUrl: 'https://images.unsplash.com/photo-1621259182978-fbf93132d53d?q=80&w=300&auto=format&fit=crop',
          category: 'Gaming',
          variations: ['1 TB', '825 GB', '512 GB'],
          storeId: 's2',
          storeName: 'Microsoft Store',
        ),
        quantity: 1,
        selectedVariation: '1 TB',
      ),
      CartItemModel(
        product: ProductModel(
          id: '4',
          title: 'Wireless Controller',
          description: '',
          price: 77.00,
          rating: 4.9,
          reviewCount: 50,
          positiveReviewPercentage: 96,
          imageUrl: 'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?q=80&w=300&auto=format&fit=crop',
          category: 'Gaming',
          variations: ['Blue', 'Black', 'White'],
          storeId: 's2',
          storeName: 'Microsoft Store',
        ),
        quantity: 1,
        selectedVariation: 'Blue',
      ),
      CartItemModel(
        product: ProductModel(
          id: '5',
          title: 'Razer Kaira Pro',
          description: '',
          price: 153.00,
          rating: 4.7,
          reviewCount: 80,
          positiveReviewPercentage: 90,
          imageUrl: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?q=80&w=300&auto=format&fit=crop',
          category: 'Gaming',
          variations: ['Green', 'Black'],
          storeId: 's2',
          storeName: 'Microsoft Store',
        ),
        quantity: 1,
        selectedVariation: 'Green',
      ),
    ];
  }

  void incrementQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void applyPromoCode(String code) {
    if (code == 'ADJ3AK') {
      promoCode.value = code;
      isPromoApplied.value = true;
    } else {
      Get.snackbar('Error', 'Invalid promo code');
    }
  }

  void removePromoCode() {
    promoCode.value = '';
    isPromoApplied.value = false;
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => cartItems.isEmpty ? 0 : 5.00; // Mock delivery fee

  double get discountAmount {
    if (isPromoApplied.value && cartItems.isNotEmpty) {
      return subtotal * 0.40; // 40% discount as per mockup
    }
    return 0;
  }

  double get total => subtotal + deliveryFee - discountAmount;

  void checkout() {
    if (cartItems.isEmpty) return;
    Get.snackbar('Success', 'Proceeding to checkout', snackPosition: SnackPosition.TOP);
  }
}
