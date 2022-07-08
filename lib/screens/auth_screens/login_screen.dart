import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/utility/colors.dart';

import '../../utility/dialogue _box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController aC = Get.put(AuthController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).focusScopeNode.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => aC.isLoading.value == true ? false : true,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.35,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    "images/Group 3.svg",
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.030),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: ChooseColor(0).redColor,
                            fontSize: size.height * 0.030 + size.width * 0.030),
                      ),
                      SizedBox(height: size.height * 0.010),
                      Text(
                        "Back",
                        style: TextStyle(
                            color: ChooseColor(0).redColor,
                            fontSize: size.height * 0.030 + size.width * 0.030),
                      ),
                      SizedBox(height: size.height * 0.040),
                      Form(
                          key: _form,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.010),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                      const InputDecoration(hintText: "Email"),
                                  controller: emailController,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(
                                              emailController.text)
                                      ? "Enter a valid email"
                                      : null,
                                ),
                                SizedBox(height: size.height * 0.030),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                  ),
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                )
                              ],
                            ),
                          )),
                      SizedBox(height: size.height * 0.030),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("Forget_password_screen");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      size.height * 0.014 + size.width * 0.014,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.030),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.010),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    size.height * 0.022 + size.width * 0.022,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                      "example.com");
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    if (_form.currentState!.validate()) {
                                      await aC.logUserIn(emailController.text,
                                          passwordController.text, context);
                                      Navigator.of(context)
                                          .focusScopeNode
                                          .unfocus();
                                    }
                                  }
                                } on SocketException catch (_) {
                                  AlertDialogueBox().noWifiConnection(
                                      1,
                                      "",
                                      "",
                                      "",
                                      "",
                                      null,
                                      "",
                                      "",
                                      "",
                                      "",
                                      null,
                                      context);
                                }
                              },
                              child: SvgPicture.asset(
                                "images/arrowcircleright.svg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed("Register_screen");
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.015,
                              vertical: size.height * 0.020),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    size.height * 0.014 + size.width * 0.014,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.030),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/google.png",
                            scale: 60,
                          ),
                          SizedBox(width: size.width * 0.040),
                          Image.asset(
                            "images/facebook.png",
                            scale: 17,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.030),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
