import 'package:buy_n_sell/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/custom_product_gridview.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../product_section/product_detail_screen.dart';

class ProductSearches extends StatelessWidget {
  final String searchQuery;
  final bool isSubmitted;

  const ProductSearches({super.key, this.searchQuery = " ",  required this.isSubmitted});

  @override
  Widget build(BuildContext context) {
    return  Consumer<ProductProvider>(
      builder: (BuildContext context, provider, Widget? child) {

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final filteredProducts = provider.allProducts.where((product) {
          final name = product.name?.toLowerCase() ?? "";
          final query = searchQuery.toLowerCase();
          return name.contains(query);
        }).toList();

        // SHOW MESSAGE ONLY AFTER SUBMIT
        if (isSubmitted && filteredProducts.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "No products found",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.greyColor,
              ),
            ),
          );
        }

        return CustomProductGridview(
          products: filteredProducts.isEmpty
              ? provider.allProducts
              : filteredProducts,
        );
      },
    );
  }
}
