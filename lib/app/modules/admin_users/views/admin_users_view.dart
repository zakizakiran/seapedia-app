import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/admin_users_controller.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../core/widgets/custom_text_field.dart';


class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Users', style: AppTextStyles.heading5),
        backgroundColor: AppColors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.filteredItems.isEmpty && controller.searchQuery.value.isEmpty) return const Center(child: Text('No data available'));
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextField(
                hint: 'Search',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                onChanged: controller.onSearch,
              ),
            ),
            Expanded(
              child: controller.filteredItems.isEmpty
                  ? const Center(child: Text('No results found'))
                  : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.filteredItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.filteredItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (item['name']?.toString() ?? 'Unknown User').unescapeHtml,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (item['email']?.toString() ?? '-').unescapeHtml,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Role: ${item['activeRole'] ?? 'None'}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (item['isActive'] == true) 
                            ? Colors.green.withValues(alpha: 0.1) 
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (item['isActive'] == true) ? 'Active' : 'Inactive',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: (item['isActive'] == true) ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
            ),
            ),
          ],
        );
      }),
    );
  }
}
