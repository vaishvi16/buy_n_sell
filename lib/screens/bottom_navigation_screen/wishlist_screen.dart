import 'package:buy_n_sell/screens/product_section/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/custom_wishlist_listview.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: MyColors.whiteLightColor,
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: MyColors.whiteColor,
        elevation: 0,
        foregroundColor: MyColors.blackColor,
      ),
      body: Consumer2<WishlistProvider, ProductProvider>(
        builder: (context, wishlistProvider, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final wishlistProducts = productProvider.allProducts
              .where(
                (product) => wishlistProvider.wishlistIds.contains(product.id),
              )
              .toList();

          if (wishlistProducts.isEmpty) {
            return const Center(child: Text("Your wishlist is empty"));
          }

          return CustomWishlistListView(products: wishlistProducts);
        },
      ),
    );
  }
}
