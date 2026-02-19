import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../model_class/category_model.dart';
import '../../providers/sell_product_provider.dart';

class SellProductScreen extends StatefulWidget {
  final String? imagePath;

  const SellProductScreen({super.key, this.imagePath});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SellProductProvider>(context, listen: false);

      provider.fetchCategories();
      provider.setInitialImage(widget.imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Sell Product",
          style: TextStyle(
            color: MyColors.primaryLightColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<SellProductProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Image Preview
                provider.selectedImagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(provider.selectedImagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Select Image"),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      provider.pickImage(ImageSource.camera),
                                  child: Text("Camera"),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () =>
                                      provider.pickImage(ImageSource.gallery),
                                  child: Text("Gallery"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                SizedBox(height: 20),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: provider.selectedCategoryId,
                  hint: Text("Select Category"),
                  items: provider.categories.map((CategoryModel category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name ?? ""),
                    );
                  }).toList(),
                  onChanged: (value) {
                    provider.setCategory(value);
                  },
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),

                SizedBox(height: 15),

                // Product Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 15),

                // Description
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 15),

                // Price
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 25),

                provider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final message = await provider.sellProduct(
                            name: nameController.text,
                            description: descController.text,
                            price: priceController.text,
                          );

                          if(message == "success"){
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text("Product inserted successfully!")));
                            Navigator.pop(context);
                          }else{
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text("Product insertion failed!")));
                          }

                        },
                        child: Text("Sell Product"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
