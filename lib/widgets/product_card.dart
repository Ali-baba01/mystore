import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../utils/app_theme.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isFeatured;

  const ProductCard({
    super.key,
    required this.product,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailsScreen(product: product));
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),
        if (product.hasDiscount)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.errorColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${product.discountPercentage.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: GetBuilder<ProductController>(
            builder: (productController) {
              return GestureDetector(
                onTap: () {
                  productController.toggleFavorite(product.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: product.isFavorite ? AppTheme.errorColor : Colors.grey,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 4),
              Text(
                product.rating.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewCount})',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (product.hasDiscount) ...[
                Text(
                  '\$${product.originalPrice?.toStringAsFixed(2) ?? ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GetBuilder<CartController>(
            builder: (cartController) {
              final isInCart = cartController.isInCart(product.id);
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isInCart) {
                      cartController.removeItem(product.id);
                    } else {
                      cartController.addItem(product);
                      Get.snackbar(
                        'Success',
                        '${product.name} added to cart',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.successColor,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.grey : AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isInCart ? 'Remove' : 'Add to Cart',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 