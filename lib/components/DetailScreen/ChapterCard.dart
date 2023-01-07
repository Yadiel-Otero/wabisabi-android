import 'package:flutter/material.dart';
import '../CustomText.dart';
import 'package:wabisabi/screens/ContentScreen.dart';

class ChapterCard extends StatelessWidget {
  //final String chapterNumber;
  //final Uri url;

  //ChapterCard({required this.chapterNumber, required this.url});
  @override
  Widget build(BuildContext context) {
     Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => ContentScreen(),
          ),
        ),
      },
      child: Container(
        
        height: 14,
        width: 12,
        color: Colors.amber,
      ),
    );
  }
}
