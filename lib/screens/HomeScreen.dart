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
import 'dart:ffi';

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
  bool mangaLoaded = false; //For mangaList
  int routeNumber = 1;
  int previousRoute = 0;
  String searchTerm = '';
  late List<Map<String, dynamic>> mangaList;
  late List<Map<String, dynamic>> mangaListLinks;
  late List<Map<String, dynamic>> mangaListNextLinks;
  late List<Map<String, dynamic>> mangaListSearch;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); //for the form, idk what this is

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
    if (await webscraper.loadWebPage(
        '/advanced_search?s=all&orby=topview&page=' +
            routeNumber.toString() +
            '&keyw=' +
            searchTerm)) {
      mangaList += webscraper.getElement(
        'div.panel-content-genres > div > a > img',
        ['src', 'alt'],

        //'div.container.container-main > div.container-main-left > div.panel-content-homepage > div > a > img', //manga
        //['src', 'alt'],
      );
      mangaListLinks += webscraper.getElement(
        'div.panel-content-genres > div > a',
        ['href'],

        //'div.container.container-main > div.container-main-left > div.panel-content-homepage > div > a', //manga
        //['href'],
      );

      mangaListNextLinks += webscraper.getElement(
        'div.panel-page-number > div.group-page > a',
        ['href'],
      );

      mangaListSearch = webscraper.getElement(
        'div.panel-page-number > div.group-page > a',
        ['href'],
      );
    }

    for (int i = 0; i < mangaList.length; i++) print(mangaListNextLinks);
    /*
     ******************DEBUGGING**********************
    mangaList[i]['attributes'].removeWhere((key, value) => key == key || value == null); //for removing null values
    print(mangaList); //manga
    print(mangaListLinks);
    print(mangaList[i]['attributes']['src']); //manga
    */

    setState(() {
      mangaLoaded = true;
    });

    routeNumber++;
    previousRoute = routeNumber - 1;
  }

  //I dont know what this does
  @override
  void initState() {
    super.initState();
    fetchManga();
    //Needed to initialize them as empty so that i can do the first += assignment,
    //else when it entered the function it would try to sum an itself while not initialized
    mangaList = [];
    mangaListLinks = [];
    mangaListNextLinks = [];
    mangaListSearch = [];
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
      backgroundColor: Constants.black,
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
          ? Stack(
              children: [
                MangaList(
                  mangaList: mangaList,
                  mangaListLinks: mangaListLinks,
                  nextLink: fetchManga,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (value) => {
                          searchTerm = value,
                          //debugging purposes
                          print(searchTerm),
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white),
                          hintText: 'Feeling wacky?',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String? value) => setState(
                          () {
                            fetchManga();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
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
