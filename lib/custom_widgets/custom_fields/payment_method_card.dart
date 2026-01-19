
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final String methodName;
  const PaymentMethodCard(this.methodName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(methodName),
        ),
      ),
    );
  }
}
