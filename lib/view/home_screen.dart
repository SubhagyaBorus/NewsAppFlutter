import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/view/category_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view/view_model/news_view_model.dart';

import '../models/categories_news_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, arstechnica, ansa, reuters, cnn, aftenposten }

class _HomeScreenState extends State<HomeScreen> {
  final formal = DateFormat('MMMM dd, yyyy');
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(),
                  ));
            },
            icon: Center(
              child: Image.asset(
                "assets/images/category_icon.png",
                height: 30,
                width: 30,
              ),
            )),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            "News",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 24),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.arstechnica.name == item.name) {
                name = 'ars-technica';
              }
              if (FilterList.ansa.name == item.name) {
                name = 'ansa';
              }
              if (FilterList.cnn.name == item.name) {
                name = 'cnn';
              }
              if (FilterList.aftenposten.name == item.name) {
                name = 'aftenposten';
              }
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews, child: Text("BBC News")),
              PopupMenuItem<FilterList>(
                  value: FilterList.arstechnica, child: Text("Ars-Technica")),
              PopupMenuItem<FilterList>(
                  value: FilterList.cnn, child: Text("CNN")),
              PopupMenuItem<FilterList>(
                  value: FilterList.cnn, child: Text("ANSA.it")),
              PopupMenuItem<FilterList>(
                  value: FilterList.aftenposten, child: Text("Aftenposten"))
            ],
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                    newImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newsTitle: snapshot
                                        .data!.articles![index].title
                                        .toString(),
                                    newsDate:
                                        formal.format(dateTime).toString(),
                                    author: snapshot.data!.articles![index].author
                                        .toString(),
                                    description: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    content: snapshot
                                        .data!.articles![index].content
                                        .toString(),
                                    source: snapshot
                                        .data!.articles![index].source!.name
                                        .toString()),
                              ));
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * .02),
                                width: width * .9,
                                height: height * 0.6,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    placeholder: (context, url) =>
                                        Container(child: spinKitFadingCircle),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    height: height * .22,
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                formal
                                                    .format(dateTime)
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                } else {
                  return Container(
                    height: height,
                    width: width,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailScreen(
                                    newImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newsTitle: snapshot
                                        .data!.articles![index].title
                                        .toString(),
                                    newsDate:
                                        formal.format(dateTime).toString(),
                                    author: snapshot.data!.articles![index].author
                                        .toString(),
                                    description: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    content: snapshot
                                        .data!.articles![index].content
                                        .toString(),
                                    source: snapshot
                                        .data!.articles![index].source!.name
                                        .toString()),
                              )),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    width: width * .31,
                                    height: height * .24,
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    placeholder: (context, url) => Container(
                                      child: SpinKitCircle(
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                height: height * .24,
                                child: Column(
                                  children: [
                                    Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * .18,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            formal.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKitFadingCircle = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
