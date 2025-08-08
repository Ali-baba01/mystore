import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../utils/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
            // Favorites Title
            Positioned(
              top: 36,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 32,
                child: const Center(
                  child: Text(
                    'Favorites',
                    style: TextStyle(
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    print('Favorites search text changed: "$value"');
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search favorites...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
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
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ),
            

            
            // Favorites List
            Positioned(
              top: 151,
              left: 14,
              child: Container(
                width: 318,
                height: 549,
                child: _buildFavoritesContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return GetBuilder<ProductController>(
      builder: (productController) {
        // Ensure controller is properly initialized
        if (!Get.isRegistered<ProductController>()) {
          Get.put(ProductController());
        }

        final favorites = productController.favorites;
        final filteredFavorites = _getFilteredFavorites(favorites);

        if (favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add products to your favorites to see them here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (filteredFavorites.isEmpty && _searchQuery.isNotEmpty) {
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
                  'No favorites found',
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
          itemCount: filteredFavorites.length,
          itemBuilder: (context, index) {
            final product = filteredFavorites[index];
            return _buildFavoriteItem(product, productController);
          },
        );
      },
    );
  }

  List<ProductModel> _getFilteredFavorites(List<ProductModel> favorites) {
    if (_searchQuery.isEmpty) {
      return favorites;
    }
    
    final query = _searchQuery.toLowerCase();
    return favorites.where((product) {
      return product.name.toLowerCase().contains(query) ||
             product.description.toLowerCase().contains(query) ||
             product.category.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildFavoriteItem(ProductModel product, ProductController controller) {
    return Container(
      width: 318,
      height: 88,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0x0D0C0C0C),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to ProductDetailsScreen
            Get.toNamed('/product-details', arguments: product);
          },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Product Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 2),
                        
                        // Price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 2),
                        
                        // Rating and Stars
                        Row(
                          children: [
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF0C0C0C),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < product.rating.floor() 
                                      ? Icons.star 
                                      : Icons.star_border,
                                  size: 12,
                                  color: index < product.rating.floor() 
                                      ? Colors.amber 
                                      : Colors.grey,
                                );
                              }),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 1),
                        
                        // Review Count
                        Text(
                          '${product.reviewCount} reviews',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Remove from Favorites Button
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Remove from favorites immediately
                      Get.find<ProductController>().toggleFavorite(product.id);
                      
                      // Show success message
                      Get.snackbar(
                        'Removed from Favorites',
                        '${product.name} has been removed from your favorites',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFD92121),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD92121),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 