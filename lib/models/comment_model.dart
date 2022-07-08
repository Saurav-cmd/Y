// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  String? status;
  Message? message;

  Comment({this.status, this.message});

  Comment.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? id;
  int? categoryId;
  int? userId;
  String? question;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<Answers>? answers;
  int? totalanswers;
  User? user;
  Userprofileimage? userprofileimage;

  Message(
      {this.id,
      this.categoryId,
      this.userId,
      this.question,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.answers,
      this.totalanswers,
      this.user,
      this.userprofileimage});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    question = json['question'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
    totalanswers = json['totalanswers'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userprofileimage = userprofileimage = json['userprofileimage'] != null
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
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    data['totalanswers'] = totalanswers;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userprofileimage != null) {
      data['userprofileimage'] = userprofileimage!.toJson();
    }
    return data;
  }
}

class Answers {
  int? id;
  int? userId;
  int? questionId;
  String? answer;
  String? createdAt;
  String? updatedAt;
  User? user;

  Answers(
      {this.id,
      this.userId,
      this.questionId,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.user});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    questionId = json['question_id'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['question_id'] = questionId;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
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
