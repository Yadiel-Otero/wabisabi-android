/*
  --------------------------------------------------------------------------------
  | THE HOMESCREEN.DART FILE IS USED FOR MODELING THE HOMESCREEN.                                                                    
  | - This is the MAIN screen and what you will see when you open the app.       |
  |                
  |                                                                              |
  | - This file stores the scraped manga list and urls and passes it as a        |
  |    parameter to the MangaList.dart widget constructor so it can work its     | 
  |    magic.                                                                    |
  |                                                              
  --------------------------------------------------------------------------------

*/
import 'package:flutter/material.dart';
import 'package:wabisabi/components/homeScreen/MangaList.dart';
import 'package:wabisabi/screens/SearchScreen.dart';
import 'package:web_scraper/web_scraper.dart'; //WebScraper
import '../components/homeScreen/MangaLoading.dart';
import '../constants/constants.dart'; //Colors, baseURL, etc...
import '../components/homeScreen/MangaCard.dart'; //Manga card item
import '../components/CustomText.dart';
import 'package:google_fonts/google_fonts.dart'; //Nunito Font
import 'package:url_launcher/url_launcher.dart'; //launching url on tap

class HomeScreen extends StatefulWidget {
  //HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;
  bool mangaLoaded = false; //For mangaList
  //int routeNumber = 1;
  //int previousRoute = 0;
 
  late List<Map<String, dynamic>> mangaListTitle;
  late List<Map<String, dynamic>> mangaListImages;
  late List<Map<String, dynamic>> mangaListLinks;
  late List<Map<String, dynamic>> mangaListNextLinks;

  //Essentially
  void navBarTap(int index) {
    setState(() {
      selectedNavIndex = index;
    });
  }

  //function that scrapes the manga
  //base url is the base domain, /read is the route
  // go to https://pub.dev/packages/web_scraper for more info
  void fetchManga() async {
    final webscraper = WebScraper('https://mangapill.com');

    //if no route available, leave blank
    if (await webscraper.loadWebPage('')) {
      
      //[i][attributes][data-src]
      mangaListImages += webscraper.getElement(
        'div.container.py-4 > div > div > a >figure > img',
        ['data-src'],
      );

      
      //i need to assign title: from 1 index onward 
      mangaListTitle += webscraper.getElement(
        
        'div.container.py-4 > div > div > div > a',
        [],
      );

      mangaListLinks += webscraper.getElement(
        
        'div.container.py-4 > div > div > a',
        ['href'],
      );


    }

    //I had to remove the first index because it was taking something from another div(TEMPORARY until i fix the core problem)
    mangaListTitle.removeAt(0);

    setState(() {
      mangaLoaded = true;
    });
  }

  //It runs each of the things inside it once before drawing the screen
  @override
  void initState() {
    super.initState();
    fetchManga();
    //Needed to initialize them as empty so that i can do the first += assignment,
    //else when it entered the function it would try to sum an itself while not initialized
    mangaListTitle = [];
    mangaListLinks = [];
    mangaListNextLinks = [];
    mangaListImages = [];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.black,

      body: mangaLoaded
          ? PageView(
              children: [
                Stack(
                  children: [
                    MangaList(
                      mangaListImages: mangaListImages,
                      mangaListTitle: mangaListTitle,
                      mangaListLinks: mangaListLinks,
                      //for now, no routeNumber because there is no next button in the main page
                      nextLink: fetchManga,
                      text: 'Popular Manga (DEBUGGING)',
                    ),
                  ],
                ),
                SearchScreen(),
              ],
            )
          : MangaLoading(),
    );
  }
}
