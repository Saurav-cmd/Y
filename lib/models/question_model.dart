// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  String? status;
  List<Questions>? questions;

  Question({this.status, this.questions});

  Question.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (questions != null) {
      data['questions'] = questions?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  int? categoryId;
  int? userId;
  String? question;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? totalanswers;
  Category? category;
  User? user;
  Userprofileimage? userprofileimage;

  Questions(
      {this.id,
      this.categoryId,
      this.userId,
      this.question,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.totalanswers,
      this.category,
      this.user,
      this.userprofileimage});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    question = json['question'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalanswers = json['totalanswers'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userprofileimage = json['userprofileimage'] != null
        ? Userprofileimage.fromJson(json['userprofileimage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['question'] = question;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['totalanswers'] = totalanswers;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userprofileimage != null) {
      data['userprofileimage'] = userprofileimage!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  Category({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  int? id;
  String? fname;
  String? lname;
  String? contact;
  String? address;
  String? email;
  Null emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;

  User(
      {this.id,
      this.fname,
      this.lname,
      this.contact,
      this.address,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fname = json['fname'];
    lname = json['lname'];
    contact = json['contact'];
    address = json['address'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fname'] = fname;
    data['lname'] = lname;
    data['contact'] = contact;
    data['address'] = address;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Userprofileimage {
  int? id;
  int? userId;
  String? imagename;
  String? createdAt;
  String? updatedAt;

  Userprofileimage(
      {this.id, this.userId, this.imagename, this.createdAt, this.updatedAt});

  Userprofileimage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    imagename = json['imagename'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['imagename'] = imagename;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
