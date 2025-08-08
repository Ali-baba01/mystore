import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import 'product_by_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 360,
        height: 800,
        child: Stack(
          children: [
            // Categories Title
            Positioned(
              top: 36,
              left: 131,
              child: Container(
                width: 120,
                height: 32,
                child: const Center(
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            
            // Search Bar
            Positioned(
              top: 78,
              left: 21,
              child: Container(
                width: 318,
                height: 33,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C0C0C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                ),
              ),
            ),
            
            // Categories Grid (2 categories per row)
            Positioned(
              top: 142.78,
              left: 26.14,
              child: Container(
                width: 306.28, // 147.71 + 147.71 + 11.86 (spacing)
                height: 600,
                child: _buildCategoriesContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesContent() {
    // Ensure ProductController is initialized
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController());
    }

    return Obx(() {
      final controller = Get.find<ProductController>();
      
      // Load categories if empty
      if (controller.categories.isEmpty) {
        controller.loadCategories();
      }

      // Show empty state if still no categories
      if (controller.categories.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No categories available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      // Filter categories based on search query
      final filteredCategories = _getFilteredCategories(controller.categories);
      
      if (filteredCategories.isEmpty && _searchQuery.isNotEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No categories found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try a different search term',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 147.71 / 146.38,
          crossAxisSpacing: 11.86, // 184.57 - 26.14 - 147.71 = 11.86
          mainAxisSpacing: 20,
        ),
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          final categoryName = category['name'] as String;
          final categorySlug = category['slug'] as String;
          
          return _buildCategoryCard(categoryName, categorySlug, controller);
        },
      );
    });
  }

  Widget _buildCategoryCard(String categoryName, String categorySlug, ProductController controller) {
    return Container(
      width: 147.71,
      height: 146.38,
      decoration: BoxDecoration(
        color: const Color(0x400C0C0C), // #0C0C0C40
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print('Category tapped: $categoryName, slug: $categorySlug');
            controller.setSelectedCategory(categoryName);
            // Navigate to ProductByCategoryScreen
            Get.toNamed('/product-by-category', arguments: {
              'categoryName': categoryName,
              'categorySlug': categorySlug,
            });
            print('Navigation attempted to /product-by-category');
          },
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              // Category Image - Full rectangle
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 147.71,
                  height: 146.38,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: _getCategoryImageUrl(categoryName),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          _getCategoryIcon(categoryName),
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          _getCategoryIcon(categoryName),
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Category Name - At bottom of image
              Positioned(
                bottom: 16,
                left: 8,
                child: Text(
                  categoryName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.0,
                    letterSpacing: 0,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryImageUrl(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'smartphones':
        return 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400';
      case 'laptops':
        return 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400';
      case 'fragrances':
        return 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=400';
      case 'skincare':
        return 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400';
      case 'groceries':
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400';
      case 'home-decoration':
        return 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400';
      case 'furniture':
        return 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400';
      case 'tops':
        return 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400';
      case 'womens-dresses':
        return 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400';
      case 'womens-shoes':
        return 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400';
      case 'mens-shirts':
        return 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400';
      case 'mens-shoes':
        return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400';
      case 'mens-watches':
        return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400';
      case 'womens-watches':
        return 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=400';
      case 'womens-bags':
        return 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400';
      case 'womens-jewellery':
        return 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400';
      case 'sunglasses':
        return 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400';
      case 'automotive':
        return 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400';
      case 'motorcycle':
        return 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400';
      case 'lighting':
        return 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400';
      default:
        return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400';
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'smartphones':
      case 'laptops':
      case 'tablets':
        return Icons.devices;
      case 'fragrances':
      case 'skincare':
      case 'beauty':
        return Icons.face;
      case 'groceries':
        return Icons.shopping_basket;
      case 'home-decoration':
      case 'furniture':
        return Icons.home;
      case 'mens-shirts':
      case 'mens-shoes':
      case 'mens-watches':
      case 'womens-dresses':
      case 'womens-shoes':
      case 'womens-watches':
      case 'womens-bags':
      case 'womens-jewellery':
        return Icons.checkroom;
      case 'sunglasses':
        return Icons.visibility;
      case 'automotive':
      case 'motorcycle':
        return Icons.directions_car;
      case 'lighting':
        return Icons.lightbulb;
      default:
        return Icons.category;
    }
  }

  List<Map<String, dynamic>> _getFilteredCategories(List<Map<String, dynamic>> categories) {
    if (_searchQuery.isEmpty) {
      return categories;
    }
    
    final query = _searchQuery.toLowerCase();
    return categories.where((category) {
      final name = category['name'] as String? ?? '';
      return name.toLowerCase().contains(query);
    }).toList();
  }
} 