import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/driver_dashboard_controller.dart';
import 'driver_history_tab.dart';
import 'driver_home_tab.dart';
import 'driver_jobs_tab.dart';
import 'driver_settings_tab.dart';

class DriverDashboardView extends GetView<DriverDashboardController> {
  const DriverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return const Text('Driver Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
            case 1:
              return const Text('Available Jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
            case 2:
              return const Text('Job History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
            case 3:
              return const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
            default:
              return const Text('');
          }
        }),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return const DriverHomeTab();
            case 1:
              return const DriverJobsTab();
            case 2:
              return const DriverHistoryTab();
            case 3:
              return const DriverSettingsTab();
            default:
              return const SizedBox.shrink();
          }
        }),
      ),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        );
      }),
    );
  }
}
