import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y/api%20routes/api_routes.dart';
import 'package:y/utility/dialogue%20_box.dart';

import '../models/comment_model.dart';
import '../models/question_model.dart';

class Services {
  static Future<void> loginUser(
      String? email, String? password, BuildContext context) async {
    try {
      EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
      EasyLoading.instance.backgroundColor = Colors.black45;
      EasyLoading.instance.maskType = EasyLoadingMaskType.black;
      EasyLoading.instance.maskColor = Colors.blue.withOpacity(0.5);
      EasyLoading.show(status: "Logging In....");

      final Map<String, String> jsonBody = {
        "email": email!,
        "password": password!
      };

      final apiUrl = ApiRoutes().login(email, password);
      final response = await http.post(Uri.parse(apiUrl!),
          headers: {
            "Accept": "application/json",
          },
          body: jsonBody);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userData = jsonEncode({
          "token": data["access_token"],
          "token_type": data["token_type"],
          "expires_in": data["expires_in"],
          "userDetail": data["user"]
        });
        prefs.setString("userData", userData);
        EasyLoading.dismiss();
        Navigator.of(context).pushReplacementNamed("Home_screen");
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().loginAlertBox1(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().loginAlertBox2(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().loginAlertBox3(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().loginServerError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().loginServerError(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }

  static Future<void> registerUser(
      String? fName,
      String? lName,
      String? email,
      String? address,
      String? contact,
      String? password,
      String? confirmPassword,
      BuildContext context) async {
    try {
      EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
      EasyLoading.instance.backgroundColor = Colors.black45;
      EasyLoading.instance.maskType = EasyLoadingMaskType.black;
      EasyLoading.instance.maskColor = Colors.blue.withOpacity(0.5);
      EasyLoading.show(status: "Please wait....");

      final Map<String, String> jsonBody = {
        "fname": fName!,
        "lname": lName!,
        "email": email!,
        "address": address!,
        "contact": contact!,
        "password": password!,
        "confirmation_password": confirmPassword!
      };

      String? apiUrl = ApiRoutes().register();
      final response = await http.post(Uri.parse(apiUrl!),
          headers: {
            "Accept": "application/json",
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.of(context).pushReplacementNamed("Login_screen");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful")));
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();
        AlertDialogueBox().registerAlertBox422(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      AlertDialogueBox().noWifiConnection(
          2, "", "", "", "", null, "", "", "", "", null, context);
    }
  }

  static Future<void> editProfile(
      String? fName,
      String? lName,
      String? email,
      String? address,
      String? contact,
      File? galleryImage,
      String? password,
      String? confirmPassword,
      BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }
    try {
      EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
      EasyLoading.instance.backgroundColor = Colors.black45;
      EasyLoading.instance.maskType = EasyLoadingMaskType.black;
      EasyLoading.instance.maskColor = Colors.blue.withOpacity(0.5);
      EasyLoading.show(status: "Please wait....");

      final apiUrl = ApiRoutes().editProfile();
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.parse(apiUrl!));
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token"
      };

      if (galleryImage != null) {
        FileImage(File(galleryImage.path.toString())).file.readAsBytesSync();
        request.files.add(await http.MultipartFile.fromPath(
            'image', galleryImage.path,
            contentType: MediaType("image", "jpeg")));
      } else {
        null;
      }

      request.headers.addAll(headers);
      request.fields['fname'] = fName!;
      request.fields['lname'] = lName!;
      request.fields['address'] = address!;
      request.fields['contact'] = contact!;
      request.fields['email'] = email!;
      request.fields['_method'] = "PATCH";
      request.fields['password'] = password!;
      request.fields['confirmation_password'] = confirmPassword!;

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((event) {});

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Profile edited successfully',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ));
        Navigator.pop(context);
        // Navigator.of(context).pushReplacementNamed("Profile_screen");
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox405(context);
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox422(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }

  static Future<void> postQuestion(String? question, int? categoryId,
      String? description, BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }

    try {
      EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
      EasyLoading.instance.backgroundColor = Colors.black45;
      EasyLoading.instance.maskType = EasyLoadingMaskType.black;
      EasyLoading.instance.maskColor = Colors.blue.withOpacity(0.5);
      EasyLoading.show(status: "Posting please wait....");
      final apiUrl = ApiRoutes().postQuestion();
      final Map<String, String> jsonBody = {
        "question": question!,
        "category_id": categoryId.toString(),
        "description": description!,
      };
      final response = await http.post(Uri.parse(apiUrl!),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              'Question posted successfully',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ));
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox405(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }

  static Future<Question?> getQuestion(BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }

    try {
      final apiUrl = ApiRoutes().getQuestion();
      final response = await http.get(Uri.parse(apiUrl!), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        return questionFromJson(response.body);
      } else if (response.statusCode == 403) {
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        AlertDialogueBox().alertBox405(context);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> writeComment(int? userId, int? questionId, String? answer,
      BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }

    try {
      final apiUrl = ApiRoutes().writeComment();
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.parse(apiUrl!));
      Map<String, String> headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token"
      };

      request.headers.addAll(headers);
      request.fields['user_id'] = userId.toString();
      request.fields['question_id'] = questionId.toString();
      request.fields['answer'] = answer!;

      http.StreamedResponse response = await request.send();
      response.stream.transform(utf8.decoder).listen((event) {});

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Comment posted successfully"),
          duration: Duration(seconds: 1),
        ));
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox405(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      AlertDialogueBox().noWifiConnection(
          6, "", "", "", "", null, "", "", "", "", null, context);
      rethrow;
    }
  }

  static Future<Comment?> getCommentReplies(
      int? id, BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }
    try {
      final apiUrl = ApiRoutes().getComment(id);
      final response = await http.get(Uri.parse(apiUrl!), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        return commentFromJson(response.body);
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox405(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      AlertDialogueBox().noWifiConnection(
          7, "", "", "", "", null, "", "", "", "", id, context);
      rethrow;
    }
    return null;
  }

  static Future<void> forgetPassword(
      String? email, BuildContext context) async {
    try {
      final apiUrl = ApiRoutes().forgetPassword();
      Map<String, String> jsonBody = {"email": email!};
      final response = await http.post(Uri.parse(apiUrl!), body: jsonBody);
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed("Login_screen");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password Reset link has been sent to your mail")));
      } else if (response.statusCode == 403) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox403(context);
      } else if (response.statusCode == 400) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox400(context);
      } else if (response.statusCode == 401) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox401(context);
      } else if (response.statusCode == 422) {
        EasyLoading.dismiss();
        AlertDialogueBox().forgotPasswordAlertBox422(context);
      } else if (response.statusCode == 500) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 503) {
        EasyLoading.dismiss();
        AlertDialogueBox().serverError(context);
      } else if (response.statusCode == 405) {
        EasyLoading.dismiss();
        AlertDialogueBox().alertBox405(context);
      } else {
        EasyLoading.dismiss();
        AlertDialogueBox().universalAlertBox(context);
      }
    } catch (e) {
      EasyLoading.dismiss();
      AlertDialogueBox().noWifiConnection(
          8, "", email, "", "", null, "", "", "", "", null, context);
    }
  }
}
