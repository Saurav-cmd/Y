import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y/services/services.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> logUserIn(
      String? email, String? password, BuildContext context) async {
    try {
      isLoading(true);
      return await Services.loginUser(email, password, context);
    } finally {
      isLoading(false);
    }
  }

  Future<void> registerUser(
      String? fName,
      String? lName,
      String? email,
      String? address,
      String? contact,
      String? password,
      String? confirmPassword,
      BuildContext context) async {
    try {
      isLoading(true);
      return await Services.registerUser(fName, lName, email, address, contact,
          password, confirmPassword, context);
    } finally {
      isLoading(false);
    }
  }

  Future<String?> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData');
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userData");
    Navigator.of(context).pushNamedAndRemoveUntil(
        'Login_screen', (Route<dynamic> route) => false);
  }

  Future<void> forgotPassword(String? email, BuildContext context) async {
    try {
      isLoading(true);
      return await Services.forgetPassword(email, context);
    } finally {
      isLoading(false);
    }
  }
}
