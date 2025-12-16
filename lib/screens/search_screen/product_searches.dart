import 'package:buy_n_sell/screens/product_section/product_api.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../product_section/product_detail_screen.dart';

class ProductSearches extends StatefulWidget {
  final String searchQuery;
  final bool isSubmitted;

  const ProductSearches({super.key, this.searchQuery = " ",  required this.isSubmitted});

  @override
  State<ProductSearches> createState() => _ProductSearchesState();
}

class _ProductSearchesState extends State<ProductSearches> {
  final ProductApi productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await productApi.loadProducts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final filteredProducts = productApi.products.where((product) {
      final name = product.name?.toLowerCase() ?? "";
      final query = widget.searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    // SHOW MESSAGE ONLY AFTER SUBMIT
    if (widget.isSubmitted && filteredProducts.isEmpty) {
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

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10),
      itemCount: filteredProducts.isEmpty
          ? productApi.products.length
          : filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenHeight * 0.02,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = filteredProducts.isEmpty
            ? productApi.products[index]
            : filteredProducts[index];

        return GestureDetector(
          onTap: () {
            print("product.id! ${product.id!}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(id: product.id!),
              ),
            );
          },
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(color: MyColors.whiteColor),
                  height: screenWidth * 0.45,
                  width: screenWidth * double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image ?? "No Image found",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8),
                  child: Text(
                    product.name ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 8),
                  child: Text(
                    "Rs. ${product.price}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
