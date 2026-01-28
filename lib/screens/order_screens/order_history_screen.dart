import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api_urls/api_urls.dart';
import '../../custom_widgets/my_appbar/primary_appbar.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/order_history_provider.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderHistoryProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: primaryAppBar(title: "To Receive", subtitle: " Order History"),
      body: Consumer<OrderHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          return ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              final items = order.items;
              final displayItems = items.length > 4
                  ? items.take(4).toList()
                  : items;

              return Card(
                margin: EdgeInsets.only(bottom: screenHeight * 0.020),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                color: MyColors.whiteColor,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Row(
                    children: [
                      SizedBox(
                        height: screenWidth * 0.18,
                        width: screenWidth * 0.18,
                        child: _buildOrderImages(displayItems, screenWidth),
                      ),

                      SizedBox(width: screenWidth * 0.03),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${order.id}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.004),
                            Text(
                              "${items.length} items",
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: MyColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryLightColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.045,
                            vertical: screenHeight * 0.012,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.025,
                            ),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderTrackingScreen(orderStatus: order.orderStatus,),
                            ),
                          );
                        },
                        child: Text(
                          "Track",
                          style: TextStyle(
                            color: MyColors.greyLightColor,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderImages(List items, double screenWidth) {
    final radius = BorderRadius.circular(screenWidth * 0.015);

    Widget image(String img) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.network(
          "${ApiUrl.baseTestUrl}uploads/product/$img",
          fit: BoxFit.cover,
        ),
      );
    }

    if (items.length == 1) {
      return image(items[0].image);
    }

    if (items.length == 2) {
      return Row(
        children: [
          Expanded(child: image(items[0].image)),
          SizedBox(width: 2),
          Expanded(child: image(items[1].image)),
        ],
      );
    }

    if (items.length == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: image(items[0].image)),
                SizedBox(width: 2),
                Expanded(child: image(items[1].image)),
              ],
            ),
          ),
          SizedBox(height: 2),
          Expanded(child: image(items[2].image)), // takes full width
        ],
      );
    }

    // 4 or more → 2x2 grid
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: 4,
      itemBuilder: (_, i) => image(items[i].image),
    );
  }
}
