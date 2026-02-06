import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/custom_fields/auction_product_card.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/auction_provider.dart';
import 'auction_detail_screen.dart';
import 'auction_list_screen.dart';

class AuctionHomeSection extends StatelessWidget {
  const AuctionHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Consumer<AuctionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return  Center(child: CircularProgressIndicator());
          }

          // Show both live + upcoming
          final homeAuctions = [
            ...provider.liveAuctions,
            ...provider.upcomingAuctions
          ];

          if (homeAuctions.isEmpty) {
            return  Text("Auctions starting soon!");
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  Text(
                    " Live Auctions 🔥 ",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                   Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  AuctionListScreen(),
                        ),
                      );
                    },
                    child:  Text("See All"),
                  ),
                ],
              ),

              SizedBox(height: screenWidth * 0.03),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: homeAuctions.length >= 4 ? 4 : homeAuctions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = homeAuctions[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AuctionDetailScreen(
                            product: {
                              "id": product.id,
                              "name": product.name,
                              "image": product.image,
                              "price": product.price,
                              "bid_status": product.bidStatus
                            },
                          ),
                        ),
                      );
                    },
                    child: AuctionProductCard(
                      product: {
                        "name": product.name,
                        "image": product.image,
                        "price": product.price,
                        "bid_status": product.bidStatus,
                      },
                      isEnded: product.bidStatus == 'available',
                        productId: product.id,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

}
