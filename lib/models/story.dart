import 'dart:convert';
import 'package:http/http.dart' as http;

class StoryModel{
  final int story_id;
  final String media_url;
  final String media_type;
  final String timestamp;
  final String text;
  final String text_description;

  StoryModel({
    required this.story_id,
    required this.media_type,
    required this.media_url,
    required this.text,
    required this.text_description,
    required this.timestamp
});

  factory StoryModel.fromJson(Map<String,dynamic> json){
    return StoryModel(
      story_id: json['story_id'],
      media_type: json['media_type'],
      text: json['text'],
      timestamp: json['timestamp'],
      text_description: json['text_description'],
      media_url: json['media_url']
    );
  }
  // void fetchStories() async{
  //
  //   final response=await http.get(
  //     Uri.parse('https://ixifly.in/flutter/task2'),
  //
  //   );
  //   print(response);

  // Map<String,dynamic> toJson(){
  //   return {
  //     'story_id':story_id,
  //     'media_url':media_url,
  //     'timestamp':timestamp,
  //     'media_type':media_type,
  //     'text_description':text_description,
  //     'text':text
  //   };
  // }
}

