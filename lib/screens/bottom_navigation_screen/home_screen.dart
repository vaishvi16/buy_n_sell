import 'package:buy_n_sell/custom_widgets/my_appbar/my_appbar.dart';
import 'package:buy_n_sell/custom_widgets/my_colors/my_colors.dart';
import 'package:buy_n_sell/providers/auction_provider.dart';
import 'package:buy_n_sell/screens/search_screen/category_searches.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../auction_screens/auction_home_screen.dart';
import '../category_section/category_section.dart';
import '../search_screen/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<AuctionProvider>(context, listen: false).fetchAuctions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(readOnly: true,controller: _searchController,navigate: SearchScreen(), autoFocus: false,),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            child: Card(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: MyColors.greyColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Image.network(
                  "https://thumbs.dreamstime.com/b/winter-sale-concept-horizontal-banner-vector-illustration-abstract-creative-discount-layout-special-offer-graphic-design-poster-104935868.jpg",
                  width: screenWidth,
                  // height: screenHeight * 0.25,
                ),
              ),
            ),
          ),
          AuctionHomeSection(),
          CategorySection(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Top Products",
                    style: TextStyle(
                      color: MyColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllCategorySection(),
                      ),
                    );*/
                  },
                  child: Row(
                    spacing: 10,
                    children: [
                      Text(
                        "See All",
                        style: TextStyle(
                          color: MyColors.blackDarkColor,
                          fontSize: 15,
                        ),
                      ),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: MyColors.primaryColor,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: MyColors.whiteLightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CategorySearches(),
        ],),
      ),
    );
  }
}
