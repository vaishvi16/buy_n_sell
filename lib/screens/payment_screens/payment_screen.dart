import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_fields/checkout_card.dart';
import '../../custom_widgets/custom_fields/checkout_item_card.dart';
import '../../custom_widgets/custom_fields/payment_method_card.dart';
import '../../custom_widgets/custom_fields/shipping_option_card.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../location_helper/location_helper.dart';
import '../../model_class/place_order_model.dart';
import '../../model_class/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../../shared_pref/shared_pref.dart';
import 'contact_info.dart';
import 'shipping_address.dart';
import 'voucher_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod; // "card", "upi", "cod"

  int _selectedShippingIndex = 0;
  double _shippingPrice = 0;
  String? _shippingAddress;
  String? _email;
  String? _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedAddress();
    _loadContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Payment",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.065,
          ),
        ),
        elevation: 0,
      ),

      body: Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, _) {
          final cartItems = cartProvider.cartItems;

          final List<Map<String, dynamic>> cartProducts = [];

          for (final entry in cartItems.entries) {
            final product = productProvider.allProducts.firstWhere(
                  (p) => p.id == entry.key,
              orElse: () => ProductModel(),
            );

            if (product.id != null) {
              cartProducts.add({
                'product': product,
                'quantity': entry.value,
              });
            }
          }

          double totalPrice = _shippingPrice;
          for (final item in cartProducts) {
            final ProductModel product = item['product'];
            final int qty = item['quantity'];
            final price = double.tryParse(product.price ?? '0') ?? 0;
            totalPrice += price * qty;
          }

          return ListView(
            padding: EdgeInsets.all(screenWidth * 0.03),
            children: [
              //SHIPPING ADDRESS
              CheckoutCard(
                title: "Shipping Address",
                subtitle: _shippingAddress ?? "Add on your location",
                onEdit: () async {
                  // saved combined address
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShippingAddressScreen(savedAddress: _shippingAddress,),
                    ),
                  );

                  // If user saved something, update the subtitle
                  if (result != null) {
                    setState(() {
                      _shippingAddress = result;
                    });
                  }
                },
              ),

              SizedBox(height: screenHeight * 0.02),

              // CONTACT INFO
              CheckoutCard(
                title: "Contact Information",
                subtitle:
                "${_phone ?? 'Add phone number'}\n${_email ?? ''}",
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ContactInfoScreen(
                        email: _email,
                        phone: _phone,
                      ),
                    ),
                  );

                  if (result == true) {
                    _loadContactInfo();
                  }
                },

              ),

              SizedBox(height: screenHeight * 0.03),

              // ITEMS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Items (${cartProducts.length})",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.045,
                      color: MyColors.primaryColor,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          side: BorderSide(color: MyColors.primaryLightColor),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VoucherScreen(),
                        ),
                      );
                    },
                    child: Text("Add Voucher"),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.015),

              // CART ITEMS
              if (cartProducts.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenHeight * 0.05),
                    child: Text("No items in cart"),
                  ),
                )
              else
                ...cartProducts.map((item) {
                  final ProductModel product = item['product'];
                  final int qty = item['quantity'];

                  return CheckoutItemCard(
                    title: "${product.name}  (x$qty)",
                    price: "Rs. ${product.price}",
                    imageUrl: product.image ?? "",
                  );
                }),

              SizedBox(height: screenHeight * 0.03),

              // SHIPPING OPTIONS
              Text(
                "Shipping Options",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.045,
                  color: MyColors.primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              ShippingOptionCard(
                title: "Standard",
                subtitle: "5–7 days",
                price: "FREE",
                selected: _selectedShippingIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedShippingIndex = 0;
                    _shippingPrice = 0;
                  });
                },
              ),

              ShippingOptionCard(
                title: "Express",
                subtitle: "1–2 days",
                price: "Rs. 700",
                selected: _selectedShippingIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedShippingIndex = 1;
                    _shippingPrice = 700;
                  });
                },
              ),

              SizedBox(height: screenHeight * 0.03),

              // PAYMENT METHOD
              Text(
                "Payment Method",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.045,
                  color: MyColors.primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              Row(
                children: [
                  PaymentMethodCard(
                    methodName: "Card",
                    isSelected: _selectedPaymentMethod == "card",
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = "card";
                      });
                    },
                  ),
                  PaymentMethodCard(
                    methodName: "UPI",
                    isSelected: _selectedPaymentMethod == "upi",
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = "upi";
                      });
                    },
                  ),
                  PaymentMethodCard(
                    methodName: "COD",
                    isSelected: _selectedPaymentMethod == "cod",
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = "cod";
                      });
                    },
                  ),
                ],
              ),

            ],
          );
        },
      ),

      // BOTTOM BAR
      bottomNavigationBar: Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, _) {
          double total = _shippingPrice;

          for (final entry in cartProvider.cartItems.entries) {
            final product = productProvider.allProducts.firstWhere(
                  (p) => p.id == entry.key,
              orElse: () => ProductModel(),
            );

            final price = double.tryParse(product.price ?? '0') ?? 0;
            total += price * entry.value;
          }

          return Container(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.04,
              screenHeight * 0.015,
              screenWidth * 0.04,
              screenHeight * 0.025,
            ),
            decoration: BoxDecoration(
              color: MyColors.whiteLightColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(screenWidth * 0.05),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total  Rs. ${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryLightColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.09,
                      vertical: screenHeight * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                  ),
                  onPressed: () async {

                    if (_shippingAddress == null || _shippingAddress!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please add shipping address")),
                      );
                      return;
                    }

                    if (_phone == null || _phone!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please add phone number")),
                      );
                      return;
                    }

                    if (_selectedPaymentMethod == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select payment method")),
                      );
                      return;
                    }

                    final userId = await SharedPref.getUserId();
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please login first.")),
                      );
                      return;
                    }

                    final productIds = cartProvider.cartItems.keys.join(',');

                    if (productIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cart is empty.")),
                      );
                      return;
                    }

                    final orderModel = PlaceOrderModel(
                      userId: userId,
                      productIds: productIds,
                      quantities: cartProvider.cartItems,
                      address: _shippingAddress!,
                      phone: _phone!,
                      paymentMethod: _selectedPaymentMethod!,
                      shippingType: _selectedShippingIndex == 0 ? "standard" : "express",
                      totalAmount: total,
                    );

                    final orderProvider =
                    Provider.of<OrderProvider>(context, listen: false);

                    final response = await orderProvider.placeOrder(orderModel);

                    if (response.status == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.message ?? "Order placed")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.message ?? "Order failed")),
                      );
                    }

                  },

                  child: Text(
                    "Pay",
                    style: TextStyle(color: MyColors.whiteColor),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadSavedAddress() async {
    final address = await SharedPref.getShippingAddress();
    if (address != null && mounted) {
      setState(() {
        _shippingAddress = address;
      });
    }
  }

  Future<void> _loadContactInfo() async {
    final email = await SharedPref.getUserEmail();
    final phone = await SharedPref.getPhoneNumber();

    if (mounted) {
      setState(() {
        _email = email;
        _phone = phone;
      });
    }
  }


}
