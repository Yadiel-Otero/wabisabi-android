import 'package:flutter/material.dart';
import '../components/homeScreen/MangaCard.dart';

class DetailScreen extends StatelessWidget {
  //const DetailScreen({Key? key}) : super(key: key);
  final MangaCard mangaCard;

  DetailScreen({
    required this.mangaCard,
  }) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child:
        Text('hello'),
      ),
    );
  }
}
