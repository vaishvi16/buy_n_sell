import 'package:buy_n_sell/custom_widgets/custom_fields/custom_category_gridview.dart';
import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:buy_n_sell/providers/category_provider.dart';
import 'package:buy_n_sell/screens/category_section/all_category_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

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

        return SafeArea(
          bottom: true,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          color: MyColors.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllCategorySection(),
                          ),
                        );
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Text(
                            "See All",
                            style: TextStyle(
                              color: MyColors.blackDarkColor,
                              fontSize: 15,
                            ),
                          ),
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: MyColors.primaryColor,
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                              color: MyColors.whiteLightColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomCategoryGridview(
                  categories: provider.categories,
                  itemCount: 4,
                ), // used custom grid view and here's code was pasted there to reuse it
              ),
            ],
          ),
        );
      },
    );
  }
}
