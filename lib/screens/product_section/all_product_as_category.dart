import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:buy_n_sell/providers/category_product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/custom_product_gridview.dart';
import '../../providers/product_provider.dart';

class AllProductAsCategory extends StatefulWidget {
  final String? categoryId;

  const AllProductAsCategory({super.key, required this.categoryId});

  @override
  State<AllProductAsCategory> createState() => _AllProductAsCategoryState();
}

class _AllProductAsCategoryState extends State<AllProductAsCategory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProductProvider>(context, listen: false).fetchProductByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(
        title: "Products",
        subtitle: "Browse all available products",
      ),
      body: Consumer<CategoryProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return CustomProductGridview(products: provider.products);
        },
      ),
    );
  }
}
