import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_color_utilities/utils/color_utils.dart';

import 'package:story/models/story.dart';
import 'package:http/http.dart' as http;
import 'package:story/utils/common_utils.dart';

class UserModel {
  final int userId;
  final String userName;
  final String profilePicture;
  final List<StoryModel> stories;

  UserModel(
      {required this.userId,
      required this.userName,
      required this.profilePicture,
      required this.stories});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var storiesList = json['stories'] as List;
    List<StoryModel> stories = storiesList
        .map((storyModelJson) => StoryModel.fromJson(storyModelJson))
        .toList();

    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      profilePicture: json['profile_picture'],
      stories: stories,
    );
  }
}

class ApiRequest {
  Future<List<UserModel>> fetchUser(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse('https://ixifly.in/flutter/task2'));
      Map<String, dynamic> responseJson = json.decode(response.body);
      List<dynamic> result = responseJson['data'];

      // print(result);
      List<UserModel> ans=parseFetchPropertyData(result);
      return ans;




    } catch (e) {
      // return showAlertToast(msg: 'Unable to refresh feed.Please Try again later !');
      throw Exception('Unable to fetch user data : ${e.toString()}');
    }
  }

  List<UserModel> parseFetchPropertyData(List<dynamic> responseBody){
    List<UserModel> obj=responseBody.map<UserModel>((json)=>UserModel.fromJson(json)).toList();

    return obj;
  }
}
