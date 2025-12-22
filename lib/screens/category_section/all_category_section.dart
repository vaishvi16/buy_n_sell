import 'package:buy_n_sell/custom_widgets/custom_fields/custom_category_gridview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
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
          appBar: AppBar(
            elevation: 2,
            backgroundColor: MyColors.primaryColor,
            leading: IconButton(
              icon:  Icon(Icons.arrow_back_ios, size: 22,),
              color: MyColors.blackColor,
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    color: MyColors.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Browse all available categories",
                  style: TextStyle(
                    color: MyColors.whiteLightColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
