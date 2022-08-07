import 'package:flutter/material.dart';
import '../components/homeScreen/MangaCard.dart';
import '../constants/constants.dart';
import '../components/CustomText.dart';

class DetailScreen extends StatelessWidget {
  //const DetailScreen({Key? key}) : super(key: key);
  final String mangaImg;
  final String mangaTitle;
  final Uri url;
  String? author;
  String? status;
  String? genre; //I'll have to see
  String? lastUpdated;
  String? viewCount;
  String? rating;



  DetailScreen(
      {required this.mangaImg, required this.mangaTitle, required this.url}) {
        author = this.author ?? 'Not Available';
        status = this.status ?? 'Not Available';
        genre = this.genre ?? 'Not Available';
        lastUpdated = this.lastUpdated ?? 'Not Available';
        viewCount = this.viewCount ?? 'Not Available';
        rating = this.rating ?? 'Not Available';
      }

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
                                onPressed: (() => print('Hello')),
                                child: CustomText(text: 'Add to Favorites'),
                                backgroundColor: Colors.transparent,
                                //Removes shadow while idle
                                elevation: 0,
                                //Removes shadow on press
                                highlightElevation: 0,
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: 'Author(s): ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'Status: ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'Genres: ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'Updated: ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'View Count: ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(
                          text: 'Rating: ',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Synopsis
              Container(
                color: Colors.blue,
                width: double.infinity,
                child: Column(
                  children: [
                    CustomText(
                      text: 'Synopsis',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )
                  ],
                ),
              ),
              //Chapters
              Container(
                color: Colors.orange,
                width: double.infinity,
                child: Column(
                  children: [
                    CustomText(
                      text: 'Chapters',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    //for loop to generate as many rows with double.infinity width as there are chapters
                    //rows()...
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
