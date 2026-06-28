import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/seller_dashboard_controller.dart';
import 'my_products_tab.dart';
import 'store_profile_tab.dart';

class SellerDashboardView extends GetView<SellerDashboardController> {
  const SellerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text('Seller Dashboard', style: AppTextStyles.heading3),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: controller.logout,
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return const StoreProfileTab();
          case 1:
            return const MyProductsTab();
          case 2:
            return Center(child: Text('Incoming Orders\n(Level 3/4)', textAlign: TextAlign.center, style: AppTextStyles.heading3));
          default:
            return const SizedBox.shrink();
        }
      }),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
          ],
        );
      }),
    );
  }
}
