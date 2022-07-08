import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/screens/profile_screen/edit_profile_screen.dart';
import 'package:y/utility/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController aC = Get.put(AuthController());

  String fName = "";
  String lName = "";
  String? address;
  String? email;
  String? phone;
  getSharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      setState(() {
        fName = jsonDecode(userData)['userDetail']['fname'];
        lName = jsonDecode(userData)['userDetail']['lname'];
        address = jsonDecode(userData)['userDetail']['address'];
        email = jsonDecode(userData)["userDetail"]["email"];
        phone = jsonDecode(userData)["userDetail"]["contact"];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferenceData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ChooseColor(0).bodyBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ChooseColor(0).pinkColor,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.050,
                  vertical: size.height * 0.030),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const CircleAvatar(
                    maxRadius: 50,
                    backgroundImage: AssetImage("images/Ellipse 3.png"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: size.width * 0.020),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fName + " " + lName,
                            style: TextStyle(
                                fontSize:
                                    size.height * 0.016 + size.width * 0.016,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            "$address",
                            style: TextStyle(
                              fontSize:
                                  size.height * 0.016 + size.width * 0.016,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => EditProfileScreen(
                                  fName: fName,
                                  lName: lName,
                                  address: address,
                                  email: email,
                                  phoneNumber: phone,
                                )));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: size.height * 0.020 + size.width * 0.020,
                      ))
                ],
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: size.width * 0.050),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.asset("images/QuestionCircle.png"),
                      title: Text(
                        "Help and Support",
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ListTile(
                      leading: Image.asset("images/Gear.png"),
                      title: Text(
                        "Settings",
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ListTile(
                      leading: Image.asset("images/ShieldLock.png"),
                      title: Text(
                        "Security",
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ListTile(
                      leading: Image.asset("images/InfoCircle.png"),
                      title: Text(
                        "App Info",
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    ListTile(
                      leading: Image.asset("images/Power.png"),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                            fontSize: size.height * 0.014 + size.width * 0.014),
                      ),
                      onTap: () {
                        aC.logout(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
