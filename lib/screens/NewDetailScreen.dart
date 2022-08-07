import 'package:flutter/material.dart';
import '../components/homeScreen/MangaCard.dart';
import '../constants/constants.dart';
import '../components/CustomText.dart';
import 'package:web_scraper/web_scraper.dart'; //WebScraper

class NewDetailScreen extends StatefulWidget {
  final String mangaImg;
  final String mangaTitle;
  final Uri url;
  String author = '';
  String status = '';
  String genre = ''; //I'll have to see if they can be clickable
  String lastUpdated = '';
  String viewCount = '';
  String rating = '';
  String description = '';
  bool detailsLoaded = false;
  late List<Map<String, dynamic>> topDetails;
  late List<Map<String, dynamic>> topDetails2;
  late List<Map<String, dynamic>> topDetails3;
  late List<Map<String, dynamic>> topDetailsException;
  late List<Map<String, dynamic>> descriptionDetails;
  String detailsFirstValue = '';

  NewDetailScreen(
      {required this.mangaImg, required this.mangaTitle, required this.url}) {}
  @override
  State<NewDetailScreen> createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
  void fetchMangaDetails() async {
    final webscraper = WebScraper(Constants.chapUrl);

    //if no route available, leave blank
    if (await webscraper.loadWebPage(
      widget.url
          .toString()
          .replaceAll(RegExp('https://chapmanganelo.com/'), ''),
    )) {
      widget.topDetails = webscraper.getElement(
        'div.story-info-right > table > tbody > tr > td.table-value',
        [],
      );
      widget.topDetails2 = webscraper.getElement(
        'div.story-info-right-extent > p > span.stre-value',
        [],
      );

      widget.topDetails3 = webscraper.getElement(
        'div.story-info-right-extent > p >  em',
        [],
      );

      widget.topDetailsException = webscraper.getElement(
        'div.story-info-right > table > tbody > tr > td',
        [],
      );

      widget.descriptionDetails = webscraper.getElement(
        'div#panel-story-info-description.panel-story-info-description',
        [],
      );

      //to determine if alternative or author is first
      widget.detailsFirstValue = widget.topDetailsException[0]['title'];
    }

    /*logic to skip a table row and assign correct values 
      because sometimes there was a Alternative names row
      and it would move all the other rows down by one
      
      also, .trim() is used to remove all whitespaces*/
    if (widget.detailsFirstValue == 'Alternative :') {
      widget.author = widget.topDetails[1]['title'].toString().trim();
      widget.status = widget.topDetails[2]['title'].toString().trim();
      widget.genre = widget.topDetails[3]['title'].toString().trim();
      widget.lastUpdated = widget.topDetails2[0]['title'].toString().trim();
      widget.viewCount = widget.topDetails2[1]['title'].toString().trim();
      widget.rating = widget.topDetails3[0]['title'].toString().replaceAll('MangaNelo.com rate :', '').trim();
      widget.description = widget.descriptionDetails[0]['title'].toString().replaceAll('Description :', '').trim();
    } else {
      widget.author = widget.topDetails[0]['title'].toString().trim();
      widget.status = widget.topDetails[1]['title'].toString().trim();
      widget.genre = widget.topDetails[2]['title'].toString().trim();
      widget.lastUpdated = widget.topDetails2[0]['title'].toString().trim();
      widget.viewCount = widget.topDetails2[1]['title'].toString().trim();
      widget.rating = widget.topDetails3[0]['title'].toString().replaceAll('MangaNelo.com rate :', '').trim();
    }

    //print(widget.description);

    /*
     ******************DEBUGGING**********************
  print('Author: ' +
        widget.author +
        '\n' +
        'Status: ' +
        widget.status +
        '\n' +
        'Genre: ' +
        widget.genre +
        '\n');
    
    print(widget.topDetails);
    
    print(widget.detailsFirstValue);
    */

    setState(() {
      widget.detailsLoaded = true;
    });
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
                      text: 'Author(s): ' + widget.author,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
          
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
                    CustomText(
                      text: 'Updated: ' + widget.lastUpdated,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText(
                      text: 'View Count: ' + widget.viewCount,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText(
                      text: 'Rating: ' + widget.rating,
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
