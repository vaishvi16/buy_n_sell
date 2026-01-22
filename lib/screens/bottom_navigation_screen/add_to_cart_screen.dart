import 'package:buy_n_sell/screens/payment_screens/payment_screen.dart';
import 'package:buy_n_sell/screens/payment_screens/shipping_address.dart';
import 'package:buy_n_sell/screens/product_section/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/checkout_card.dart';
import '../../custom_widgets/custom_fields/custom_wishlist_card.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../model_class/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../shared_pref/shared_pref.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  String? shippingAddress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedAddress();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.whiteLightColor,
      appBar: AppBar(
        backgroundColor: MyColors.whiteColor,
        elevation: 0,
        foregroundColor: MyColors.blackColor,
        title: Row(
          children: [
            Text("Cart"),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(
              radius: screenWidth * 0.025,
              backgroundColor: MyColors.blackColor,
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return Text(
                    cartProvider.totalItems.toString(),
                    style: TextStyle(
                      color: MyColors.whiteColor,
                      fontSize: screenWidth * 0.03,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Consumer3<CartProvider, ProductProvider, WishlistProvider>(
        builder:
            (context, cartProvider, productProvider, wishlistProvider, child) {
          if (productProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final cartProducts = _getCartProducts(
            productProvider.allProducts,
            cartProvider.cartItems,
          );

          final wishlistProducts = productProvider.allProducts
              .where((p) => wishlistProvider.isInWishlist(p.id ?? ""))
              .toList();

          if (cartProducts.isEmpty && wishlistProducts.isEmpty) {
            return Center(child: Text("Your cart is empty!"));
          }

          return ListView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            children: [
              _shippingAddressCard(screenWidth),
              SizedBox(height: screenHeight * 0.02),

              // ---------------- CART ITEMS ----------------
              if (cartProducts.isEmpty)
                CircleAvatar(
                  radius: screenWidth * 0.2,
                  child: Center(
                    child: Image.asset(
                      "assets/logos/5_miles.png",
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                ...cartProducts.map((item) {
                  final product = item['product'] as ProductModel;
                  final quantity = item['quantity'] as int;
                  return Padding(
                    padding:
                    EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(id: product.id),
                          ),
                        );
                      },
                      child: _cartItem(
                        product: product,
                        quantity: quantity,
                        screenWidth: screenWidth,
                      ),
                    ),
                  );
                }).toList(),

              // ---------------- WISHLIST ITEMS ----------------
              if (wishlistProducts.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "From Your Wishlist",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                ...wishlistProducts.map((product) {
                  return Padding(
                    padding:
                    EdgeInsets.only(bottom: screenHeight * 0.015),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(id: product.id),
                          ),
                        );
                      },
                      child: CustomWishlistCard(product: product,screenWidth: screenWidth),
                    ),
                  );
                }).toList(),
              ],
            ],
          );
        },
      ),

      bottomNavigationBar: SafeArea(top: false, child: _bottomCheckoutBar()),
    );
  }

  // ---------------- SHIPPING ADDRESS ----------------
  Widget _shippingAddressCard(double screenWidth) {
    return  CheckoutCard(
      title: "Shipping Address",
      subtitle: shippingAddress ?? "Add on your location",
      onEdit: () async {
        // saved combined address
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShippingAddressScreen(savedAddress: shippingAddress,),
          ),
        );

        // If user saved something, update the subtitle
        if (result != null) {
          setState(() {
            shippingAddress = result;
          });
        }
      },
    );
  }

  // ---------------- CART ITEM ----------------
  Widget _cartItem({
    required ProductModel product,
    required int quantity,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: MyColors.whiteColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
            child: Image.network(
              product.image ?? "",
              height: screenWidth * 0.22,
              width: screenWidth * 0.18,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: screenWidth * 0.22,
                width: screenWidth * 0.18,
                color: MyColors.greyColor,
                child:  Icon(Icons.image_not_supported),
              ),
            ),
          ),

          SizedBox(width: screenWidth * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.015),
                Text(
                  "Rs. ${product.price}",
                  style:  TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                icon:  Icon(Icons.remove),
                onPressed: () {
                  context.read<CartProvider>().decreaseQty(product.id!);
                },
              ),
              Text(quantity.toString()),
              IconButton(
                icon:  Icon(Icons.add),
                onPressed: () {
                  context.read<CartProvider>().increaseQty(product.id!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomCheckoutBar() {
    return Card(
      margin:  EdgeInsets.fromLTRB(12, 8, 12, 12),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  double total = 0;

                  for (final entry in cartProvider.cartItems.entries) {
                    final product = context
                        .read<ProductProvider>()
                        .allProducts
                        .firstWhere(
                          (p) => p.id == entry.key,
                      orElse: () => ProductModel(),
                    );

                    final price =
                        double.tryParse(product.price ?? '0') ?? 0;
                    total += price * entry.value;
                  }

                  return Text(
                    "Total  Rs. ${total.toStringAsFixed(2)}",
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryLightColor,
                padding:
                 EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(),));
              },
              child: Text(
                "Checkout",
                style: TextStyle(color: MyColors.whiteLightColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getCartProducts(
      List<ProductModel> allProducts,
      Map<String, int> cartItems,
      ) {
    final List<Map<String, dynamic>> result = [];

    for (final entry in cartItems.entries) {
      final product = allProducts.firstWhere(
            (p) => p.id == entry.key,
        orElse: () => ProductModel(),
      );

      if (product.id != null) {
        result.add({'product': product, 'quantity': entry.value});
      }
    }

    return result;
  }

  Future<void> _loadSavedAddress() async {
    final address = await SharedPref.getShippingAddress();
    if (address != null && mounted) {
      setState(() {
        shippingAddress = address;
      });
    }
  }

}
