import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';

import '../../screens/product_section/all_product_as_category.dart';

class CustomCategoryGridview extends StatelessWidget {
  final List categories;
  final int itemCount; // pass 4 or categories.length

  const CustomCategoryGridview({
    super.key,
    required this.categories,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenHeight * 0.02,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final images = category.images ?? [];

        final visibleImages = images.length > 4 ? images.sublist(0, 4) : images;

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllProductAsCategory(categoryId: category.id),));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: MyColors.whiteLightColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 3),
                Container(
                  height: screenWidth * 0.5,
                  decoration: BoxDecoration(
                    color: MyColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: visibleImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, imgIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            visibleImages[imgIndex],
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 8),
                      child: Text(
                        category.name ?? "",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0, top: 8),
                      child: Text(
                        "${category.images?.length ?? 0} Items",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
