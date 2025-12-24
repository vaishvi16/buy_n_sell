import 'package:buy_n_sell/providers/category_provider.dart';
import 'package:buy_n_sell/screens/product_section/all_product_as_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';

class CategorySearches extends StatelessWidget {
  final String searchQuery;

  const CategorySearches({super.key, this.searchQuery = ""});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return Consumer<CategoryProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        if (provider.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        // Filter categories
        final filteredCategories = provider.categories.where((category) {
          final name = category.name?.toLowerCase() ?? "";
          final query = searchQuery.toLowerCase();
          return name.contains(query);
        }).toList();

        final displayList = filteredCategories.isEmpty
            ? provider.categories
            : filteredCategories;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: displayList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: screenWidth * 0.01,
            mainAxisSpacing: screenHeight * 0.015,
          ),
          itemBuilder: (context, index) {
            final category = displayList[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllProductAsCategory(categoryId: category.id,),));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.07,
                    backgroundImage:
                    category.images != null && category.images!.isNotEmpty
                        ? NetworkImage(category.images!.last)
                        : null,
                    child: category.images == null || category.images!.isEmpty
                        ? Text(
                      category.name!.substring(0, 1).toUpperCase(),
                      style: TextStyle(color: MyColors.primaryColor),
                    )
                        : null,
                  ),

                  SizedBox(height: 6),

                  Flexible(
                    child: Text(
                      category.name ?? "",
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
