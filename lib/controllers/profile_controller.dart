import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:y/services/services.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  Future<void> editUserProfile(
      String? fName,
      String? lName,
      String? email,
      String? address,
      String? contact,
      File? galleryImage,
      String? password,
      String? confirmPassword,
      BuildContext context) async {
    print("name :- $fName");
    log("lName :- $lName");
    print("email :- $email");
    print("address :- $address");
    print("contact :- $contact");
    print("password :- $password");
    print("confirmPassword :- $confirmPassword");
    try {
      isLoading(true);
      return await Services.editProfile(fName, lName, email, address, contact,
          galleryImage, password, confirmPassword, context);
    } finally {
      isLoading(false);
    }
  }
}
