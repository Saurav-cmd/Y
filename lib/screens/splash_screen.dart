import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/utility/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key, key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController aC = Get.put(AuthController());

  @override
  void initState() {
    doLogin();
    super.initState();
  }

  void doLogin() async {
    Future.delayed(const Duration(seconds: 3), () async {
      final autoLogin = await aC.autoLogin();
      if (autoLogin != null) {
        Navigator.of(context).pushReplacementNamed('Home_screen');
      } else if (autoLogin == null) {
        Navigator.of(context).pushReplacementNamed('Login_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ChooseColor(0).flagColor,
            ChooseColor(0).pinkColor
          ])),
          child: Text(
            "Y",
            style: TextStyle(
                color: Colors.white,
                fontSize: size.height * 0.1 + size.width * 0.1),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
