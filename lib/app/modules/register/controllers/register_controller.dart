import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/exceptions/validation_exception.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  
  final nameBackendError = RxnString();
  final emailBackendError = RxnString();
  final passwordBackendError = RxnString();
  
  final availableRoles = ['BUYER', 'SELLER', 'DRIVER'];
  final selectedRoles = <String>[].obs;

  final AuthProvider _authProvider = AuthProvider();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      if (nameBackendError.value != null) {
        nameBackendError.value = null;
        formKey.currentState?.validate();
      }
    });
    emailController.addListener(() {
      if (emailBackendError.value != null) {
        emailBackendError.value = null;
        formKey.currentState?.validate();
      }
    });
    passwordController.addListener(() {
      if (passwordBackendError.value != null) {
        passwordBackendError.value = null;
        formKey.currentState?.validate();
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  void toggleRole(String role) {
    if (selectedRoles.contains(role)) {
      selectedRoles.remove(role);
    } else {
      selectedRoles.add(role);
    }
  }

  String? validateName(String? value) {
    if (nameBackendError.value != null) return nameBackendError.value;
    if (value == null || value.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (emailBackendError.value != null) return emailBackendError.value;
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (passwordBackendError.value != null) return passwordBackendError.value;
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> register() async {
    nameBackendError.value = null;
    emailBackendError.value = null;
    passwordBackendError.value = null;

    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedRoles.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please select at least one role',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;
      
      final response = await _authProvider.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        roles: selectedRoles.toList(),
      );

      final authService = Get.find<AuthService>();
      await authService.saveAuthData(response);

      Get.snackbar(
        'Success',
        'Registration successful!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      if (response.requiresRoleSelection == true) {
        Get.offAllNamed('/role-selection');
      } else {
        Get.offAllNamed('/home');
      }
    } on ValidationException catch (e) {
      if (e.errors.containsKey('name')) {
        nameBackendError.value = e.errors['name'];
      }
      if (e.errors.containsKey('email')) {
        emailBackendError.value = e.errors['email'];
      }
      if (e.errors.containsKey('password')) {
        passwordBackendError.value = e.errors['password'];
      }
      
      formKey.currentState?.validate();
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
  
  void navigateToLogin() {
    Get.back();
  }
}
