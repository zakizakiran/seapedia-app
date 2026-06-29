import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/address_model.dart';
import '../../../data/providers/address_provider.dart';

class AddressController extends GetxController {
  final AddressProvider _provider = AddressProvider();

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  final labelController = TextEditingController();
  final recipientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final fullAddressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final RxBool isDefault = false.obs;

  AddressModel? editingAddress;
  bool get isEditing => editingAddress != null;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  @override
  void onClose() {
    labelController.dispose();
    recipientNameController.dispose();
    phoneController.dispose();
    fullAddressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final data = await _provider.getAddresses();
      addresses.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void prepareEdit(AddressModel address) {
    editingAddress = address;
    labelController.text = address.label;
    recipientNameController.text = address.recipientName;
    phoneController.text = address.phone;
    fullAddressController.text = address.fullAddress;
    cityController.text = address.city;
    postalCodeController.text = address.postalCode;
    isDefault.value = address.isDefault;
  }

  void clearForm() {
    editingAddress = null;
    labelController.clear();
    recipientNameController.clear();
    phoneController.clear();
    fullAddressController.clear();
    cityController.clear();
    postalCodeController.clear();
    isDefault.value = false;
  }

  Future<void> saveAddress() async {
    if (labelController.text.trim().isEmpty ||
        recipientNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        fullAddressController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.TOP);
      return;
    }

    final fullAddr = '${fullAddressController.text.trim()}, ${cityController.text.trim()} ${postalCodeController.text.trim()}';
    final data = {
      'title': labelController.text.trim(),
      'recipientName': recipientNameController.text.trim(),
      'phoneNumber': phoneController.text.trim(),
      'fullAddress': fullAddr,
      'isDefault': isDefault.value,
    };

    try {
      isSaving.value = true;
      if (isEditing) {
        await _provider.updateAddress(editingAddress!.id, data);
      } else {
        await _provider.createAddress(data);
      }
      clearForm();
      Get.back();
      await fetchAddresses();
      Get.snackbar(
        'Success',
        isEditing ? 'Address updated' : 'Address added',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _provider.deleteAddress(id);
      await fetchAddresses();
      Get.snackbar('Success', 'Address deleted',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
