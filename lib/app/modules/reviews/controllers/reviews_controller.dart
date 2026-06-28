import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../data/providers/review_provider.dart';

class ReviewsController extends GetxController {
  final ReviewProvider _provider = ReviewProvider();
  
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;

  final nameController = TextEditingController();
  final commentController = TextEditingController();
  final RxInt rating = 5.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  @override
  void onClose() {
    nameController.dispose();
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;
      final data = await _provider.getReviews();
      reviews.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reviews');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReview() async {
    if (nameController.text.trim().isEmpty || commentController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    
    try {
      await _provider.submitReview(
        name: nameController.text.trim(),
        rating: rating.value,
        comment: commentController.text.trim(),
      );
      Get.snackbar('Success', 'Review submitted successfully');
      nameController.clear();
      commentController.clear();
      rating.value = 5;
      
      fetchReviews();
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    }
  }
}
