import 'package:flutter/material.dart';
import '../components/homeScreen/MangaCard.dart';
import '../constants/constants.dart';
import '../components/CustomText.dart';

class DetailScreen extends StatelessWidget {
  //const DetailScreen({Key? key}) : super(key: key);
  final String mangaImg;
  final String mangaTitle;
  final Uri url;

  DetailScreen(
      {required this.mangaImg, required this.mangaTitle, required this.url}) {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.black,
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        color: Constants.black,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: [
              //image, title, add to favorite button
              Container(
                color: Colors.red,
                height: 400,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      //color: Colors.pink,
                      height: 250,
                      width: 150,
                      margin: EdgeInsets.only(
                        left: 15,
                        top: 70,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          mangaImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.pink,
                      height: 110,
                      width: 170,
                      margin: EdgeInsets.only(
                        left: 25,
                        top: 180,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 19,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.bottomLeft,
                              child: CustomText(
                                text: mangaTitle,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 12,
                            child: Container(
                              width: double.infinity,
                              color: Colors.amber,
                              child: FloatingActionButton(
                                onPressed: null,
                                child: CustomText(text: 'Add to Favorites'),
                                backgroundColor: Colors.transparent,
                                //Removes shadow left behind when i make color transparent
                                disabledElevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //author, status, genres, updated, viewCount, rating
              Container(
                color: Colors.green,
                width: double.infinity,
              ),
              //Synopsis
              Container(
                color: Colors.blue,
                width: double.infinity,
              ),
              //Chapters
              Container(
                color: Colors.yellow,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
