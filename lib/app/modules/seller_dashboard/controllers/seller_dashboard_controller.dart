import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class SellerDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final RxInt selectedIndex = 0.obs;

  bool get hasMultipleRoles {
    final user = _authService.currentUser;
    return user != null && user.roles.length > 1;
  }

  String get activeRole {
    return _authService.currentUser?.activeRole ?? '';
  }

  List<String> get availableRoles {
    return _authService.currentUser?.roles ?? [];
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    _authService.logout();
  }
}
