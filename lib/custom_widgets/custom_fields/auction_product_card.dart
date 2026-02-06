import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/auction_provider.dart';

class AuctionProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isEnded;
  final String productId;

  const AuctionProductCard({
    super.key,
    required this.product,
    required this.productId,
    this.isEnded = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.32;

    return Stack(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(screenWidth * 0.03),
                ),
                child: Image.network(
                  product["image"],
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(screenWidth * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.038,
                            ),
                          ),
                        ),
                        Text(
                          " \$${product["price"]}",
                          style: TextStyle(
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.015),
          FutureBuilder<String>(
            future: Provider.of<AuctionProvider>(context, listen: false)
                .getHighestBidDisplay(productId),
            builder: (context, snapshot) {
              final bidAmount = snapshot.data ?? "1";
              return Text(
                isEnded
                    ? (product["bid_status"] == 'available' ? "Starting at \$1" : "Ended at \$$bidAmount")
                    : "Live at \$$bidAmount",
                style: TextStyle(
                  color: MyColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.035,
                ),
              );
            },
          ),
                    SizedBox(height: screenWidth * 0.015),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: screenWidth * 0.020,
                          color: isEnded ? MyColors.blackDarkColor : MyColors.greenColor,
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          isEnded
                              ? (product["bid_status"] == 'available' ? "Upcoming" : "Ended")
                              : "Live",
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: isEnded ? MyColors.greyColor : MyColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Grey overlay for ended auctions
        if (isEnded && product["bid_status"] == 'sold')
          Container(
            decoration: BoxDecoration(
              color: MyColors.greyColor.withOpacity(0.55),
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
          ),
      ],
    );
  }
}
