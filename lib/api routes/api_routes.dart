import 'package:y/utility/constants.dart';

class ApiRoutes {
  String? login(String? email, String? password) {
    return Constant.baseUrl + "login?email=$email&password=$password";
  }

  String? register() {
    return Constant.baseUrl + "register";
  }

  String? editProfile() {
    return Constant.baseUrl + "profile";
  }

  String? getCategory() {
    return Constant.baseUrl + "category";
  }

  String? postQuestion() {
    return Constant.baseUrl + "forum";
  }

  String? getQuestion() {
    return Constant.baseUrl + "forum";
  }

  String? writeComment() {
    return Constant.baseUrl + "answers";
  }

  String? getComment(int? id) {
    return Constant.baseUrl + "answers/$id";
  }

  String? forgetPassword(){
    return Constant.baseUrl+"forget-password";
  }
}
