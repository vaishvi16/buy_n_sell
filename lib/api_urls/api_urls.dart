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


}