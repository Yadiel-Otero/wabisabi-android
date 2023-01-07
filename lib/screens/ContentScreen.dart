import 'package:flutter/material.dart';
import 'package:wabisabi/components/HomeScreen/MangaLoading.dart';
import '../constants/constants.dart';
import 'package:web_scraper/web_scraper.dart';

class ContentScreen extends StatefulWidget {
  //ContentScreen({Key? key}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
              height: screenSize.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < 6; i++)
                      Image.network('https://cdn.pixabay.com/photo/2014/06/03/19/38/road-sign-361514_640.png')
                  ],
                ),
              ),
            )
    );
  }
}
