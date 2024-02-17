import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newImage,
      newsTitle,
      newsDate,
      author,
      description,
      content,
      source;

  const NewsDetailScreen(
      {super.key,
      required this.newImage,
      required this.newsTitle,
      required this.newsDate,
      required this.author,
      required this.description,
      required this.content,
      required this.source});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            height: height * .45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              child: CachedNetworkImage(
                imageUrl: newImage.toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(right: 20, left: 20, top: 20),
            width: width,
            height: height * .6,
            child: ListView(
              children: [
                Text(
                  newsTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      source,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      newsDate,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                SizedBox(
                  height: height * .02,
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
