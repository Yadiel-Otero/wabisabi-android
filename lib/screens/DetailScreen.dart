import 'package:flutter/material.dart';
import 'package:wabisabi/components/HomeScreen/MangaLoading.dart';
import '../components/homeScreen/MangaCard.dart';
import '../constants/constants.dart';
import '../components/CustomText.dart';
import "ContentScreen.dart";
import 'package:web_scraper/web_scraper.dart'; //WebScraper
import 'package:url_launcher/url_launcher.dart'; //launching url on tap

class DetailScreen extends StatefulWidget {
  final String mangaImg;
  final String mangaTitle;
  final Uri url;
  //String author = '';
  String status = '';
  String type = '';
  String genre = '';
  //String lastUpdated = '';
  //String viewCount = '';
  //String rating = '';
  String description = '';
  String year = '';
  bool detailsLoaded = false;
  late List<Map<String, dynamic>> descriptionScraped;
  late List<Map<String, dynamic>> typeStatusYearScraped;
  late List<Map<String, dynamic>> genreScraped;
  late List<Map<String, dynamic>> chapterListScraped;

  DetailScreen(
      {required this.mangaImg, required this.mangaTitle, required this.url}) {}
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void fetchMangaDetails() async {
    final webscraper = WebScraper('https://mangapill.com');

    //if no route available, leave blank
    if (await webscraper.loadWebPage(widget.url.toString().trim())) {
      //[i]['title']
      widget.descriptionScraped = webscraper.getElement(
        'div.container > div > div > div > p',
        [],
      );

      //remove index[0]
      //[i][title] - 0 type, 1 status, 2 year
      widget.typeStatusYearScraped = webscraper.getElement(
        'div.container > div > div > div > div > div',
        [],
      );

      //[i]['title']
      widget.genreScraped = webscraper.getElement(
        'div.container > div > div > div.mb-3 > a',
        [],
      );

      //[i]['title'] for title
      //[i]['attributes']['href'] for chapter link
      widget.chapterListScraped = webscraper.getElement(
        'div.container > div.border.border-border.rounded > div#chapters.p-3 > div > a',
        ['href'],
      );
    }

    //To remove first index that display useless info (TEMPORARY)
    widget.typeStatusYearScraped.removeAt(0);

    setState(() {
      widget.detailsLoaded = true;
    });

    widget.description = widget.descriptionScraped[0]['title'];
    widget.type = widget.typeStatusYearScraped[0]['title'];
    widget.status = widget.typeStatusYearScraped[1]['title'];
    widget.year = widget.typeStatusYearScraped[2]['title'];

    for (int i = 0; i < widget.genreScraped.length; i++) {
      widget.genre += ' ' + widget.genreScraped[i]['title'];
    }

    //print(widget.chapterListScraped);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMangaDetails();
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.black,
      body: widget.detailsLoaded
          ? Container(
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
                                widget.mangaImg,
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
                                      text: widget.mangaTitle,
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
                                      child: CustomText(
                                        text: 'Add to Favorites',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
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
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          CustomText(
                            text: 'Status: ' + widget.status,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          CustomText(
                            text: 'Genre: ' + widget.genre,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.blue,
                      width: double.infinity,
                      child: Column(
                        children: [
                          CustomText(
                            text: 'Synopsis',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                          CustomText(
                            text: widget.description,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            maxLines: 100,
                          ),
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
                          for (int i = 0;
                              i < widget.chapterListScraped.length;
                              i++)
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ContentScreen(
                                    //You would pass the chapters so the 
                                    //images would be displayed
                                    ),
                                  ),
                                ),
                              },
                              child: Container(
                                width: 360,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Constants.lightGray,
                                ),
                                height: 50,
                                child: CustomText(
                                  fontWeight: FontWeight.w800,
                                  maxLines: 2,
                                  text: widget.chapterListScraped[i]['title'],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : MangaLoading(),
    );
  }
}
