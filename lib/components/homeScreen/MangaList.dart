//this component passes the manga list and urls received from the HomeScreen
//to the MangaCard component to generate many nice looking square MangaCards

import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../CustomText.dart';
import 'MangaCard.dart';

class MangaList extends StatelessWidget {
  //const MangaList({Key? key}) : super(key: key);

//no need to be late since im receiving it as a parameter
  List<Map<String, dynamic>> mangaList;
  List<Map<String, dynamic>> mangaListLinks;
  Function nextLink;
  int? routeNumber;

  MangaList({
    required this.mangaList,
    required this.mangaListLinks,
    required this.nextLink,
    this.routeNumber,
  }) {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Constants.black,
      margin: EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        //reason for wrap is so that if it goes out of bounds it will automatically go down
        child: Wrap(
          children: [
            //START OF MANGA NUM CONTAINER
            Container(
              //color: Colors.blue, //DEBUGGING
              width: double.infinity,
              height: 30, //makes the container 30px tall
              padding: EdgeInsets.only(left: 10), //moves
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: mangaList.length.toString() + ' Manga (DEBUGGING)',
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            //END OF MANGA NUM CONTAINER

            //START OF MangaCard CONTAINER
            //loop to generate as many cards as mangaList length
            for (int i = 0; i < mangaList.length; i++)
              Container(
                //color: Colors.red, //DEBUGGING
                child: MangaCard(
                  mangaImg: mangaList[i]['attributes']['src'],
                  mangaTitle: mangaList[i]['attributes']['alt'],
                  url: Uri.parse(
                    mangaListLinks[i]['attributes']['href'],
                  ), //Makes the string a Uri object so i can pass it to the URI member inside mangaCard
                ),
              ),

            /* Center(
                        child: MangaCard(
                          mangaImg:
                              'https://avt.mkklcdnv6temp.com/48/k/24-1634298190.jpg',
                          mangaTitle: 'The Lone Necromancer',
                        ),
                      ),
                      */
            Center(
              child: FloatingActionButton(
                onPressed: () => {nextLink()},
                child: Icon(Icons.arrow_forward),
                backgroundColor: Constants.lightGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
