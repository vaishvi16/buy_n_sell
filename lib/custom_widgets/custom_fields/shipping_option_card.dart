import 'package:flutter/material.dart';
import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';

class ShippingOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const ShippingOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? MyColors.primaryColor : MyColors.transparentColor,
          ),
        ),
        child: ListTile(
          leading: Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: MyColors.primaryColor,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color:
              selected ? MyColors.primaryColor : MyColors.blackColor,
            ),
          ),
        ),
      ),
    );
  }
}
