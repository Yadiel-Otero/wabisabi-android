import 'package:flutter/material.dart';
import 'package:wabisabi/components/homeScreen/MangaList.dart';
import 'package:wabisabi/screens/DetailScreen.dart';
import 'package:web_scraper/web_scraper.dart'; //WebScraper
import '../components/homeScreen/MangaLoading.dart';
import '../constants/constants.dart'; //Colors, baseURL, etc...

class SearchScreen extends StatefulWidget{
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final webscraper = WebScraper(Constants.baseUrl);
  late List<Map<String, dynamic>> mangaListSearch;
  late List<Map<String, dynamic>> mangaListSearchLinks;
  late List<Map<String, dynamic>> mangaListNextLinks;
  String searchTerm = '';
  int pageNumber = 1;
  bool searchLoaded = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SearchScreen() {}

  void fetchMangaSearch() async {
    final webscraper = WebScraper(Constants.baseUrl);

    if (await webscraper.loadWebPage('/search/story/' +
        searchTerm.replaceAll(" ", "_").toLowerCase() +
        '?page=' +
        pageNumber.toString())) {
      mangaListSearch += webscraper.getElement(
        'div.search-story-item > a > img',
        ['src', 'alt'],
      );

      mangaListSearchLinks += webscraper.getElement(
        'div.search-story-item > a',
        ['href'],
      );
    }

    setState(() {
      pageNumber++;
      print('page number: ' + pageNumber.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    //Needed to initialize them as empty so that i can do the first += assignment,
    //else when it entered the function it would try to sum an itself while not initialized
    mangaListSearch = [];
    mangaListSearchLinks = [];
    pageNumber = 1; //so that it resets when i switch pages
  }

  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Constants.black,
      body: searchLoaded
          ? Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: MangaList(
                    mangaList: mangaListSearch,
                    mangaListLinks: mangaListSearchLinks,
                    nextLink: fetchMangaSearch,
                    text: 'Search Results',
                  ),
                ),
                Positioned(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
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
                              pageNumber = 1,
                              mangaListSearch = [],
                              mangaListSearchLinks = [],
                            },
                            decoration: InputDecoration(
                              fillColor: Constants.lightGray,
                              filled: true,
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
                                fetchMangaSearch();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : MangaLoading(),
    ));
  }
}
