import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/utility/colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool submitValid = false;
  EmailAuth? emailAuth;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  AuthController aC = Get.put(AuthController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Shader linearGradient = LinearGradient(
      colors: <Color>[ChooseColor(0).flagColor, ChooseColor(0).pinkColor],
    ).createShader(const Rect.fromLTWH(50.0, 0.0, 200.0, 50.0));

    return GestureDetector(
      onTap: () {
        Navigator.of(context).focusScopeNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: ChooseColor(0).bodyBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ChooseColor(0).bodyBackgroundColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ChooseColor(0).blueColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.030, vertical: size.height * 0.020),
          child: Column(
            children: [
              Text(
                "Forgot Password",
                style: TextStyle(
                    color: ChooseColor(0).pinkColor,
                    fontSize: size.height * 0.030 + size.width * 0.030,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.020),
              Text(
                "We will send password reset link to your mail",
                style: TextStyle(
                    color: ChooseColor(0).blueColor,
                    fontSize: size.height * 0.015 + size.width * 0.015,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.030),
              Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: size.height * 0.001,
                            horizontal: size.width * 0.030),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        // labelText: 'Phone Number',
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Email Address',
                        prefixIcon: const Icon(Icons.email),
                        hintStyle: TextStyle(
                            fontSize: size.height * 0.012 + size.width * 0.012,
                            color: Colors.black26),
                      ),
                      validator: (email) => email != null &&
                              !EmailValidator.validate(emailController.text)
                          ? "Enter a valid email"
                          : null,
                      controller: emailController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.030),
              Obx(() {
                if (aC.isLoading.value) {
                  return CircularProgressIndicator(
                      color: ChooseColor(0).blueColor);
                } else {
                  return ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: double.infinity, height: size.height * 0.055),
                    child: ElevatedButton(
                      child: Text(
                        'RESET',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                      onPressed: () async {
                        if (_form.currentState!.validate()) {
                          aC.forgotPassword(emailController.text, context);
                          Navigator.of(context).focusScopeNode.unfocus();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: ChooseColor(0).pinkColor,
                      ),
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
