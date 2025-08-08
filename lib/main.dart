import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_by_category_screen.dart';
import 'screens/product_details_screen.dart'; // New import
import 'utils/app_theme.dart';
import 'utils/app_constants.dart';
import 'models/product_model.dart'; // Added import for ProductModel

void main() {
  runApp(const MyStoreApp());
}

class MyStoreApp extends StatelessWidget {
  const MyStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppConstants.splashRoute,
      getPages: [
        GetPage(
          name: AppConstants.splashRoute,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: AppConstants.homeRoute,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: '/product-by-category',
          page: () => ProductByCategoryScreen(
            categoryName: Get.arguments['categoryName'] ?? '',
            categorySlug: Get.arguments['categorySlug'] ?? '',
          ),
        ),
        GetPage( // New route
          name: '/product-details',
          page: () => ProductDetailsScreen(
            product: Get.arguments as ProductModel?,
          ),
        ),
      ],
    );
  }
}
