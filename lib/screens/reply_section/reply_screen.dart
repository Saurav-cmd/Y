import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y/controllers/category_controller.dart';
import 'package:y/controllers/comment_controller.dart';
import 'package:y/controllers/question_controller.dart';
import 'package:y/screens/reply_section/share_modal_bottom_sheet_design.dart';

import '../../main.dart';
import '../../models/question_model.dart';
import '../../utility/colors.dart';
import 'comments_modal_bottom_sheet_design.dart';

class ReplyScreen extends StatefulWidget {
  const ReplyScreen({Key? key}) : super(key: key);

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  var subscription;
  TextEditingController questionController = TextEditingController();
  TextEditingController replyContainer = TextEditingController();
  CategoryController cC = Get.put(CategoryController());
  QuestionController qC = Get.put(QuestionController());
  CommentController cmntC = Get.put(CommentController());
  double containerHeight = 0.0;
  bool commentButton = false;
  String? selectedCategory;
  int? buttonIndex = -1;
  int? userId;

  getSharedPreferenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      setState(() {
        userId = jsonDecode(userData)["userDetail"]["id"];
      });
    }
  }

  fetchCategoryList() async {
    try {
      final result = await InternetAddress.lookup("example.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return await cC
            .fetchCategoriesList(context)
            .then((value) => null)
            .whenComplete(() {
          setState(() {
            fetchQuestionsList(context);
          });
        });
      }
    } on SocketException catch (_) {
      noWifiConnection1();
    }
  }

  late List<TextEditingController> textControllerList;
  List<int> commentCounter = [];
  List<Questions> postedQuestions = [];
  List<Question?> allPostedQuestion = [];

  fetchQuestionsList(BuildContext context) async {
    postedQuestions.clear();
    allPostedQuestion.clear();
    try {
      return await qC
          .fetchQuestion(context)
          .then((value) => null)
          .whenComplete(() {
        setState(() {
          qC.questionData?.questions;
          filterList();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  filterList() async {
    postedQuestions.clear();
    allPostedQuestion.clear();
    try {
      if (qC.questionData != null) {
        for (int i = 0; i < qC.questionData!.questions!.length; i++) {
          if (selectedCategory != null &&
              qC.questionData!.questions![i].category != null) {
            if (selectedCategory! ==
                qC.questionData!.questions![i].category!.name!) {
              postedQuestions.add(qC.questionData!.questions![i]);
            }
          } else if (selectedCategory == null || selectedCategory!.isEmpty) {
            allPostedQuestion.add(qC.questionData);
            textControllerList = List.generate(
                allPostedQuestion.length, (index) => TextEditingController());
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  fetchComments(int? id, int? index) async {
    return await cmntC.getComments(id, context);
  }

  noWifiConnection1() async {
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
                                  setState(() {
                                    Navigator.pop(context);
                                    fetchCategoryList();
                                  });
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

  @override
  void initState() {
    // TODO: implement initState
    fetchCategoryList();
    getSharedPreferenceData();
    // fetchQuestionsList(context);
    super.initState();
  }

  void commentBottomSheet(
    int? userId,
    int? questionId,
    BuildContext ctx,
  ) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return FractionallySizedBox(
            heightFactor: 1.0,
            child: GestureDetector(
              onTap: () {},
              child: CommentsBottomSheet(
                userId: userId,
                questionId: questionId,
              ),
              behavior: HitTestBehavior.opaque,
            ),
          );
        });
  }

  void shareModalBottomSheet(
    String? title,
    String? description,
    String? name,
    String? category,
    BuildContext ctx,
  ) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: ShareBottomDesign(
              title: title,
              description: description,
              name: name,
              category: category,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questionController.dispose();
    replyContainer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ChooseColor(0).bodyBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ChooseColor(0).redColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
        title: const Text(
          "Forum",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: mediaQueryData.viewInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //yo top ko ask question ko textform field vhayo................................................................................................................
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.030,
                  vertical: size.height * 0.020),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        Navigator.of(context).pushNamed("Ask_question");
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
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
                        hintText: 'Ask Question...',
                        prefixIcon: Image.asset(
                          "images/faq.png",
                          scale: 20,
                        ),
                        hintStyle: TextStyle(
                            fontSize: size.height * 0.012 + size.width * 0.012,
                            color: Colors.black),
                      ),
                      controller: questionController,
                    ),
                  ),
                ],
              ),
            ),
            //yo top ko ask question ko textform field yata samma matra................................................................................................................

            //yo vhana ko category fetch garne vhayo....................................................................................................................................
            Obx(() {
              if (cC.isLoading.value) {
                return LinearProgressIndicator(
                  color: ChooseColor(0).blueColor,
                );
              } else {
                return SizedBox(
                  height: size.height * 0.045,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: cC.category != null
                          ? cC.category!.category!.length
                          : 1,
                      itemBuilder: (ctx, i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.040),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory =
                                    cC.category!.category![i].name;
                              });
                              filterList();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.025),
                                  child: Text(
                                    "${cC.category != null ? cC.category!.category![i].name : "name"}",
                                    style: TextStyle(
                                        color: ChooseColor(0).white,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
            //yo vhana ko category fetch garne ya samma matra....................................................................................................................................

            //yo vhana ko question fetch, description fetch share buton ko view plus data show vhayo....................................................................................
            Obx(() {
              if (qC.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      LinearProgressIndicator(color: ChooseColor(0).blueColor),
                );
              } else {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => fetchQuestionsList(context),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allPostedQuestion.isEmpty
                            ? postedQuestions.length
                            : allPostedQuestion.length,
                        itemBuilder: (ctx, i) {
                          int rIndex = allPostedQuestion.length - 1 - i;
                          int rIndex1 = postedQuestions.length - 1 - i;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.030,
                                vertical: size.height * 0.020),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.030,
                                        vertical: size.height * 0.020),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (allPostedQuestion.isNotEmpty &&
                                            postedQuestions.isEmpty &&
                                            allPostedQuestion[rIndex]!
                                                    .questions![rIndex]
                                                    .userprofileimage !=
                                                null)
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "${allPostedQuestion[rIndex]!.questions![rIndex].userprofileimage!.imagename}"),
                                          ),
                                        if (allPostedQuestion.isNotEmpty &&
                                            allPostedQuestion[rIndex]!
                                                    .questions![rIndex]
                                                    .userprofileimage ==
                                                null)
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "images/Ellipse 3.png"),
                                          ),
                                        if (postedQuestions.isNotEmpty &&
                                            allPostedQuestion.isEmpty &&
                                            postedQuestions[rIndex1]
                                                    .userprofileimage !=
                                                null)
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "${postedQuestions[rIndex1].userprofileimage!.imagename}"),
                                          ),
                                        if (postedQuestions.isNotEmpty &&
                                            postedQuestions[rIndex1]
                                                    .userprofileimage ==
                                                null)
                                          const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "images/Ellipse 3.png"),
                                          ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.020),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    allPostedQuestion.isEmpty
                                                        ? postedQuestions[
                                                                    rIndex1]
                                                                .user!
                                                                .fname! +
                                                            " " +
                                                            postedQuestions[
                                                                    rIndex1]
                                                                .user!
                                                                .lname!
                                                        : allPostedQuestion[
                                                                    rIndex]!
                                                                .questions![
                                                                    rIndex]
                                                                .user!
                                                                .fname! +
                                                            " " +
                                                            allPostedQuestion[
                                                                    rIndex]!
                                                                .questions![
                                                                    rIndex]
                                                                .user!
                                                                .lname!,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                if (allPostedQuestion
                                                        .isNotEmpty &&
                                                    postedQuestions.isEmpty &&
                                                    allPostedQuestion[rIndex]!
                                                            .questions![rIndex]
                                                            .category !=
                                                        null)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCategory =
                                                            allPostedQuestion
                                                                    .isEmpty
                                                                ? postedQuestions[
                                                                        rIndex1]
                                                                    .category!
                                                                    .name
                                                                : allPostedQuestion[
                                                                        rIndex]!
                                                                    .questions![
                                                                        rIndex]
                                                                    .category!
                                                                    .name;
                                                      });
                                                      filterList();
                                                    },
                                                    child: Text(
                                                      "Category:-${allPostedQuestion[rIndex]!.questions![rIndex].category!.name}",
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                if (allPostedQuestion
                                                        .isNotEmpty &&
                                                    allPostedQuestion[rIndex]!
                                                            .questions![rIndex]
                                                            .category ==
                                                        null)
                                                  const Text(
                                                    "Category:- Category Name",
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                if (postedQuestions
                                                        .isNotEmpty &&
                                                    allPostedQuestion.isEmpty &&
                                                    postedQuestions[rIndex1]
                                                            .category !=
                                                        null)
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCategory =
                                                            allPostedQuestion
                                                                    .isEmpty
                                                                ? postedQuestions[
                                                                        rIndex1]
                                                                    .category!
                                                                    .name
                                                                : allPostedQuestion[
                                                                        rIndex]!
                                                                    .questions![
                                                                        rIndex]
                                                                    .category!
                                                                    .name;
                                                      });
                                                      filterList();
                                                    },
                                                    child: Text(
                                                      "Category:-${postedQuestions[rIndex1].category!.name}",
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                if (postedQuestions
                                                        .isNotEmpty &&
                                                    postedQuestions[rIndex1]
                                                            .category ==
                                                        null)
                                                  const Text("Category name")
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            shareModalBottomSheet(
                                                allPostedQuestion.isEmpty
                                                    ? postedQuestions[rIndex1]
                                                        .question
                                                    : allPostedQuestion[rIndex]!
                                                        .questions![rIndex]
                                                        .question,
                                                allPostedQuestion.isEmpty
                                                    ? postedQuestions[rIndex1]
                                                        .description
                                                    : allPostedQuestion[rIndex]!
                                                        .questions![rIndex]
                                                        .description,
                                                allPostedQuestion.isEmpty
                                                    ? postedQuestions[rIndex1].user!.fname! +
                                                        " " +
                                                        postedQuestions[rIndex1]
                                                            .user!
                                                            .lname
                                                            .toString()
                                                    : allPostedQuestion[rIndex]!
                                                            .questions![rIndex]
                                                            .user!
                                                            .fname! +
                                                        " " +
                                                        allPostedQuestion[
                                                                rIndex]!
                                                            .questions![rIndex]
                                                            .user!
                                                            .lname
                                                            .toString(),
                                                allPostedQuestion.isEmpty
                                                    ? postedQuestions[rIndex1]
                                                        .category!
                                                        .name
                                                    : allPostedQuestion[rIndex]!
                                                        .questions![rIndex]
                                                        .category!
                                                        .name,
                                                ctx);
                                          },
                                          icon: Image.asset(
                                            "images/share.png",
                                            color: ChooseColor(0).blueColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.030),
                                    child: Text(
                                      "${allPostedQuestion.isEmpty ? postedQuestions[rIndex1].question : allPostedQuestion[rIndex]!.questions![rIndex].question}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.030,
                                        vertical: size.height * 0.015),
                                    child: Text(
                                        "${allPostedQuestion.isEmpty ? postedQuestions[rIndex1].description : allPostedQuestion[rIndex]!.questions![rIndex].description}"),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.favorite_outline)),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: size.height * 0.015 +
                                                size.width * 0.015),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              commentBottomSheet(
                                                  userId,
                                                  allPostedQuestion.isEmpty
                                                      ? postedQuestions[rIndex1]
                                                          .id
                                                      : allPostedQuestion[
                                                              rIndex]!
                                                          .questions![rIndex]
                                                          .id,
                                                  context);
                                              commentButton = !commentButton;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.mode_comment_sharp,
                                            color: ChooseColor(0).blueColor,
                                          )),
                                      Text(
                                        "${allPostedQuestion.isEmpty ? postedQuestions[rIndex1].totalanswers : allPostedQuestion[rIndex]!.questions![rIndex].totalanswers}",
                                        style: TextStyle(
                                            fontSize: size.height * 0.015 +
                                                size.width * 0.015),
                                      )
                                    ],
                                  ),
                                  Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * 0.010),
                                      child: Row(
                                        children: [
                                          if (allPostedQuestion.isNotEmpty &&
                                              postedQuestions.isEmpty &&
                                              allPostedQuestion[rIndex]!
                                                      .questions![rIndex]
                                                      .userprofileimage !=
                                                  null)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.030),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "${allPostedQuestion[rIndex]!.questions![rIndex].userprofileimage!.imagename}"),
                                              ),
                                            ),
                                          if (allPostedQuestion.isNotEmpty &&
                                              allPostedQuestion[rIndex]!
                                                      .questions![rIndex]
                                                      .userprofileimage ==
                                                  null)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.030),
                                              child: const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "images/Ellipse 3.png"),
                                              ),
                                            ),
                                          if (postedQuestions.isNotEmpty &&
                                              allPostedQuestion.isEmpty &&
                                              postedQuestions[rIndex1]
                                                      .userprofileimage !=
                                                  null)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.030),
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "${postedQuestions[rIndex1].userprofileimage!.imagename}"),
                                              ),
                                            ),
                                          if (postedQuestions.isNotEmpty &&
                                              postedQuestions[rIndex1]
                                                      .userprofileimage ==
                                                  null)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * 0.030),
                                              child: const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "images/Ellipse 3.png"),
                                              ),
                                            ),
                                          SizedBox(width: size.width * 0.030),
                                          Expanded(
                                            child: Form(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical:
                                                              size.height *
                                                                  0.001,
                                                          horizontal:
                                                              size.width *
                                                                  0.030),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                  // labelText: 'Phone Number',
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: 'Reply...',
                                                  hintStyle: TextStyle(
                                                      fontSize: size.height *
                                                              0.012 +
                                                          size.width * 0.012,
                                                      color: Colors.black),
                                                ),
                                                controller:
                                                    textControllerList[i],
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Write Something";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Obx(() {
                                            if (cmntC.isLoading.value &&
                                                buttonIndex == i) {
                                              return CircularProgressIndicator(
                                                  color:
                                                      ChooseColor(0).blueColor);
                                            } else {
                                              return IconButton(
                                                onPressed: () {
                                                  if (textControllerList[i]
                                                      .text
                                                      .isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content: Text(
                                                          "Write Something"),
                                                      duration:
                                                          Duration(seconds: 1),
                                                    ));
                                                  } else {
                                                    buttonIndex = i;
                                                    //here hai
                                                    cmntC.writeComments(
                                                        userId,
                                                        allPostedQuestion
                                                                .isEmpty
                                                            ? postedQuestions[
                                                                    rIndex1]
                                                                .id
                                                            : allPostedQuestion[
                                                                    rIndex]!
                                                                .questions![
                                                                    rIndex]
                                                                .id,
                                                        textControllerList[i]
                                                            .text,
                                                        context);
                                                    textControllerList[i].text =
                                                        "";
                                                    Navigator.of(context)
                                                        .focusScopeNode
                                                        .unfocus();
                                                  }
                                                },
                                                icon: const Icon(Icons.send),
                                                color: ChooseColor(0).blueColor,
                                              );
                                            }
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            }),
            //yo vhana ko question fetch, description fetch share buton ko view plus data show ya samma matra....................................................................................
          ],
        ),
      ),
    );
  }
}
