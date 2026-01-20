import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String methodName;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.methodName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? MyColors.primaryColor : MyColors.greyColor,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? MyColors.primaryColor : MyColors.greyColor,
              ),
              SizedBox(width: 8),
              Text(methodName),
            ],
          ),
        ),
      ),
    );
  }
}
