import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Application Reviews'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSubmitForm(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('What others say', style: AppTextStyles.heading5),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (controller.reviews.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: Text('No reviews yet. Be the first!')),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final review = controller.reviews[index];
                  return _buildReviewCard(review);
                },
                childCount: controller.reviews.length,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubmitForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Write a Review', style: AppTextStyles.heading6),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.nameController,
            label: 'Your Name',
            hint: 'Enter your name',
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: controller.commentController,
            label: 'Comment',
            hint: 'Tell us about your experience',
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          Text('Rating', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(() => Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      index < controller.rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () {
                      controller.rating.value = index + 1;
                    },
                  );
                }),
              )),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Submit Review',
            width: double.infinity,
            onPressed: controller.submitReview,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['reviewerName'] ?? 'Anonymous',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < (review['rating'] ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['comment'] ?? '',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
