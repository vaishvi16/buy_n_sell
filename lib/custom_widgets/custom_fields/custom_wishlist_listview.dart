import 'package:flutter/material.dart';
import '../../model_class/product_model.dart';
import '../../screens/product_section/product_detail_screen.dart';
import '../my_colors/my_colors.dart';

class CustomWishlistListView extends StatelessWidget {
  final List<ProductModel> products;

  const CustomWishlistListView({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    final imageSize = screenWidth * 0.28;
    final titleSize = screenWidth * 0.04;
    final descSize = screenWidth * 0.035;
    final priceSize = screenWidth * 0.035;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.03,
        screenWidth * 0.03,
        screenWidth * 0.03,
        screenWidth * 0.15 + MediaQuery.of(context).viewPadding.bottom,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetailScreen(id: product.id),));
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: screenWidth * 0.035),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.035),
            ),
            color: MyColors.whiteColor,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.025),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(screenWidth * 0.025),
                      child: Image.network(
                        product.image ?? "",
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: imageSize,
                          width: imageSize,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  ),

                SizedBox(width: screenWidth * 0.03),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.01),

                      Text(
                        product.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: descSize,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.015),

                      Text(
                        "Rs. ${product.price}",
                        style: TextStyle(
                          fontSize: priceSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.015),

                      Row(
                        children: [
                          _chip("Pink", screenWidth),
                          SizedBox(width: screenWidth * 0.015),
                          _chip("M", screenWidth),
                           Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.shopping_bag,
                              size: screenWidth * 0.05,
                              color: MyColors.greyColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),)
        );
      },
    );
  }

  Widget _chip(String text, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.025,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: MyColors.whiteLightColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.015),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: screenWidth * 0.03),
      ),
    );
  }
}
