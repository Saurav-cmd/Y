import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:y/models/question_model.dart';
import 'package:y/services/services.dart';

class QuestionController extends GetxController {
  var isLoading = false.obs;
  Question? questionData;

  Future<void> postQuestion(String? question, int? categoryId,
      String? description, BuildContext context) async {
    try {
      isLoading(true);
      return await Services.postQuestion(
          question, categoryId, description, context);
    } finally {
      isLoading(false);
    }
  }

  Future<Question?> fetchQuestion(BuildContext context) async {
    try {
      log("ya aayo hai");
      isLoading(true);
      final questions = await Services.getQuestion(context);
      questionData = questions;
      log("this is question data ${questionData!.questions![0].question}");
      return questionData;
    } finally {
      update();
      isLoading(false);
    }
  }
}
