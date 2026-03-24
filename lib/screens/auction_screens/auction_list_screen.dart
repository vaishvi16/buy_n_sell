import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/custom_fields/auction_product_card.dart';
import '../../providers/auction_provider.dart';
import 'auction_detail_screen.dart';

class AuctionListScreen extends StatefulWidget {
  const AuctionListScreen({super.key});

  @override
  State<AuctionListScreen> createState() => _AuctionListScreenState();
}

class _AuctionListScreenState extends State<AuctionListScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Auctions")),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Consumer<AuctionProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final allAuctions = [
              ...provider.liveAuctions,
              ...provider.upcomingAuctions,
              ...provider.endedAuctions
            ];

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: allAuctions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.03,
                  mainAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = allAuctions[index];
                  final isEnded = product.bidStatus == 'sold' || product.bidStatus == 'available';

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
                        "bid_status": product.bidStatus
                      },
                      isEnded: isEnded,
                      productId: product.id,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      await Provider.of<AuctionProvider>(context, listen: false).fetchAuctions();
    } catch (e) {
      debugPrint("Refresh error: $e");
    }
  }
}
