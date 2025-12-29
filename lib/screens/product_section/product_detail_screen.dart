import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../model_class/product_model.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;

  const ProductDetailScreen({super.key, required this.id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bottomBarHeight = MediaQuery.of(context).size.height * 0.09;

    return Scaffold(
      body: SafeArea(
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
        
            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }
        
            final ProductModel product = provider.allProducts.firstWhere(
              (p) => p.id == widget.id,
            );
        
            return Stack(
              children: [
                // ---------------- SCROLLABLE CONTENT ----------------
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomBarHeight + 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: screenWidth * 1.1,
                        child: Image.network(
                          product.image ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
        
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Rs. ${product.price}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.screen_share_outlined),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              product.description ?? "",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
        
                      _sectionTitle("Variations"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Chip(label: Text("Pink")),
                            SizedBox(width: 10),
                            Chip(label: Text("M")),
                          ],
                        ),
                      ),
        
                      _sectionTitle("Specifications"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Material: Cotton 95%, Nylon 5%"),
                            SizedBox(height: 4),
                            Text("Origin: EU"),
                          ],
                        ),
                      ),
        
                      _sectionTitle("Delivery"),
                      _deliveryTile("Standard", "5-7 days", "Rs. 300"),
                      _deliveryTile("Express", "1-2 days", "Rs. 1200"),
        
                      _sectionTitle("Rating & Reviews"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            Icon(Icons.star, color: Colors.orange),
                            Icon(Icons.star, color: Colors.orange),
                            Icon(Icons.star, color: Colors.orange),
                            Icon(Icons.star_border),
                            SizedBox(width: 8),
                            Text("4/5"),
                          ],
                        ),
                      ),
        
                      SizedBox(height: 20),
        
                      _sectionHeaderWithAction("Most Popular"),
                      _relatedProductsGrid(
                        _getRandomProducts(provider.allProducts),
                      ),
        
                      _sectionHeaderWithAction("You Might Like"),
                      _relatedProductsGrid(
                        _getCategoryWiseProducts(
                          products: provider.allProducts,
                          categoryId: product.catId!,
                          currentProductId: product.id!,
                        ),
                      ),
        
                      SizedBox(height: 30),
                    ],
                  ),
                ),
        
                // ---------------- STICKY BOTTOM BAR ----------------
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: bottomBarHeight,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.blackColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Add to cart",
                              style: TextStyle(color: MyColors.whiteColor),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Buy now",
                              style: TextStyle(color: MyColors.whiteLightColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------- SMALL HELPERS -----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _deliveryTile(String title, String days, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("$title ($days)"), Text(price)],
        ),
      ),
    );
  }

  Widget _sectionHeaderWithAction(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _relatedProductsGrid(List<ProductModel> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length > 4 ? 4 : products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (_, index) {
        final product = products[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.image ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 6),
            Text(
              product.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text("Rs. ${product.price}", style: TextStyle(color: Colors.grey)),
          ],
        );
      },
    );
  }

  // to get random 4 products from the list and show it in most popular section
  List<ProductModel> _getRandomProducts(List<ProductModel> products) {
    final list = List<ProductModel>.from(products);
    list.shuffle();
    return list.length > 4 ? list.take(4).toList() : list;
  }

  // to get products based on the current category to show in you might like section
  List<ProductModel> _getCategoryWiseProducts({
    required List<ProductModel> products,
    required String categoryId,
    required String currentProductId,
  }) {
    final filtered = products
        .where((p) => p.catId == categoryId && p.id != currentProductId)
        .toList();

    return filtered.length > 4 ? filtered.take(4).toList() : filtered;
  }
}
