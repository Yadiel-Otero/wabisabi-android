//this widget is a simple loading screen that appears until the manga list is loaded

import 'package:flutter/material.dart';

class MangaLoading extends StatelessWidget {
  //const MangaLoading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      ),
    );
  }
}
