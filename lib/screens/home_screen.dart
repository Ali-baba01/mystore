import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../utils/app_theme.dart';
import '../models/product_model.dart';
import 'categories_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const ProductScreen(),      // Index 0 - Products
    const CategoriesScreen(),   // Index 1 - Categories  
    const FavoritesScreen(),    // Index 2 - Favourites
    const ProfileScreen(),      // Index 3 - Mitt konto
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        width: 360,
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFF0C0C0C), // Black background for bottom bar
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            
            // If Products tab is selected, load all products
            if (index == 0) {
              final controller = Get.find<ProductController>();
              controller.setSelectedCategory('All');
              controller.loadProducts();
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0C0C0C),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.white,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 10,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.white,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 21, color: Colors.white),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category, size: 21, color: Colors.white),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 21, color: Colors.white),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 21, color: Colors.white),
              label: 'Mitt Konto',
            ),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load all products immediately when ProductScreen is initialized
    final controller = Get.find<ProductController>();
    if (controller.products.isEmpty) {
      print('Products empty, loading products...');
      controller.setSelectedCategory('All');
      controller.loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        // Ensure controller is properly initialized
        if (!Get.isRegistered<ProductController>()) {
          Get.put(ProductController());
        }

        // Load products if empty
        if (productController.products.isEmpty) {
          print('No products found, loading products...');
          productController.setSelectedCategory('All');
          productController.loadProducts();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: 360,
            height: 800,
            child: Stack(
              children: [
                // Products Title
                Positioned(
                  top: 36,
                  left: 131,
                  child: Container(
                    width: 120,
                    height: 32,
                    child: const Center(
                      child: Text(
                        'Products',
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
                      // style: const TextStyle(
                      //   color: Colors.white,
                      //   fontSize: 14,
                      // //  height: 1.2,
                      //   fontWeight: FontWeight.w400,
                      // ),
                      onChanged: (value) {
                        print('Search text changed: "$value"');
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
                
                // Products List
                Positioned(
                  top: 149,
                  left: 21,
                  child: Container(
                    width: 318,
                    height: 600,
                    child: _buildProductsList(productController.products),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsList(List<ProductModel> products) {
    print('=== Search Debug ===');
    print('Total products: ${products.length}');
    print('Search query: "$_searchQuery"');
    
    // If no products, show empty state instead of loading
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
              'No products available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    final filteredProducts = _getFilteredProducts(products);
    print('Filtered products: ${filteredProducts.length}');
    
    if (filteredProducts.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found for "$_searchQuery"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
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

    return Column(
      children: [
        // Search results header - moved closer to search bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Found ${filteredProducts.length} products for "$_searchQuery"',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
        // Products list
        Expanded(
          child: ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details screen
        Get.toNamed('/product-details', arguments: product);
      },
      child: Container(
        width: 329.8038330078125,
        height: 184.33486938476562 + 90, // Image height + info height
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            // Product Image
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 329.8038330078125,
                height: 184.33486938476562,
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
            ),
            
            // Product Info Container
            Positioned(
              top: 184.33486938476562, // Below the image
              left: 0,
              child: Container(
                width: 306.0625,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Price Row
                    Container(
                      width: 290.0625,
                      height: 45,
                      margin: const EdgeInsets.only(left: 16, top: 8),
                      child: Row(
                        children: [
                          // Product Name (left side) - Expanded to show full name
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Price (right side)
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Rating Row
                    Container(
                      width: 290.0625,
                      margin: const EdgeInsets.only(left: 16, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Rating Number
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              
                              const SizedBox(width: 4),
                              
                              // Rating Stars
                              Row(
                                children: [
                                  ...List.generate(5, (index) {
                                    if (index < product.rating.floor()) {
                                      return const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Color(0xFFFFC553),
                                      );
                                    } else if (index == product.rating.floor() && 
                                             product.rating % 1 > 0) {
                                      return const Icon(
                                        Icons.star_half,
                                        size: 12,
                                        color: Color(0xFFFFC553),
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.star_border,
                                        size: 12,
                                        color: Colors.grey,
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 2),
                          
                          // Additional text below rating
                          Text(
                            '${product.reviewCount} reviews',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
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
          ],
        ),
      ),
    );
  }

  List<ProductModel> _getFilteredProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }
    
    final query = _searchQuery.toLowerCase().trim();
    print('Searching for: "$query"');
    print('Total products to search: ${products.length}');
    
    final filtered = products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(query);
      final descMatch = product.description.toLowerCase().contains(query);
      final categoryMatch = product.category.toLowerCase().contains(query);
      
      return nameMatch || descMatch || categoryMatch;
    }).toList();
    
    print('Found ${filtered.length} matching products');
    return filtered;
  }
} 