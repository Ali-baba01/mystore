import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../utils/app_constants.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textController.forward();
  }

  void _loadData() async {
    try {
      // Load required controllers
      Get.put(ProductController());
      Get.put(CartController());

      final productController = Get.find<ProductController>();
      await Future.wait([
        productController.loadProducts(),
        productController.loadCategories(),
      ]);

      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppConstants.homeRoute);
    } catch (e) {
      print("Error loading splash screen: $e");
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppConstants.homeRoute);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          Positioned(
            top: 22, // Moved down by 50px
            left: -150, // Moved left by 30px
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 App Title "My Store" - positioned exactly as per Figma
          Positioned(
            top: 40, // Moved up by 20px
            left: 79,
            child: AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - _textAnimation.value)),
                    child: Text(
                      'My Store',
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.w400,
                        fontSize: 50,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          //bbottum
          Positioned(
            top: 480,
            left: 38,
            child: AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _textAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, 5 * (1 - _textAnimation.value)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // "Valkommen" text - exact positioning
                        Container(
                          width: 88,
                          height: 21,
                          child: Text(
                            'Valkommen',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Description text - exact positioning
                        Container(
                          width: 284,
                          height: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Hos ass kan du baka tid has nastan alla Sveriges salonger och motagningar. Baka frisor, massage, skonhetsbehandingar, friskvard och mycket mer.',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
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
      ),
    );
  }
}

