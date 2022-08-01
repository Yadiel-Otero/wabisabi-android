/*
  --------------------------------------------------------------------------------
  | THE HOMESCREEN.DART FILE IS USED FOR MODELING THE HOMESCREEN.                |                                                    
  | - This is the MAIN screen and what you will see when you open the app.       |
  | - The appbar, body and bottom navigation bar are coded here.                 |
  |                                                                              |
  | - This file stores the scraped manga list and urls and passes it as a        |
  |    parameter to the MangaList.dart widget constructor so it can work its     | 
  |    magic.
  |  - Apart from the scraper, this file contains things such as                  |                                                 
  --------------------------------------------------------------------------------
 
*/
import 'package:flutter/material.dart';
import 'package:wabisabi/components/homeScreen/MangaList.dart';
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
  late List<Map<String, dynamic>> mangaList;
  late List<Map<String, dynamic>> mangaListLinks;
  bool mangaLoaded = false; //For mangaList

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
    final webscraper = WebScraper(Constants.baseUrl);

    //if no route available, leave blank
    if (await webscraper.loadWebPage('/www')) {
      mangaList = webscraper.getElement(
        'div.container.container-main > div.container-main-left > div.panel-content-homepage > div > a > img', //manga
        ['src', 'alt'],
      );
      mangaListLinks = webscraper.getElement(
        'div.container.container-main > div.container-main-left > div.panel-content-homepage > div > a', //manga
        ['href'],
      );
    }

    for (int i = 0; i < mangaList.length; i++) print(mangaListLinks);

    //mangaList[i]['attributes'].removeWhere((key, value) => key == key || value == null); //for removing null values
    //print(mangaList); //manga
    //print(mangaList[i]['attributes']['src']); //manga
    setState(() {
      mangaLoaded = true;
    });
  }

  //I dont know what this does
  @override
  void initState() {
    super.initState();
    fetchManga();
  }

  //Function that handles the opening links in browser, temporarily
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    Size screenSize =
        MediaQuery.of(context).size; //used to retrieve device screen size

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Discover',
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Constants.lightGray,
      ),
      body: mangaLoaded
          ? MangaList(mangaList: mangaList, mangaListLinks: mangaListLinks)
          : MangaLoading(),
      //BOTTOM NAV BAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Constants.lightGray,
        selectedItemColor: Constants.lightblue,
        unselectedItemColor: Constants.white,
        currentIndex:
            selectedNavIndex, //We tell what the current index is, it changes dynamically with the navBarTap function
        onTap: navBarTap, //on tap we execute navBarTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Discover',
        
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
