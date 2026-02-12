import 'dart:io';
import 'package:flutter/material.dart';

class SellProductScreen extends StatelessWidget {
  final String imagePath;

   SellProductScreen({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Sell Product"),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Preview
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(imagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

             SizedBox(height: 20),

             Text(
              "Captured Image Preview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

             SizedBox(height: 20),

             Text(
              "Product form UI will be added here.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
