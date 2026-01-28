import 'package:buy_n_sell/custom_widgets/my_appbar/primary_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api_urls/api_urls.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/order_history_provider.dart';
import '../product_section/product_detail_screen.dart';

class ReviewProductScreen extends StatefulWidget {
  const ReviewProductScreen({super.key});

  @override
  State<ReviewProductScreen> createState() => _ReviewProductScreenState();
}

class _ReviewProductScreenState extends State<ReviewProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<OrderHistoryProvider>(context, listen: false);

      if (provider.orders.isEmpty) {
        provider.fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: primaryAppBar(
        title: "Review Products",
        subtitle: "Select Item to Review",
      ),
      body: Consumer<OrderHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          //REMOVE DUPLICATES
          final Map<String, dynamic> uniqueProducts = {};

          for (final order in provider.orders) {
            for (final item in order.items) {
              uniqueProducts[item.productId] = item;
            }
          }

          final products = uniqueProducts.values.toList();

          if (products.isEmpty) {
            return const Center(child: Text("No products to review"));
          }

          return ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.04),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];

              return Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: MyColors.whiteColor,
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(screenWidth * 0.02),
                      child: Image.network(
                        "${ApiUrl.baseTestUrl}uploads/product/${item.image}",
                        height: screenWidth * 0.15,
                        width: screenWidth * 0.15,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(id: item.productId, isFromReview: true,),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.025),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.045,
                          vertical: screenHeight * 0.012,
                        ),
                      ),
                      child: Text(
                        "Review",
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
