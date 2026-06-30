import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/favorites_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => FavoritesService().init());

  runApp(
    GetMaterialApp(
      title: "SEAPEDIA",
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
