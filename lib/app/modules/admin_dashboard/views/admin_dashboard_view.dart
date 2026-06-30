import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'tabs/admin_monitoring_tab.dart';
import 'tabs/admin_discount_tab.dart';
import 'tabs/admin_simulator_tab.dart';
import 'tabs/admin_settings_tab.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      body: SafeArea(
        child: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return const AdminMonitoringTab();
            case 1:
              return const AdminDiscountTab();
            case 2:
              return const AdminSimulatorTab();
            case 3:
              return const AdminSettingsTab();
            default:
              return const AdminMonitoringTab();
          }
        }),
      ),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              label: 'Discounts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Simulator',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      }),
    );
  }
}
