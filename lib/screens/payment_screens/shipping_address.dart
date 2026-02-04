import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../custom_widgets/custom_fields/checkout_textfield.dart';
import '../../custom_widgets/my_colors/my_colors.dart';
import '../../helper_class/location_helper/location_helper.dart';
import '../../shared_pref/shared_pref.dart';

class ShippingAddressScreen extends StatefulWidget {
  final String? savedAddress;

  const ShippingAddressScreen({super.key, this.savedAddress});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  bool _locationFetchedOnce = false;

  @override
  void initState() {
    super.initState();

    // If address already saved then fill controllers & SKIP location
    if (widget.savedAddress != null && widget.savedAddress!.isNotEmpty) {
      _fillFromSavedAddress(widget.savedAddress!);
    } else {
      //  Fetch location ONLY if no saved address
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchLocation();
      });
    }
  }

  // Split saved address and fill controllers
  void _fillFromSavedAddress(String address) {
    final parts = address.split(',');

    if (parts.length >= 4) {
      _addressController.text = parts[0].trim();
      _cityController.text = parts[1].trim();
      _postcodeController.text = parts[2].trim();
      _countryController.text = parts[3].trim();
    }
  }

  Future<void> _fetchLocation() async {
    if (_locationFetchedOnce) return;
    _locationFetchedOnce = true;

    Placemark? place = await LocationHelper.getCurrentPlacemark();

    if (place != null) {
      _countryController.text = place.country ?? '';
      _cityController.text = place.locality ?? '';
      _addressController.text = place.street ?? '';
      _postcodeController.text = place.postalCode ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Shipping Address",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.055,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            CheckoutTextField(
              label: "Country",
              hint: "Country",
              controller: _countryController,
            ),
            CheckoutTextField(
              label: "Address",
              hint: "Street address",
              controller: _addressController,
            ),
            CheckoutTextField(
              label: "Town / City",
              hint: "City",
              controller: _cityController,
            ),
            CheckoutTextField(
              label: "Postcode",
              hint: "Postal Code",
              controller: _postcodeController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryLightColor,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
          ),
          onPressed: () async{
            final combinedAddress =
                "${_addressController.text}, "
                "${_cityController.text}, "
                "${_postcodeController.text}, "
                "${_countryController.text}";

            await SharedPref.saveShippingAddress(combinedAddress);

            Navigator.pop(context, combinedAddress);
          },
          child: Text(
            "Save Changes",
            style: TextStyle(color: MyColors.whiteColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
