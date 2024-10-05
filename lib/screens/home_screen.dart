import 'dart:convert';
import 'story_screen.dart';
import 'package:flutter/material.dart';
import '../utils/common_utils.dart';
import '../components/appbarwidget.dart';
import 'package:story/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ApiRequest obj = ApiRequest();
  Future<List<UserModel>> fetch() async {
    final newt = await obj.fetchUser(context);
    return newt;
  }

  void initState() {
    fetch();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBarWidgetScreen(
          backgroundColor: Colors.black,
          height: 60,
          title: 'Instagram',
        ),
        body: FutureBuilder<List<UserModel>>(
            future: fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("No data found"),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data![index];
                              // print(post.profilePicture);
                              return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // for ( var a in post.stories)
                                            // print(a.media_url);

                                            Navigator.push(context,MaterialPageRoute(builder:(context)=>StoryScreen( stories: post.stories,userName:post.userName,picture:post.profilePicture)));
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      post.profilePicture))),
                                        ),
                                      ),
                                      Text(
                                        post.userName,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ));
                            }),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
