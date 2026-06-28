import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class SellerDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    _authService.logout();
    Get.offAllNamed('/login');
  }
}
