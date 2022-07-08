import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y/controllers/question_controller.dart';
import 'package:y/utility/colors.dart';

import '../../controllers/category_controller.dart';

class AskQuestion extends StatefulWidget {
  const AskQuestion({Key? key}) : super(key: key);

  @override
  State<AskQuestion> createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController questionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  CategoryController cC = Get.put(CategoryController());
  QuestionController qC = Get.put(QuestionController());
  int? selectedId;
  String? selectedCategory;
  String fName = "";
  String lName = "";

  getSharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      setState(() {
        fName = jsonDecode(userData)["userDetail"]["fname"];
        lName = jsonDecode(userData)["userDetail"]["lname"];
      });
    }
  }

  void modalBottomSheet(
    BuildContext ctx,
  ) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.020),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() {
                    if (cC.isLoading.value) {
                      return const LinearProgressIndicator();
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cC.category!.category!.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedId = cC.category!.category![i].id;
                                      selectedCategory =
                                          cC.category!.category![i].name;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Text(
                                                  " ${cC.category!.category![i].name}",
                                                  style: TextStyle(
                                                      color: ChooseColor(0)
                                                          .blueColor,
                                                      fontSize: size.height *
                                                              0.014 +
                                                          size.width * 0.014),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  })
                ],
              ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreferenceData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questionController.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ChooseColor(0).bodyBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.020,
                  horizontal: size.width * 0.030),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.020),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                            height: size.height * 0.050,
                            width: size.width * 0.050,
                            child: Image.asset("images/close.png"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedId == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'Select Category',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ));
                              } else {
                                try {
                                  final result = await InternetAddress.lookup(
                                      "example.com");
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    qC.postQuestion(
                                        titleController.text,
                                        selectedId,
                                        questionController.text,
                                        context);

                                    titleController.text = "";
                                    questionController.text = "";
                                    Navigator.of(context)
                                        .focusScopeNode
                                        .unfocus();
                                  }
                                } on SocketException catch (_) {
                                  Fluttertoast.showToast(
                                      msg: "No Wifi connection",
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT);
                                  /* AlertDialogueBox().noWifiConnection(
                                      5,
                                      "",
                                      "",
                                      "",
                                      "",
                                      null,
                                      "",
                                      "",
                                      titleController.text,
                                      questionController.text,
                                      selectedId,
                                      context);*/
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Post",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: ChooseColor(0).pinkColor,
                              enableFeedback: true),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(height: size.height * 0.010),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("images/Ellipse 3.png"),
                        maxRadius: 30,
                      ),
                      SizedBox(width: size.width * 0.020),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fName + " " + lName,
                              style: TextStyle(
                                  fontSize:
                                      size.height * 0.015 + size.width * 0.015,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              selectedCategory ?? "",
                              style: TextStyle(
                                  fontSize:
                                      size.height * 0.015 + size.width * 0.015,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.050),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            maxLines: 1,
                            controller: titleController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Question Title",
                                hintStyle: TextStyle(
                                    fontSize: size.height * 0.015 +
                                        size.width * 0.015)),
                            onChanged: (value) {
                              if (titleController.text.isNotEmpty) {
                                titleController.text =
                                    "${titleController.text[0].toUpperCase()}${titleController.text.substring(1)}";
                                titleController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: titleController.text.length));
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please give some title to your question";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.030),
                          Container(
                            width: double.infinity,
                            height: size.height * 0.2,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                maxLines: 10,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "Ask your question here with 'How', 'What', 'Why'",
                                    hintStyle: TextStyle(
                                        fontSize: size.height * 0.015 +
                                            size.width * 0.015)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please give some description to your question";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: questionController,
                                onChanged: (value) {
                                  if (questionController.text.isNotEmpty) {
                                    questionController.text =
                                        "${questionController.text[0].toUpperCase()}${questionController.text.substring(1)}";
                                    questionController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: questionController
                                                .text.length));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => modalBottomSheet(context),
            child: const Icon(Icons.more_horiz),
            backgroundColor: ChooseColor(0).pinkColor,
          ),
        ),
      ),
    );
  }
}
