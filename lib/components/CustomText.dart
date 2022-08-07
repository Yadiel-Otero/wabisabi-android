import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  //const CustomText({Key? key}) : super(key: key);
  String text;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  int? maxLines;

  CustomText({required this.text, this.fontSize, this.fontWeight, this.color, this.maxLines}) {
    fontSize = this.fontSize ?? 16;
    fontWeight = this.fontWeight ?? FontWeight.w500;
    color = this.color ?? Colors.white;
    maxLines = this.maxLines ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      //softWrap: true,
      overflow: TextOverflow.ellipsis, //add three dots at text overflow
      maxLines: maxLines, //max lines of text before ellipsis
      style: GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
