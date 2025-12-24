import 'package:buy_n_sell/custom_widgets/custom_fields/custom_category_gridview.dart';
import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:buy_n_sell/screens/product_section/all_product_as_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';

class AllCategorySection extends StatelessWidget {
  const AllCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        if (provider.categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        return Scaffold(
          appBar: primaryAppBar(
            title: "Categories",
            subtitle: "Browse all available categories",
          ),

          body: Column(
            children: [
              Expanded(
                child: CustomCategoryGridview(
                  categories: provider.categories,
                  itemCount: provider.categories.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
