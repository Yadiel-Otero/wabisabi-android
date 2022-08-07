/*
  --------------------------------------------------------------------------------
  | THIS COMPONENT IS RESPONSIBLE FOR DISPLAYING THE MANGA IMAGE, TITLE, URL,    |
  | ETC... IN THE HOMESCREEN.DART FILE                                           |                      
  |                                                                              |
  |  In short, a manga image, title and url is webscraped and passed on to this  |   
  |  widget to render a box with said info.                                      |
  --------------------------------------------------------------------------------
 
*/

import 'package:flutter/material.dart';
import 'package:wabisabi/screens/NewDetailScreen.dart';
//import '../../constants/constants.dart';
import '../CustomText.dart';
import 'package:url_launcher/url_launcher.dart';

class MangaCard extends StatelessWidget {
  final String mangaImg;
  final String mangaTitle;
  final Uri url;

  MangaCard(
      {required this.mangaImg, required this.mangaTitle, required this.url});

  //function used to launch in browser on tap but its no longer in use
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    //On tap: go to DetailScreen
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => NewDetailScreen(
              mangaImg: mangaImg,
              mangaTitle: mangaTitle,
              url: url,
            ),
          ),
        ),
      },
      child: Container(
        //margin on all sides to get a bit of space between each card
        margin: EdgeInsetsDirectional.all(7),
        //color: Colors.blue, //DEBUGGING
        height: 240, //makes manga card 250px tall
        width: 115, //makes manga card 130px wide

        child: Column(
          children: [
            Expanded(
              flex: 65, //makes the container fill its parent, kinda
              child: Container(
                width: double.infinity, //fill its parent
                height: double.infinity,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                //ClipRRect is for rounded image corners
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    mangaImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment:
                    Alignment.topLeft, //Title starts from top left of container

                child: CustomText(
                  text: mangaTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
