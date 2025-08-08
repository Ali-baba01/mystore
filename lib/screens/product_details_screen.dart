import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/app_theme.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailsScreen({
    super.key,
    this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Get product from arguments if not passed directly
    final args = Get.arguments as ProductModel?;
    final product = widget.product ?? args;
    if (product != null) {
      isFavorite = product.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get product from arguments if not passed directly
    final args = Get.arguments as ProductModel?;
    final product = widget.product ?? args;
    
    print('ProductDetailsScreen build called');
    print('Widget product: ${widget.product?.name}');
    print('Arguments product: ${args?.name}');
    print('Final product: ${product?.name}');

    if (product == null) {
      print('Product is null, showing error screen');
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Product Details',
            style: TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        body: const Center(
          child: Text('Product not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fixed Header Section with Title and Back Button - Always on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              color: Colors.white,
              child: Stack(
                children: [
                  // Product Details Title
                  Positioned(
                    top: 36,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 32,
                      child: const Center(
                        child: Text(
                          'Product Details',
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

                  // Back Button
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Scrollable Content - Below the header
          Positioned(
            top: 78,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                width: 360,
                child: Column(
                  children: [
                    // Main Product Image
                    Container(
                      // margin: const EdgeInsets.only(top: 16),
                      width: 360,
                      height: 209,
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Product Info Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Details Section Header with Favorite Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Product Details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  color: Color(0xFF0C0C0C),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                  // Update product favorite status
                                  final controller = Get.find<ProductController>();
                                  controller.toggleFavorite(product.id);
                                },
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  size: 24,
                                  color: isFavorite ? const Color(0xFFD92121) : Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Product Name
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Category
                          Text(
                            'Category: ${product.category}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Rating Stars with Rating Number
                          Row(
                            children: [
                              // Rating Number
                              Text(
                                '${product.rating}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF0C0C0C),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Rating Stars
                              ...List.generate(5, (index) {
                                if (index < product.rating.floor()) {
                                  return const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Color(0xFFFFC553),
                                  );
                                } else if (index == product.rating.floor() && 
                                         product.rating % 1 > 0) {
                                  return const Icon(
                                    Icons.star_half,
                                    size: 16,
                                    color: Color(0xFFFFC553),
                                  );
                                } else {
                                  return const Icon(
                                    Icons.star_border,
                                    size: 16,
                                    color: Colors.grey,
                                  );
                                }
                              }),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Stock
                          Text(
                            'Stock: ${product.reviewCount}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description Label
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Description Content
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              height: 1.4,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Additional Product Images Section
                          const Text(
                            'Product Images',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Color(0xFF0C0C0C),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Additional Product Images Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 154 / 109,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.images.isNotEmpty ? product.images[0] : product.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                  errorWidget: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.images.length > 1 ? product.images[1] : product.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                  errorWidget: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.images.length > 2 ? product.images[2] : product.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                  errorWidget: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: product.images.length > 3 ? product.images[3] : product.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                  errorWidget: (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 