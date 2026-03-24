import 'package:flutter/material.dart';

class CheckoutTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final int? maxLength;

  const CheckoutTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.textInputType,
    this.maxLength
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: textInputType,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
