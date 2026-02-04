class ApiUrl{

  static const String baseUrl = "https://prakrutitech.xyz/vaishvi/";
  static const String baseTestUrl = "http://192.168.29.140/5_miles/";
  //static const String baseTestUrl = "http://192.168.29.141/5_miles/";

  // Auth Url
  static const String login = "${baseTestUrl}login_user.php";
  static const String signUp = "${baseTestUrl}insert_user.php";

  //Forgot - Reset password
  static const String forgotPassword = "${baseTestUrl}forgot_password.php";
  static const String resetPassword = "${baseTestUrl}reset_password.php";

  //Category
  static const String viewCategories = "${baseTestUrl}view_category.php";

  //Product
  static const String viewProducts = "${baseTestUrl}view_product.php";

  //Order
  static const String placeOrder = "${baseTestUrl}place_order.php" ;
  static const String getOrder = "${baseTestUrl}get_order.php" ;

  //Auction
  static const String getCurrentHighestBid = "${baseTestUrl}get_current_highest_bid.php";
  static const String getBidWinner = "${baseTestUrl}bid_winner.php";
  static const String startBid = "${baseTestUrl}start_bid.php";
  static const String insertBid = "${baseTestUrl}insert_bid.php";
  static const String getAuctionTime = "${baseTestUrl}get_auction_time.php";


}