import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../helper_class/auction_helper/auction_helper.dart';
import '../../model_class/product_model.dart';
import '../../providers/auction_provider.dart';
import '../../providers/product_provider.dart';

class AuctionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const AuctionDetailScreen({super.key, required this.product});

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => _createAuctionHelper(context.read<AuctionProvider>()),
        ),
        ChangeNotifierProvider.value(value: context.read<ProductProvider>()),
      ],
      child: Consumer2<AuctionHelper, ProductProvider>(
        builder: (context, helper, productProvider, _) {
          return Scaffold(
            appBar: AppBar(title: Text("Auction Details")),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Image.network(
                    product["image"],
                    height: screenWidth * 0.7,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Auction Content
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product["name"],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              helper.auctionEnded
                                  ? "Auction Ended"
                                  : "Auction Running",
                            ),
                          ],
                        ),

                        SizedBox(height: screenWidth * 0.03),

                        // Highest Bid
                        Text(
                          helper.auctionEnded
                              ? "Highest Bid"
                              : "Current Highest Bid",
                        ),
                        SizedBox(height: screenWidth * 0.015),
                        Text(
                         "\$${helper.highestBid}",
                          style: TextStyle(
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: MyColors.greenColor,
                          ),
                        ),

                        SizedBox(height: screenWidth * 0.04),

                        // Timer
                        Center(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: helper.isLast10Seconds
                                  ? MyColors.redColor.withOpacity(0.2)
                                  : MyColors.transparentColor,
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                              boxShadow: helper.isLast10Seconds
                                  ? [
                                      BoxShadow(
                                        color: MyColors.redColor.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              helper.auctionEnded
                                  ? "⏱ Auction Ended"
                                  : "⏱ Auction ends in ${formatTime(helper.remainingSeconds)}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.050,
                                fontWeight: FontWeight.bold,
                                color: helper.isLast10Seconds
                                    ? MyColors.redColor
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenWidth * 0.02),

                        // Place Bid Button
                        SizedBox(
                          width: double.infinity,
                          height: screenWidth * 0.13,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.025,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.045,
                                vertical: screenWidth * 0.012,
                              ),
                            ),
                            onPressed: helper.auctionEnded ? null : () {},
                            child: Text("Place Bid"),
                          ),
                        ),

                        SizedBox(height: screenWidth * 0.04),

                        // Product Details Section
                        _buildProductDetails(
                          productProvider,
                          screenWidth,
                          product["id"],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AuctionHelper _createAuctionHelper(AuctionProvider provider) {
    final helper = AuctionHelper(
      provider: provider,
      productId: product["id"].toString(),
    );
    helper.initAuction();
    return helper;
  }

  Widget _buildProductDetails(
    ProductProvider provider,
    double screenWidth,
    String productId,
  ) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    final productList = provider.allProducts
        .where((p) => p.id == productId)
        .toList();

    if (productList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final ProductModel selectedProduct = productList.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle("Product Details", screenWidth)),
            Text(
              "Rs. ${selectedProduct.price}",
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Product Desc
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            selectedProduct.description ?? "",
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: MyColors.greyColor,
              height: 1.5,
            ),
          ),
        ),

        // Variations
        _sectionTitle("Variations", screenWidth),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Row(
            children: [
              Chip(label: Text("Pink")),
              SizedBox(width: screenWidth * 0.025),
              Chip(label: Text("M")),
            ],
          ),
        ),

        // Specifications
        _sectionTitle("Specifications", screenWidth),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Material: Cotton 95%, Nylon 5%"),
              SizedBox(height: screenWidth * 0.01),
              Text("Origin: EU"),
            ],
          ),
        ),

        // Delivery
        _sectionTitle("Delivery", screenWidth),
        _deliveryTile("Standard", "5-7 days", "Rs. 300", screenWidth),
        _deliveryTile("Express", "1-2 days", "Rs. 1200", screenWidth),

        SizedBox(height: screenWidth * 0.05),
      ],
    );
  }

  Widget _sectionTitle(String title, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _deliveryTile(
    String title,
    String days,
    String price,
    double screenWidth,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.015,
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.035),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.primaryColor),
          borderRadius: BorderRadius.circular(screenWidth * 0.025),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("$title ($days)"), Text(price)],
        ),
      ),
    );
  }
}
