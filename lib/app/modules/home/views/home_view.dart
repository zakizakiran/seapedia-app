import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/home_controller.dart';
import 'home_tab.dart';
import 'search_tab.dart';
import 'favorites_tab.dart';
import '../../profile/views/profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.selectedBottomNavIndex.value) {
          case 0:
            return const HomeTab();
          case 1:
            return const SearchTab();
          case 2:
            return const FavoritesTab();
          case 3:
            // Embed ProfileView, but we can pass a parameter to hide the back button if we want,
            // or just wrap it in a Navigator if needed. Since ProfileView uses Get.back() on its leading icon,
            // we should ideally create a customized ProfileTab or hide the leading icon if inside a tab.
            // For now, we render ProfileView. 
            return const ProfileView();
          default:
            return const SizedBox.shrink();
        }
      }),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            currentIndex: controller.selectedBottomNavIndex.value,
            onTap: controller.changeBottomNavIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          )),
    );
  }
}
