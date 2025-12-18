import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:buy_n_sell/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_api.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<CategoryProvider>(builder: (context, provider, child) {
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
                  Expanded(child: Text("Categories",style: TextStyle(color: MyColors.blackColor,fontSize: 20,fontWeight: FontWeight.w600),)),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      spacing: 10,
                      children: [
                        Text("See All",style: TextStyle(color: MyColors.blackDarkColor,fontSize: 15),),
                        CircleAvatar(
                            radius: 13,
                            backgroundColor: MyColors.primaryColor,
                            child: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: MyColors.whiteLightColor,)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: provider.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenHeight * 0.02,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  final images = category.images ?? [];

                  // Only show max 4 images
                  final visibleImages = images.length > 4
                      ? images.sublist(0, 4)
                      : images;

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColors.whiteLightColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    //  padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(color: MyColors.whiteColor),
                          height: screenWidth * 0.5,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: visibleImages.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, imgIndex) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  visibleImages[imgIndex],
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 3),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, top: 8),
                              child: Text(
                                category.name ?? "",
                                textAlign: TextAlign.center,
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
                  );
                },
              ),
            ),
          ],
        ),
      );

    },);
  }
}

