import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:y/controllers/auth_controller.dart';
import 'package:y/controllers/comment_controller.dart';
import 'package:y/controllers/profile_controller.dart';
import 'package:y/controllers/question_controller.dart';

import '../controllers/category_controller.dart';
import '../main.dart';
import 'colors.dart';

class AlertDialogueBox {
  loginAlertBox1(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text('Invalid Phone Number and password'),
                actions: [
                  SizedBox(
                    height: 40.0,
                    width: 80.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ChooseColor(0).blueColor),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: const Text('Edit')),
                  ),
                ],
              ),
            ));
  }

  loginAlertBox2(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text(
                  "Bad request",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                actions: [
                  SizedBox(
                    height: 40.0,
                    width: 80.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ChooseColor(0).blueColor),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("OK"),
                    ),
                  )
                ],
              ),
            ));
  }

  loginAlertBox3(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: const Text(
                  "Invalid email address or password",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                actions: [
                  SizedBox(
                    height: 40.0,
                    width: 80.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ChooseColor(0).blueColor),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("OK"),
                    ),
                  )
                ],
              ),
            ));
  }

  loginServerError(BuildContext context) {
    Widget AbortButton = TextButton(
        onPressed: () async {
          SystemNavigator.pop();
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.31,
          color: ChooseColor(0).blueColor,
          child: Center(
            child: Text(
              'Abort'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));

    Widget RetryButton = TextButton(
        onPressed: () {},
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.31,
          color: ChooseColor(0).blueColor,
          child: Center(
            child: Text(
              'Retry'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: const [
            Text(
              'Unexpected error on Server',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Image(
              image: AssetImage(
                'icons/cloud_error_3.png',
              ),
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
      content: const Padding(
        padding: EdgeInsets.only(left: 40.0, right: 30, top: 10),
        child: Text(
          "Please contact your service provider",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
      //Text("Are you sure to Place your Order ?"),
      actions: [
        AbortButton,
        RetryButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  serverError(BuildContext context) {
    AuthController aC = Get.put(AuthController());
    Widget AbortButton = TextButton(
        onPressed: () async {
          SystemNavigator.pop();
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.31,
          color: ChooseColor(0).blueColor,
          child: Center(
            child: Text(
              'Abort'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ));

    Widget RetryButton = TextButton(
        onPressed: () {
          aC.logout(context);
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.31,
          color: ChooseColor(0).blueColor,
          child: Center(
            child: Text(
              'Ok'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              Text(
                'Unexpected error on Server',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Image(
                image: AssetImage(
                  'images/server.png',
                ),
                height: 60,
                width: 60,
              ),
            ],
          ),
        ),
      ),
      content: const Padding(
        padding: EdgeInsets.only(left: 40.0, right: 30, top: 10),
        child: Text(
          "Please contact your service provider",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
      //Text("Are you sure to Place your Order ?"),
      actions: [
        AbortButton,
        RetryButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  universalAlertBox(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => Align(
              alignment: Alignment.center,
              child: WillPopScope(
                onWillPop: () async => false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: AlertDialog(
                    title: const Text(
                      "Some Unexpected error occurred",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    actions: [
                      SizedBox(
                        height: 40.0,
                        width: 80.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("OK"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  noWifiConnection(
      int? num,
      String? name,
      String? email,
      String? address,
      String? contact,
      File? galleryImage,
      String? password,
      String? confirmPassword,
      String? question,
      String? description,
      int? categoryId,
      BuildContext context) async {
    ProfileController pC = Get.put(ProfileController());
    CategoryController cC = Get.put(CategoryController());
    QuestionController qC = Get.put(QuestionController());
    CommentController cmntC = Get.put(CommentController());
    AuthController aC = Get.put(AuthController());
    log("This is question $question");
    log("this is category id $categoryId");
    log("this is description $description");
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: const Text(
                          "No Internet Connection",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Image.asset("images/network.png")),
                    Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                        child: const Text(
                          "Please check your internet connection",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              SystemNavigator.pop();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: ChooseColor(0).blueColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "Abort",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup("example.com");
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  if (num == 1) {
                                    Navigator.pop(context);
                                  } else if (num == 2) {
                                    Navigator.pop(context);
                                  } else if (num == 3) {
                                    Navigator.pop(context);
                                    /*await pC.editUserProfile(
                                        name,
                                        email,
                                        address,
                                        contact,
                                        galleryImage,
                                        password,
                                        confirmPassword,
                                        context);*/
                                  } else if (num == 4) {
                                    try {
                                      //multiple program ma background ma eakaichoti run gara ko ho
                                      Navigator.pop(context);
                                      Future.wait({
                                        qC.fetchQuestion(context),
                                        cC.fetchCategoriesList(context),
                                      });

                                      /*  var receiverPoint = ReceivePort();
                                      var receiverPoint1 = ReceivePort();
                                      */ /*  await Isolate.spawn((message) {
                                        cC.fetchCategoriesList(context);
                                      }, receiverPoint.sendPort);*/ /*

                                      await Isolate.spawn((message) {
                                        cC.fetchCategoriesList(context);
                                        qC.fetchQuestion(context);
                                      }, "hello");
                                      */ /*  await Isolate.spawn((message) {
                                        qC.fetchQuestion(context);
                                      }, receiverPoint1.sendPort);*/
                                    } catch (e) {
                                      rethrow;
                                    }
                                  } else if (num == 5) {
                                    Navigator.pop(context);
                                    /* await qC.postQuestion(question, categoryId,
                                        description, context);*/
                                  } else if (num == 6) {
                                    Navigator.pop(context);
                                  } else if (num == 7) {
                                    Navigator.pop(context);
                                    //yesma category id ma chai maila post ko id pass gardya ko xu
                                    cmntC.getComments(categoryId, context);
                                  } else if (num == 8) {
                                    Navigator.pop(context);
                                    aC.forgotPassword(email, context);
                                  } else if (num == 9) {
                                    Navigator.pop(context);
                                  }
                                }
                              } on SocketException catch (_) {
                                final SnackBar snackBar = SnackBar(
                                  content: const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'No Internet Connection',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.red),
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: Colors.white,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                );
                                snackBarKey.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: ChooseColor(0).blueColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    // Navigator.of(context).pop();
  }

  alertBox403(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => Align(
              alignment: Alignment.center,
              child: WillPopScope(
                onWillPop: () async => false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: AlertDialog(
                    title: const Text(
                        'access to the requested resource is forbidden'),
                    actions: [
                      SizedBox(
                        height: 40.0,
                        width: 80.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                            child: const Text('Ok')),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  alertBox400(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => Align(
              alignment: Alignment.center,
              child: WillPopScope(
                onWillPop: () async => false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: AlertDialog(
                    title: const Text('Bad Request'),
                    actions: [
                      SizedBox(
                        height: 40.0,
                        width: 80.0,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                            child: const Text('Ok')),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  alertBox401(BuildContext context) {
    AuthController aC = Get.put(AuthController());
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AlertDialog(
                      title: const Text(
                        'UnAuthorized User',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      actions: [
                        SizedBox(
                          height: 40.0,
                          width: 90.0,
                          child: ElevatedButton(
                            onPressed: () {
                              aC.logout(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor,
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  registerAlertBox422(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AlertDialog(
                      title: const Text(
                        'The email has already been taken',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      actions: [
                        SizedBox(
                          height: 40.0,
                          width: 90.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor,
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  forgotPasswordAlertBox422(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AlertDialog(
                      title: const Text(
                        'Email address not registered',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      actions: [
                        SizedBox(
                          height: 40.0,
                          width: 90.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor,
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  universalAlertBox422(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AlertDialog(
                      title: const Text(
                        'Invalid Email Address',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      actions: [
                        SizedBox(
                          height: 40.0,
                          width: 90.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor,
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  alertBox405(BuildContext context) {
    AuthController aC = Get.put(AuthController());
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AlertDialog(
                      title: const Text(
                        'Login Expire',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      actions: [
                        SizedBox(
                          height: 40.0,
                          width: 90.0,
                          child: ElevatedButton(
                            onPressed: () {
                              aC.logout(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ChooseColor(0).blueColor,
                              shape: RoundedRectangleBorder(
                                  //to set border radius to button
                                  borderRadius: BorderRadius.circular(1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
