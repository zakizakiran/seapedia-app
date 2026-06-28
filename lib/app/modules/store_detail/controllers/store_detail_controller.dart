import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/store_model.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/store_provider.dart';

class StoreDetailController extends GetxController {
  final String storeId = Get.arguments as String;
  final StoreProvider _storeProvider = StoreProvider();
  final ProductProvider _productProvider = ProductProvider();

  final Rx<StoreModel?> store = Rx<StoreModel?>(null);
  final RxList<ProductModel> products = <ProductModel>[].obs;
  
  final RxBool isLoadingStore = true.obs;
  final RxBool isLoadingProducts = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStoreDetails();
    _fetchStoreProducts();
  }

  Future<void> _fetchStoreDetails() async {
    try {
      isLoadingStore.value = true;
      final data = await _storeProvider.getStoreById(storeId);
      store.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingStore.value = false;
    }
  }

  Future<void> _fetchStoreProducts() async {
    try {
      isLoadingProducts.value = true;
      final data = await _productProvider.getProducts(storeId: storeId, limit: 20);
      products.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
