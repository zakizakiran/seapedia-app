import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthProvider _authProvider = AuthProvider();

  final RxMap<String, dynamic> profileData = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final data = await _authProvider.getProfile();
      profileData.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch profile: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authService.logout();
  }
}
