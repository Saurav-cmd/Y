import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/comment_controller.dart';

class CommentsBottomSheet extends StatefulWidget {
  CommentsBottomSheet({Key, this.userId, this.questionId, key})
      : super(key: key);
  int? userId;
  int? questionId;
  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  int? passedUserId;
  int? passedQuestionId;
  CommentController cmntC = Get.put(CommentController());
  TextEditingController replyController = TextEditingController();

  fetchComments() async {
    return await cmntC.getComments(passedQuestionId, context);
  }

  @override
  void initState() {
    // TODO: implement initState
    passedUserId = widget.userId;
    passedQuestionId = widget.questionId;
    setState(() {
      fetchComments();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    replyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("This is userId $passedUserId");
    log("This is passed post Id $passedQuestionId");
    final size = MediaQuery.of(context).size;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            if (cmntC.isLoading1.value) {
              return const Expanded(child: LinearProgressIndicator());
            } else {
              return Expanded(
                child: SizedBox(
                    child: RefreshIndicator(
                  onRefresh: () async => fetchComments(),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cmntC.commentData!.message!.answers!.length,
                      itemBuilder: (ctx, j) {
                        return cmntC.commentData!.message!.answers == null
                            ? const Text("No Comments to show")
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "images/Ellipse 3.png"),
                                        ),
                                        SizedBox(width: size.width * 0.015),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cmntC
                                                        .commentData!
                                                        .message!
                                                        .answers![j]
                                                        .user!
                                                        .fname! +
                                                    " " +
                                                    cmntC
                                                        .commentData!
                                                        .message!
                                                        .answers![j]
                                                        .user!
                                                        .lname!,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${cmntC.commentData!.message!.answers![j].answer}",
                                                overflow: TextOverflow.clip,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      }),
                )),
              );
            }
          }),
          TextFormField(
            decoration: InputDecoration(
                hintText: "Write Something..",
                filled: true,
                fillColor: Colors.grey.shade300,
                suffixIcon: TextButton(
                    onPressed: () {
                      cmntC.writeComments(passedUserId, passedQuestionId,
                          replyController.text, context);
                      replyController.text = "";
                      setState(() {
                        cmntC.getComments(passedQuestionId, context);
                      });
                      Navigator.of(context).focusScopeNode.unfocus();
                    },
                    child: const Text("Send"))),
            controller: replyController,
            validator: (value) {
              if (value == null) {
                return "Write Something";
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
