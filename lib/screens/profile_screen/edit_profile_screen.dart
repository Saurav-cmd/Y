import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:y/controllers/profile_controller.dart';

import '../../utility/colors.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(
      {Key,
      this.fName,
      this.lName,
      this.address,
      this.email,
      this.phoneNumber,
      key})
      : super(key: key);
  String? fName;
  String? lName;
  String? address;
  String? email;
  String? phoneNumber;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? passedFirstName;
  String? passedLastName;
  String? passedAddress;
  String? passedEmailAddress;
  String? passedPhoneNumber;

  ProfileController pC = Get.put(ProfileController());
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int index = 2;
  String? name;
  String? address;
  String email = "";
  String phone = "";
  String firstName = "";
  String lastName = "";
  String code = "";

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      code = countryCode.toString();
    });
  }

  final ImagePicker imagePicker = ImagePicker();
  File? selectedGalleryImage;
  void selectImagesFromGallery() async {
    XFile? selectedImage = await imagePicker.pickImage(
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 100,
        source: ImageSource.gallery);
    //yo server ma pathauna ko lagi gallery bata pick garaya ra  selectedGalleryImage ma halaya ko ho................
    if (selectedImage != null) {
      final temporaryStore = File(selectedImage.path);
      setState(() {
        selectedGalleryImage = temporaryStore;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passedFirstName = widget.fName;
    passedLastName = widget.lName;
    passedEmailAddress = widget.email;
    passedPhoneNumber = widget.phoneNumber;
    passedAddress = widget.address;

    firstNameController.text = passedFirstName!;
    lastNameController.text = passedLastName!;
    emailController.text = passedEmailAddress!;
    code = passedPhoneNumber!.split("-")[0];
    phoneController.text = passedPhoneNumber!.split("-")[1];
    addressController.text = passedAddress!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).focusScopeNode.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: ChooseColor(0).bodyBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ChooseColor(0).pinkColor,
            centerTitle: true,
            title: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (_form.currentState!.validate()) {
                      try {
                        final result =
                            await InternetAddress.lookup("example.com");
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          await pC.editUserProfile(
                              firstNameController.text,
                              lastNameController.text,
                              emailController.text,
                              addressController.text,
                              code + "-" + phoneController.text,
                              selectedGalleryImage,
                              passwordController.text.isEmpty
                                  ? ""
                                  : passwordController.text,
                              confirmPasswordController.text.isEmpty
                                  ? ""
                                  : confirmPasswordController.text,
                              context);
                        }
                      } on SocketException catch (_) {
                        Fluttertoast.showToast(
                            msg: "No Wifi connection",
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_SHORT);
                        /*   AlertDialogueBox().noWifiConnection(9, "", "", "", "",
                            null, "", "", "", "", null, context);*/
                      }
                    }
                    Navigator.of(context).focusScopeNode.unfocus();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.030),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      selectedGalleryImage == null
                          ? const CircleAvatar(
                              maxRadius: 50,
                              backgroundImage:
                                  AssetImage("images/Ellipse 3.png"),
                            )
                          : CircleAvatar(
                              maxRadius: 50,
                              backgroundImage:
                                  FileImage(selectedGalleryImage!)),
                      Padding(
                        padding: const EdgeInsets.only(left: 70, top: 70),
                        child: GestureDetector(
                            onTap: () {
                              selectImagesFromGallery();
                            },
                            child: Image.asset("images/Group 2.png")),
                      )
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.020),
                Text(passedFirstName! + " " + passedLastName!,
                    style: TextStyle(
                        fontSize: size.height * 0.018 + size.width * 0.018,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.010),
                Text("$passedAddress",
                    style: TextStyle(
                      fontSize: size.height * 0.014 + size.width * 0.014,
                    )),
                SizedBox(height: size.height * 0.030),
                Form(
                    key: _form,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.050),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(hintText: "First Name"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your first name";
                              } else if (value.length > 32) {
                                return "First name cannot be more than 32 character";
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              firstNameController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: firstNameController.text.length));
                            },
                            onChanged: (value) {
                              firstName = firstNameController.text;
                              if (firstName.isNotEmpty) {
                                firstNameController.text =
                                    "${firstName[0].toUpperCase()}${firstName.substring(1)}";
                                firstNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: firstName.length));
                              }
                            },
                            controller: firstNameController,
                          ),
                          SizedBox(height: size.height * 0.030),
                          TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Last Name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your last name";
                                } else if (value.length > 32) {
                                  return "First name cannot be more than 32 character";
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                lastNameController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            lastNameController.text.length));
                              },
                              onChanged: (value) {
                                lastName = lastNameController.text;
                                if (lastName.isNotEmpty) {
                                  lastNameController.text =
                                      "${lastName[0].toUpperCase()}${lastName.substring(1)}";
                                  lastNameController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: lastName.length));
                                }
                              },
                              controller: lastNameController),
                          SizedBox(height: size.height * 0.030),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Email",
                            ),
                            onChanged: (value) {
                              passedEmailAddress = emailController.text;
                              if (passedEmailAddress!.isNotEmpty) {
                                emailController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: passedEmailAddress!.length));
                              }
                            },
                            onTap: () {
                              emailController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: passedEmailAddress!.length));
                            },
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
                              hintText: "Address",
                            ),
                            onChanged: (value) {
                              passedAddress = addressController.text;
                              if (passedAddress!.isNotEmpty) {
                                addressController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: passedAddress!.length));
                              }
                            },
                            onTap: () {
                              addressController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: passedAddress!.length));
                            },
                            controller: addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your address";
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
                                  onChanged: (value) async {
                                    log("This is passed phone number $passedPhoneNumber");
                                    phoneController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                phoneController.text.length));
                                  },
                                  onTap: () async {
                                    phoneController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: passedPhoneNumber!
                                                .split("-")[1]
                                                .length));
                                  },
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),

                          /*  SizedBox(height: size.height * 0.030),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Password",
                            ),
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null ) {
                                return "Please enter your password";
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
                            obscureText: true,
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value == null) {
                                return "Please enter password";
                              } else if (value != passwordController.text) {
                                return "Password doesn't match";
                              } else {
                                return null;
                              }
                            },
                          ),*/
                          SizedBox(height: size.height * 0.030),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
