import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Post> fetchPost() async {
  final response = await http.get('http://hangang.dkserver.wo.tc');

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    return Post.fromJson(json.decode(response.body));
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class Post {
  final String temp;

  Post({this.temp});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      temp: json['temp'],
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Post> post;

  var number_1 = "";
  var number_2 = "";
  var number_3 = "";
  var number_4 = "";
  var number_5 = "";
  var number_6 = "";

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Stack(fit: StackFit.expand, children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/view.png"), fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
        Container(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    margin: const EdgeInsets.only(top: 150),
                    alignment: Alignment.center,
                    child: Text("인생은 한강물 아니면 한강뷰다",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
                Container(
                  height: 80,
                ),
                IconButton(
                    icon: Center(
                        child: Stack(children: [
                      Center(
                          child: Opacity(
                              opacity: 0.4,
                              child: Image.asset("images/water.png"))),
                      Container(
                          alignment: Alignment.center,
                          child: FutureBuilder<Post>(
                            future: post,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data.temp + "℃",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 7),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              // 기본적으로 로딩 Spinner를 보여줍니다.
                              return CircularProgressIndicator();
                            },
                          ))
                    ])),
                    iconSize: 180,
                    onPressed: () {
                      var list = new List<int>.generate(
                          44, (int index) => index + 1); // [0, 1, 4]
                      list.shuffle();

                      setState(() {
                        number_1 = list[0].toString();
                        number_2 = list[1].toString();
                        number_3 = list[2].toString();
                        number_4 = list[3].toString();
                        number_5 = list[4].toString();
                        number_6 = list[5].toString();
                      });
                    }),
                Container(
                  child: Text("클릭"),
                  height: 120,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                          child: Text(number_1),
                          backgroundColor: setColor(int.parse(number_1))),
                      CircleAvatar(
                          child: Text(number_2),
                          backgroundColor: setColor(int.parse(number_2))),
                      CircleAvatar(
                          child: Text(number_3),
                          backgroundColor: setColor(int.parse(number_3))),
                      CircleAvatar(
                          child: Text(number_4),
                          backgroundColor: setColor(int.parse(number_4))),
                      CircleAvatar(
                          child: Text(number_5),
                          backgroundColor: setColor(int.parse(number_5))),
                      CircleAvatar(
                          child: Text(number_6),
                          backgroundColor: setColor(int.parse(number_6))),
                    ]),
              ])),
        ),
      ]),
    );
  }

  Color setColor(int number) {
    if (number <= 10) {
      return Colors.yellow;
    } else if (number <= 20) {
      return Colors.blue;
    } else if (number <= 30) {
      return Colors.red;
    } else if (number <= 40) {
      return Colors.black;
    } else {
      return Colors.green;
    }
  }
}
