/*
  --------------------------------------------------------------------------------
  | THE HOMESCREEN.DART FILE IS USED FOR MODELING THE HOMESCREEN.                                                                     
  | - This is the MAIN screen and what you will see when you open the app.
  | - This file stores the mangaList that's scraped AND the scraper mechanics are                                                                          
  |   programmed here.  
  | - Apart from the scraper, this file contains things such as                                                                    
  --------------------------------------------------------------------------------
 
*/
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart'; //WebScraper
import '../constants/constants.dart'; //Colors, baseURL, etc...
import '../components/MangaCard.dart'; //Manga card item
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
  bool mangaLoaded = false;

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

  Widget build(BuildContext context) {
    Size screenSize =
        MediaQuery.of(context).size; //used to retrieve device screen size

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Constants.lightGray,
      ),
      body: mangaLoaded
          ? Container(
              height: screenSize.height,
              width: screenSize.width,
              color: Constants.black,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                //reason for wrap is so that if it goes out of bounds it will automatically go down
                child: Wrap(
                  children: [
                    //START OF MANGA NUM CONTAINER
                    Container(
                      //color: Colors.blue, //DEBUGGING
                      width: double
                          .infinity, //tbh i dont know what this does, if i comment it out nothing changes
                      height: 30, //makes the container 30px tall
                      padding: EdgeInsets.only(left: 10), //moves
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: mangaList.length.toString() + ' Manga',
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
                  ],
                ),
              ),
            )
          : Container(
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
            ),
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
