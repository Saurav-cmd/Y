import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:y/models/comment_model.dart';

import '../services/services.dart';

class CommentController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  RxList counter = [].obs;
  Comment? commentData;

  Future<void> writeComments(int? userId, int? questionId, String? answer,
      BuildContext context) async {
    try {
      isLoading(true);
      log("This is userId $userId");
      log("this is questionId $questionId");
      log("this is answer $answer");
      return await Services.writeComment(userId, questionId, answer, context);
    } finally {
      isLoading(false);
    }
  }

  Future<Comment?> getComments(int? id, BuildContext context) async {
    try {
      isLoading1(true);
      final data = await Services.getCommentReplies(id, context);
      commentData = data;
      return commentData;
    } finally {
      isLoading1(false);
    }
  }

  void commentCounter() {
    counter.clear();
    counter.add(commentData!.message!.answers!.length);
    log("This comment counter $counter");
  }
}
