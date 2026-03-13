import 'package:buy_n_sell/providers/wishlist_provider.dart';
import 'package:buy_n_sell/screens/bottom_navigation_screen/add_to_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../api_urls/api_urls.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../model_class/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? id;
  final bool isFromReview;

  const ProductDetailScreen({
    super.key,
    required this.id,
    this.isFromReview = false, // default false
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, String> selectedAttributes = {};

  @override
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final wishlistProvider = Provider.of<WishlistProvider>(
        context,
        listen: false,
      );
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      await productProvider.fetchSingleProduct(widget.id!);

      if (widget.id != null) {
        await productProvider.fetchProductAttributes(widget.id!);
      }

      final savedData = wishlistProvider.wishlistData[widget.id];

      if (savedData != null) {
        setState(() {
          selectedAttributes = Map<String, String>.from(savedData);
        });
      } else if (cartProvider.selectedAttributes.containsKey(widget.id)) {
        setState(() {
          selectedAttributes = Map<String, String>.from(
            cartProvider.selectedAttributes[widget.id]!,
          );
        });
      }
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

            final product = provider.allProducts
                .where((p) => p.id == widget.id)
                .toList();

            if (product.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            final ProductModel selectedProduct = product.first;

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
                          selectedProduct.image ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Rs. ${selectedProduct.price}",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _shareProduct(selectedProduct);
                                  },
                                  icon: Icon(Icons.share),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              selectedProduct.description ?? "",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // Attributes list
                      if(selectedProduct.attributes.isNotEmpty) ...[
                        SizedBox(height:8,),
                        _sectionTitle("Specifications"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Builder(
                            builder: (context) {
                              // GROUP ATTRIBUTES BY NAME
                              final Map<String, List<String>> groupedAttributes = {};

                              for (var attr in selectedProduct.attributes) {
                                final name = attr.attributeName ?? "";
                                final value = attr.attributeValue ?? "";

                                if (!groupedAttributes.containsKey(name)) {
                                  groupedAttributes[name] = [];
                                }

                                // Split comma-separated values
                                final splitValues = value.split(",");

                                for (var val in splitValues) {
                                  final trimmedValue = val.trim(); // remove extra spaces

                                  if (trimmedValue.isNotEmpty &&
                                      !groupedAttributes[name]!.contains(trimmedValue)) {
                                    groupedAttributes[name]!.add(trimmedValue);
                                  }
                                }
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: groupedAttributes.entries.map((entry) {
                                  final attributeName = entry.key;
                                  final values = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 12),

                                      // Dynamic Heading (Color / Size / Storage etc)
                                      Text(
                                        attributeName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      Wrap(
                                        spacing: 8,
                                        children: values.map((value) {
                                          final isSelected =
                                              selectedAttributes[attributeName] ==
                                                  value;

                                          return ChoiceChip(
                                            label: Text(value),
                                            selected: isSelected,
                                            onSelected: (_) {
                                              setState(() {
                                                selectedAttributes[attributeName] =
                                                    value;
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                      //to hide in review screen
                      if (!widget.isFromReview) ...[
                        SizedBox(height: 8,),
                        _sectionTitle("Rating & Reviews"),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < selectedProduct.averageRating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: MyColors.orangeColor,
                                size: 20,
                              );
                            }),
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
                            categoryId: selectedProduct.catId!,
                            currentProductId: selectedProduct.id!,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),

                if (!widget.isFromReview) ...[
                  // ---------------- STICKY BOTTOM BAR ----------------
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Consumer2<WishlistProvider, CartProvider>(
                      builder: (context, wishlistProvider, cartProvider, child) {
                        final isFav = wishlistProvider.isInWishlist(selectedProduct.id!);
                        final isInCart = cartProvider.isInCart(selectedProduct.id!);

                        return Container(
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
                              // ---------------- Favorite Button ----------------
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? MyColors.primaryColor : MyColors.greyColor,
                                ),
                                onPressed: () {
                                  wishlistProvider.toggleWishlist(
                                    selectedProduct.id!,
                                    selectedAttributes,
                                  );
                                },
                              ),
                              SizedBox(width: 10),

                              // ---------------- Add to Cart / Product Added ----------------
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    isInCart ? MyColors.greyColor : MyColors.blackColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: isInCart
                                      ? null
                                      : () {
                                    cartProvider.selectedAttributes[selectedProduct.id ?? ""] =
                                        Map.from(selectedAttributes);

                                    cartProvider.addToCart(
                                      selectedProduct.id!,
                                      selectedAttributes,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${selectedProduct.name} added to cart",
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    isInCart ? "Added to cart" : "Add to cart",
                                    style: TextStyle(color: MyColors.whiteColor,fontSize: 13),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              // ---------------- Buy Now ----------------
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // Save selected attributes
                                    cartProvider.selectedAttributes[selectedProduct.id ?? ""] =
                                        Map.from(selectedAttributes);

                                    // Add current product to cart
                                    cartProvider.addToCart(
                                      selectedProduct.id!,
                                      selectedAttributes,
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddToCartScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Buy now",
                                    style: TextStyle(
                                      color: MyColors.whiteLightColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(id: product.id),
              ),
            );
          },
          child: Column(
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
              Text(
                "Rs. ${product.price}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
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

  void _shareProduct(ProductModel selectedProduct) {
    final imageUrl = getProductImageUrl(selectedProduct.image);

    final shareText =
        '''
${selectedProduct.name}

Price: Rs. ${selectedProduct.price}

Colors available

Check this product:
$imageUrl
''';

    Share.share(shareText);
  }

  String getProductImageUrl(String? image) {
    if (image == null || image.isEmpty) return "";

    // If already a full URL, return as-is
    if (image.startsWith("http")) {
      return image;
    }

    // Otherwise build full path
    return "${ApiUrl.baseTestUrl}uploads/product/$image";
  }
}
