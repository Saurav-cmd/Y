import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api routes/api_routes.dart';
import '../models/category_model.dart';
import '../utility/dialogue _box.dart';

class Services1 {
  static Future<Category?> getCategory(BuildContext context) async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString("userData");
    if (userData != null) {
      token = jsonDecode(userData)['token'];
    }

    try {
      final apiUrl = ApiRoutes().getCategory();
      final response = await http.get(Uri.parse(apiUrl!), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });
      if (response.statusCode == 200) {
        return categoryFromJson(response.body);
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
}
