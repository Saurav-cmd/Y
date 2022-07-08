import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:y/models/category_model.dart';
import 'package:y/services/services1.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  Category? category;
  Future<Category?> fetchCategoriesList(BuildContext context) async {
    try {
      isLoading(true);
      final categoryData = await Services1.getCategory(context);
      category = categoryData;
      return category;
    } finally {
      isLoading(false);
    }
  }
}
