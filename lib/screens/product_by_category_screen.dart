import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class ProductByCategoryScreen extends StatefulWidget {
  final String categoryName;
  final String categorySlug;

  const ProductByCategoryScreen({
    super.key,
    required this.categoryName,
    required this.categorySlug,
  });

  @override
  State<ProductByCategoryScreen> createState() => _ProductByCategoryScreenState();
}

class _ProductByCategoryScreenState extends State<ProductByCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ProductController>();
      final args = Get.arguments as Map<String, dynamic>?;
      final finalCategoryName = widget.categoryName.isNotEmpty ? widget.categoryName : (args?['categoryName'] ?? 'Category');
      final finalCategorySlug = widget.categorySlug.isNotEmpty ? widget.categorySlug : (args?['categorySlug'] ?? '');
      
      controller.setSelectedCategory(finalCategoryName);
      controller.loadProductsByCategory(finalCategorySlug);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('ProductByCategoryScreen build called');
    print('Category name: ${widget.categoryName}, slug: ${widget.categorySlug}');
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 360,
        height: 800,
        child: Stack(
          children: [
            // Category Title
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 32,
                child: Center(
                  child: Text(
                    widget.categoryName,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
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
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ),
            
            // Products List
            Positioned(
              top: 136,
              left: 21,
              child: Container(
                width: 318,
                height: 600,
                child: _buildProductsContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsContent() {
    // Ensure ProductController is initialized
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController());
    }

    // Get arguments if not passed directly
    final args = Get.arguments as Map<String, dynamic>?;
    final finalCategoryName = widget.categoryName.isNotEmpty ? widget.categoryName : (args?['categoryName'] ?? 'Category');
    final finalCategorySlug = widget.categorySlug.isNotEmpty ? widget.categorySlug : (args?['categorySlug'] ?? '');

    return GetBuilder<ProductController>(
      builder: (controller) {
        print('=== ProductByCategoryScreen Debug ===');
        print('Category Name: $finalCategoryName');
        print('Category Slug: $finalCategorySlug');
        print('Selected Category: ${controller.selectedCategory.value}');
        print('Products Count: ${controller.products.length}');
        print('Is Loading: ${controller.isLoading.value}');
        


        // Check if we need to load products for this category
        if (controller.selectedCategory.value != finalCategoryName || controller.products.isEmpty) {
          print('Loading products for category: $finalCategoryName ($finalCategorySlug)');
          
          // Load products in the background
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setSelectedCategory(finalCategoryName);
            controller.loadProductsByCategory(finalCategorySlug);
          });
          
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading products...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final products = controller.products;
        final filteredProducts = _getFilteredProducts(products);
        print('Final products count: ${products.length}');
        print('Filtered products count: ${filteredProducts.length}');

        // If no products at all, show message
        if (products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No products found in this category',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (filteredProducts.isEmpty && _searchQuery.isNotEmpty) {
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
                  'No products found',
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

        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            print('Building product ${index + 1}: ${product.name}');
            return _buildProductCard(product, controller);
          },
        );
      },
    );
  }

  List<ProductModel> _getFilteredProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }
    
    final query = _searchQuery.toLowerCase();
    return products.where((product) {
      return product.name.toLowerCase().contains(query) ||
             product.description.toLowerCase().contains(query) ||
             product.category.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildProductCard(ProductModel product, ProductController controller) {
    return Container(
      width: 318,
      height: 286,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide.none,
          right: BorderSide(color: const Color(0x0D0C0C0C), width: 1),
          bottom: BorderSide(color: const Color(0x0D0C0C0C), width: 1),
          left: BorderSide(color: const Color(0x0D0C0C0C), width: 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to ProductDetailsScreen
            print('Navigating to product details for: ${product.name}');
            print('Product data: ${product.toJson()}');
            Get.toNamed('/product-details', arguments: product);
          },
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          child: Column(
            children: [
              // Product Image
              Container(
                width: 288,
                height: 172.77,
                margin: const EdgeInsets.only(top: 0, left: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
          
              // Product Info Container
              Container(
                width: 290.06,
                height: 80.43,
                margin: const EdgeInsets.only(top: 15, left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name and Price Row
                    Row(
                      children: [
                        // Product Name - Expanded to show full name
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Rating and Stars Row
                    Row(
                      children: [
                        // Rating Number
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Color(0xFF0C0C0C),
                          ),
                        ),
                        
                        const SizedBox(width: 3),
                        
                        // Rating Stars
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              if (index < product.rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  size: 10,
                                  color: Color(0xFFFFC553),
                                );
                              } else if (index == product.rating.floor() && 
                                       product.rating % 1 > 0) {
                                return const Icon(
                                  Icons.star_half,
                                  size: 10,
                                  color: Color(0xFFFFC553),
                                );
                              } else {
                                return const Icon(
                                  Icons.star_border,
                                  size: 10,
                                  color: Colors.grey,
                                );
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Additional text below rating
                    Text(
                      '${product.reviewCount} reviews',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 