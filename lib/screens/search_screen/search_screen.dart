import 'dart:io';

import 'package:buy_n_sell/custom_widgets/my_appbar/my_appbar.dart';
import 'package:buy_n_sell/providers/product_provider.dart';
import 'package:buy_n_sell/screens/search_screen/category_searches.dart';
import 'package:buy_n_sell/screens/search_screen/product_searches.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/my_colors/my_colors.dart';
import '../../providers/category_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(forceRefresh: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final imagePath =
    ModalRoute.of(context)?.settings.arguments as String?;

    if (imagePath != null) {
      setState(() {
        isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath =
    ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: MyAppBar(
        readOnly: false,
        autoFocus: true,
        controller: _searchController,
        navigate: SearchScreen(),
        onChanged: (value) {
          setState(() {
            isSubmitted = false;
          });
        },
        onSubmitted: (value) {
          print("onsubmitted clicked");
          setState(() {
            isSubmitted = true;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (imagePath != null)
              Padding(
                padding:  EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            CategorySearches(searchQuery: _searchController.text),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "All items",
                      style: TextStyle(
                        color: MyColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.tune_outlined, size: 21),
                ),
              ],
            ),
            ProductSearches(searchQuery: _searchController.text, isSubmitted: isSubmitted,),
          ],
        ),
      ),
    );
  }
}
