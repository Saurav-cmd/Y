import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/utility/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthController aC = Get.put(AuthController());

  String code = "";

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      code = countryCode.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    code = "977";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    phoneController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
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
                  "images/Group 4.svg",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.030),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(
                          color: ChooseColor(0).blueColor,
                          fontSize: size.height * 0.030 + size.width * 0.030),
                    ),
                    SizedBox(height: size.height * 0.010),
                    Text(
                      "Account",
                      style: TextStyle(
                          color: ChooseColor(0).blueColor,
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
                                decoration: const InputDecoration(
                                    hintText: "First Name"),
                                controller: nameController,
                                onChanged: (value) {
                                  if (nameController.text.isNotEmpty) {
                                    nameController.text =
                                        "${nameController.text[0].toUpperCase()}${nameController.text.substring(1)}";
                                    nameController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                nameController.text.length));
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your first name";
                                  } else if (value.length > 32) {
                                    return "First name cannot be more than 32 character";
                                  } else {
                                    return null;
                                  }
                                },
                                textCapitalization: TextCapitalization.words,
                              ),
                              SizedBox(height: size.height * 0.030),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Last Name"),
                                controller: lastNameController,
                                onChanged: (value) {
                                  if (lastNameController.text.isNotEmpty) {
                                    lastNameController.text =
                                        "${lastNameController.text[0].toUpperCase()}${lastNameController.text.substring(1)}";
                                    lastNameController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: lastNameController
                                                .text.length));
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your last name";
                                  } else if (value.length > 32) {
                                    return "First name cannot be more than 32 character";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: size.height * 0.030),
                              TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                  ),
                                  controller: emailController,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(
                                              emailController.text)
                                      ? "Enter a valid email"
                                      : null),
                              SizedBox(height: size.height * 0.030),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Address",
                                ),
                                controller: addressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter address";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: size.height * 0.030),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.080,
                                    width: size.width * 0.25,
                                    child: CountryCodePicker(
                                      onChanged: _onCountryChange,
                                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      initialSelection: "NP",
                                      favorite: const ['+977', 'NP'],
                                      // optional. Shows only country name and flag
                                      showCountryOnly: false,
                                      // optional. Shows only country name and flag when popup is closed.
                                      showOnlyCountryWhenClosed: false,
                                      // optional. aligns the flag and the Text left
                                      alignLeft: false,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.020),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: "Phone",
                                      ),
                                      controller: phoneController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter phone number";
                                        } else if (!value.startsWith("9")) {
                                          return "Please enter valid phone number";
                                        } else if (value.length < 10) {
                                          return "Please enter valid phone number";
                                        } else {
                                          return null;
                                        }
                                      },
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.030),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                ),
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter password";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: size.height * 0.030),
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Confirm Password",
                                ),
                                controller: confirmPasswordController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter password";
                                  } else if (value != passwordController.text) {
                                    return "Password deosn't match";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: size.height * 0.030),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.010),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  size.height * 0.022 + size.width * 0.022,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_form.currentState!.validate()) {
                                await aC.registerUser(
                                    nameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    addressController.text,
                                    code + "-" + phoneController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                    context);
                              } else {
                                return;
                              }
                            },
                            child: Image.asset(
                              "images/bluecircle.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed("Login_screen");
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.015,
                            vertical: size.height * 0.020),
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  size.height * 0.014 + size.width * 0.014,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.030)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
