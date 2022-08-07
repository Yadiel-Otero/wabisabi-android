import 'package:flutter/material.dart';
import 'package:wabisabi/components/HomeScreen/MangaLoading.dart';
import '../constants/constants.dart';
import 'package:web_scraper/web_scraper.dart';

class ContentScreen extends StatefulWidget {
  //ContentScreen({Key? key}) : super(key: key);
  final String url;
  bool imagesLoaded = false;
  late List<Map<String, dynamic>> mangaImages;

  ContentScreen({required this.url});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  void fetchMangaImages() async {
    final webscraper = WebScraper(Constants.chapUrl);

    //if no route available, leave blank
    if (await webscraper.loadWebPage(widget.url)) {
      widget.mangaImages = webscraper.getElement(
        'div.container-chapter-reader > img',
        ['src'],
      );

      setState(() {
        widget.imagesLoaded = true;
      });
    }
    print(widget.mangaImages);
  }

  @override
  void initState() {
    super.initState();
    fetchMangaImages();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.imagesLoaded
          ? Container(
              height: screenSize.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < widget.mangaImages.length; i++)
                      Image.network(
                        widget.mangaImages[i]['attributes']['src'],
                      ),
                  ],
                ),
              ),
            )
          : MangaLoading(),
    );
  }
}
