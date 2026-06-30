import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  final AuthProvider _authProvider = AuthProvider();
  final AuthService _authService = Get.find<AuthService>();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }

    if (!GetUtils.isEmail(value)) {
      return 'Invalid email format';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;

      final response = await _authProvider.login(
        email: email,
        password: password,
      );

      await _authService.saveAuthData(response);

      Get.snackbar(
        'Success',
        'Login successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      if (response.requiresRoleSelection == true) {
        Get.offAllNamed('/role-selection');
      } else {
        final user = response.user;
        if (user != null) {
          if (user.activeRole == 'ADMIN' ||
              (user.roles.contains('ADMIN') && user.roles.length == 1)) {
            Get.offAllNamed('/admin-dashboard');
          } else if (user.activeRole == 'SELLER' ||
              (user.roles.contains('SELLER') && user.roles.length == 1)) {
            Get.offAllNamed('/seller-dashboard');
          } else if (user.activeRole == 'DRIVER' ||
              (user.roles.contains('DRIVER') && user.roles.length == 1)) {
            Get.offAllNamed('/driver-dashboard');
          } else {
            Get.offAllNamed('/home');
          }
        } else {
          Get.offAllNamed('/home');
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegister() {
    Get.toNamed('/register');
  }

  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    rememberMe.value = false;
  }

  void focusEmail() {
    emailFocusNode.requestFocus();
  }

  void focusPassword() {
    passwordFocusNode.requestFocus();
  }
}
