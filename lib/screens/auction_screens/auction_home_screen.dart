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
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.liveAuctions.isEmpty) {
            return const Text("No live auctions");
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
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuctionListScreen(),
                        ),
                      );
                    },
                    child: const Text("See All"),
                  ),
                ],
              ),

              SizedBox(height: screenWidth * 0.03),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.liveAuctions.length >= 4 ? 4 : provider.liveAuctions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = provider.liveAuctions[index];

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
                      },
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
