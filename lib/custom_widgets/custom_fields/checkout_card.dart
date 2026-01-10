import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';

class CheckoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;

  const CheckoutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                       TextStyle(fontWeight: FontWeight.w600, color: MyColors.primaryColor)),
                   SizedBox(height: 8),
                  Text(subtitle,
                      style:  TextStyle(color: MyColors.blackColor)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_rounded, color: MyColors.primaryColor),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
