import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {

  static String userLoggedKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USERMAILKEY";

  static Future<bool> saveUserLoggedInStatusIntoSP(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedKey, isUserLoggedIn);
  }
  static Future<bool> saveUserNameSP(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }
  static Future<bool> saveUserEmailSP(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInStatusFromSP() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedKey);
  }

  static Future<String?> getUserEmailFromSP() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
  static Future<String?> getUserNameFromSP() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
