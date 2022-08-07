/*
  --------------------------------------------------------------------------------
  | THE MAIN.DART FILE IS USED FOR CONTROLLING THE SCREEN SWITCHES AND ALL THE   |                                                                           
  | OTHER DEFAULT THINGS LIKE RUNNING THE APP, ETC...                            |
  |...                                                                           |
  |   ...                                                                        |   
  |      ...                                                                     |
  --------------------------------------------------------------------------------
 
*/
import 'package:flutter/material.dart';
import 'package:wabisabi/components/DetailScreen/ChapterCard.dart';
import '/screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomeScreen(),
    );
  }
}

