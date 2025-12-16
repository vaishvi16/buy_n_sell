import 'package:flutter/material.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../category_section/category_api.dart';

class CategorySearches extends StatefulWidget {
  final String searchQuery;

  const CategorySearches({super.key, this.searchQuery = " "});

  @override
  State<CategorySearches> createState() => _CategorySearchesState();
}

class _CategorySearchesState extends State<CategorySearches> {
  final CategoryApi categoryApi = CategoryApi();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await categoryApi.loadCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (categoryApi.categories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // Filter categories based on searchQuery
    final filteredCategories = categoryApi.categories.where((category) {
      final name = category.name?.toLowerCase() ?? "";
      final query = widget.searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.isEmpty
          ? categoryApi.categories.length
          : filteredCategories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: screenWidth * 0.01,
        mainAxisSpacing: screenHeight * 0.015,
      ),
      itemBuilder: (context, index) {
        final category = filteredCategories.isEmpty
            ? categoryApi.categories[index]
            : filteredCategories[index];

        return Column(
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
        );
      },
    );
  }
}
