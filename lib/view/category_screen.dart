import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';

import 'news_detail_screen.dart';
import 'view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final formal = DateFormat('MMMM dd, yyyy');
  NewsViewModel newsViewModel = NewsViewModel();

  String categoryname = 'bbc-news';
  List<String> categoryList = [
    "bbc-news",
    "Enterainment",
    'india',
    'usa',
    'asia',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        categoryname = categoryList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: categoryname == categoryList[index]
                                  ? Colors.blue
                                  : Colors.grey),
                          child: Text(
                            categoryList[index].toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryname),
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
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
